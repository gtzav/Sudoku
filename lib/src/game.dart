import 'package:flutter/foundation.dart';

import 'sudoku.dart';

/// Top-level so it can run in a background isolate via [compute].
Puzzle _generate(Difficulty d) => SudokuGenerator().generate(d);

/// All game state. Widgets listen to it and rebuild on [notifyListeners].
class Game extends ChangeNotifier {
  Difficulty difficulty = Difficulty.medium;
  List<int> givens = List<int>.filled(81, 0);
  List<int> solution = List<int>.filled(81, 0);
  List<int> board = List<int>.filled(81, 0);

  /// Pencil marks as bitmasks: bit d set means note d is shown.
  List<int> notes = List<int>.filled(81, 0);

  int selected = 40;
  bool notesMode = false;
  int mistakes = 0;
  bool loading = true;
  bool solved = false;

  final Stopwatch _clock = Stopwatch();
  int _request = 0;
  bool _disposed = false;

  Duration get elapsed => _clock.elapsed;
  bool get isRunning => !loading && !solved;

  /// Generates a puzzle off the UI thread, so the app never stutters.
  Future<void> newGame(Difficulty d) async {
    final request = ++_request;
    difficulty = d;
    loading = true;
    _clock
      ..stop()
      ..reset();
    notifyListeners();

    final p = await compute(_generate, d);
    // Ignore stale results if another new game was requested meanwhile.
    if (_disposed || request != _request) return;

    givens = p.givens;
    solution = p.solution;
    board = List<int>.of(p.givens);
    notes = List<int>.filled(81, 0);
    selected = 40;
    notesMode = false;
    mistakes = 0;
    solved = false;
    loading = false;
    _clock.start();
    notifyListeners();
  }

  bool isGiven(int i) => givens[i] != 0;
  bool isWrong(int i) => board[i] != 0 && board[i] != solution[i];

  /// How many cells correctly hold digit [d].
  int countPlaced(int d) {
    var n = 0;
    for (var i = 0; i < 81; i++) {
      if (board[i] == d && solution[i] == d) n++;
    }
    return n;
  }

  void select(int row, int col) {
    selected = row * 9 + col;
    notifyListeners();
  }

  void move(int dRow, int dCol) {
    final r = (selected ~/ 9 + dRow) % 9; // Dart's % is never negative
    final c = (selected % 9 + dCol) % 9;
    select(r, c);
  }

  void toggleNotes() {
    notesMode = !notesMode;
    notifyListeners();
  }

  void enter(int d) {
    if (!isRunning || isGiven(selected)) return;

    if (notesMode) {
      if (board[selected] == 0) notes[selected] ^= 1 << d;
    } else if (board[selected] == d) {
      board[selected] = 0; // pressing the same digit again erases it
    } else {
      board[selected] = d;
      notes[selected] = 0;
      if (d != solution[selected]) {
        mistakes++;
      } else {
        _clearPeerNotes(selected, d);
        if (listEquals(board, solution)) {
          solved = true;
          _clock.stop();
        }
      }
    }
    notifyListeners();
  }

  void clear() {
    if (!isRunning || isGiven(selected)) return;
    board[selected] = 0;
    notes[selected] = 0;
    notifyListeners();
  }

  void _clearPeerNotes(int idx, int d) {
    final mask = ~(1 << d);
    for (var i = 0; i < 81; i++) {
      if (arePeers(i, idx)) notes[i] &= mask;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
