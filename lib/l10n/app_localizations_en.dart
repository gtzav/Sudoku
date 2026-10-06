// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String mistakes(int count) {
    return 'Mistakes: $count';
  }

  @override
  String get newGame => 'New game';

  @override
  String newGameWithDifficulty(String difficulty) {
    return 'New $difficulty game';
  }

  @override
  String get notesTooltip => 'Notes (P)';

  @override
  String get eraseTooltip => 'Erase (Del)';

  @override
  String get language => 'Language';

  @override
  String get systemLanguage => 'System default';

  @override
  String get solvedTitle => 'Solved!';

  @override
  String solvedMessage(
    String difficulty,
    String time,
    int count,
    Object dificultad,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mistakes',
      one: '1 mistake',
      zero: 'no mistakes',
    );
    return '$difficulty in $time, $_temp0.';
  }

  @override
  String get close => 'Close';
}
