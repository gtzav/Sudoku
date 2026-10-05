import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'l10n/app_localizations.dart';
import 'src/board_painter.dart';
import 'src/game.dart';
import 'src/sudoku.dart';

void main() => runApp(const SudokuApp());

class SudokuApp extends StatefulWidget {
  const SudokuApp({super.key});

  @override
  State<SudokuApp> createState() => _SudokuAppState();
}

class _SudokuAppState extends State<SudokuApp> {
  /// null = follow the system language.
  Locale? _locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      locale: _locale,
      // Includes the Material/Cupertino/Widgets delegates, so built-in
      // widgets (dialogs, tooltips, menus) are translated as well.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: SudokuPage(
        locale: _locale,
        onLocaleChanged: (l) => setState(() => _locale = l),
      ),
    );
  }
}

class SudokuPage extends StatefulWidget {
  const SudokuPage({
    super.key,
    required this.locale,
    required this.onLocaleChanged,
  });

  final Locale? locale;
  final ValueChanged<Locale?> onLocaleChanged;

  @override
  State<SudokuPage> createState() => _SudokuPageState();
}

class _SudokuPageState extends State<SudokuPage> {
  final _game = Game();
  final _focus = FocusNode();
  Timer? _ticker;
  bool _dialogShown = false;

  static final _digitKeys = <LogicalKeyboardKey, int>{
    LogicalKeyboardKey.digit1: 1, LogicalKeyboardKey.numpad1: 1,
    LogicalKeyboardKey.digit2: 2, LogicalKeyboardKey.numpad2: 2,
    LogicalKeyboardKey.digit3: 3, LogicalKeyboardKey.numpad3: 3,
    LogicalKeyboardKey.digit4: 4, LogicalKeyboardKey.numpad4: 4,
    LogicalKeyboardKey.digit5: 5, LogicalKeyboardKey.numpad5: 5,
    LogicalKeyboardKey.digit6: 6, LogicalKeyboardKey.numpad6: 6,
    LogicalKeyboardKey.digit7: 7, LogicalKeyboardKey.numpad7: 7,
    LogicalKeyboardKey.digit8: 8, LogicalKeyboardKey.numpad8: 8,
    LogicalKeyboardKey.digit9: 9, LogicalKeyboardKey.numpad9: 9,
  };

  @override
  void initState() {
    super.initState();
    _game.addListener(_onGameChanged);
    _game.newGame(Difficulty.medium);
    // Refresh the clock once a second while a game is in progress.
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_game.isRunning) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _game.removeListener(_onGameChanged);
    _game.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onGameChanged() {
    if (!_game.solved) {
      _dialogShown = false;
      return;
    }
    if (_dialogShown) return;
    _dialogShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showSolvedDialog();
    });
  }

  /// Localized name of a difficulty. The enum itself stays UI-free.
  static String _difficultyName(AppLocalizations l10n, Difficulty d) =>
      switch (d) {
        Difficulty.easy => l10n.difficultyEasy,
        Difficulty.medium => l10n.difficultyMedium,
        Difficulty.hard => l10n.difficultyHard,
      };

  Future<void> _showSolvedDialog() async {
    final again = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(l10n.solvedTitle),
          content: Text(l10n.solvedMessage(
            _difficultyName(l10n, _game.difficulty),
            _fmt(_game.elapsed),
            _game.mistakes,
          )),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.close),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.newGame),
            ),
          ],
        );
      },
    );
    if (!mounted) return;
    if (again == true) _game.newGame(_game.difficulty);
    _focus.requestFocus();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    final digit = _digitKeys[key];
    if (digit != null) {
      _game.enter(digit);
    } else if (key == LogicalKeyboardKey.arrowUp) {
      _game.move(-1, 0);
    } else if (key == LogicalKeyboardKey.arrowDown) {
      _game.move(1, 0);
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      _game.move(0, -1);
    } else if (key == LogicalKeyboardKey.arrowRight) {
      _game.move(0, 1);
    } else if (key == LogicalKeyboardKey.backspace ||
        key == LogicalKeyboardKey.delete ||
        key == LogicalKeyboardKey.digit0 ||
        key == LogicalKeyboardKey.numpad0) {
      _game.clear();
    } else if (key == LogicalKeyboardKey.keyP) {
      _game.toggleNotes();
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  static String _fmt(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: _game,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.translate),
              tooltip: l10n.language,
              initialValue: widget.locale?.languageCode ?? '',
              onSelected: (code) =>
                  widget.onLocaleChanged(code.isEmpty ? null : Locale(code)),
              itemBuilder: (context) => [
                PopupMenuItem(value: '', child: Text(l10n.systemLanguage)),
                // Language names in their own language, by convention.
                const PopupMenuItem(value: 'en', child: Text('English')),
                const PopupMenuItem(value: 'el', child: Text('Ελληνικά')),
              ],
            ),
            PopupMenuButton<Difficulty>(
              icon: const Icon(Icons.add),
              tooltip: l10n.newGame,
              onSelected: _game.newGame,
              itemBuilder: (context) => [
                for (final d in Difficulty.values)
                  PopupMenuItem(
                    value: d,
                    child: Text(l10n
                        .newGameWithDifficulty(_difficultyName(l10n, d))),
                  ),
              ],
            ),
          ],
        ),
        body: Focus(
          focusNode: _focus,
          autofocus: true,
          onKeyEvent: _onKey,
          child: SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              // Room needed below/above the board for status row + pad.
              const reserved = 190.0;
              final boardSize = math.max(
                120.0,
                math.min(
                  520.0,
                  math.min(constraints.maxWidth - 32,
                      constraints.maxHeight - reserved),
                ),
              );
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: boardSize,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _statusRow(cs, l10n),
                        const SizedBox(height: 8),
                        _board(boardSize, cs),
                        const SizedBox(height: 16),
                        _numberPad(),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _statusRow(ColorScheme cs, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${_difficultyName(l10n, _game.difficulty)}  ·  '
            '${_fmt(_game.elapsed)}  ·  ${l10n.mistakes(_game.mistakes)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          tooltip: l10n.notesTooltip,
          isSelected: _game.notesMode,
          icon: const Icon(Icons.edit_outlined),
          selectedIcon: const Icon(Icons.edit),
          style: _game.notesMode
              ? IconButton.styleFrom(backgroundColor: cs.primaryContainer)
              : null,
          onPressed: _game.toggleNotes,
        ),
        IconButton(
          tooltip: l10n.eraseTooltip,
          icon: const Icon(Icons.backspace_outlined),
          onPressed: _game.clear,
        ),
      ],
    );
  }

  Widget _board(double size, ColorScheme cs) {
    return GestureDetector(
      onTapDown: (details) {
        final cell = size / 9;
        final c = math.min(8, math.max(0, details.localPosition.dx ~/ cell));
        final r = math.min(8, math.max(0, details.localPosition.dy ~/ cell));
        _game.select(r, c);
        _focus.requestFocus();
      },
      child: Stack(
        children: [
          CustomPaint(
            size: Size.square(size),
            painter: BoardPainter(_game, BoardColors.of(cs)),
          ),
          if (_game.loading)
            const Positioned.fill(
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _numberPad() {
    return Row(
      children: [
        for (var d = 1; d <= 9; d++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _padButton(d),
            ),
          ),
      ],
    );
  }

  Widget _padButton(int d) {
    final left = 9 - _game.countPlaced(d);
    final enabled = left > 0 && _game.isRunning;
    return FilledButton.tonal(
      onPressed: enabled ? () => _game.enter(d) : null,
      style: FilledButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$d',
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
          Text(left > 0 ? '$left' : '', style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
