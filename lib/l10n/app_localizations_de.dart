// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get difficultyEasy => 'Einfach';

  @override
  String get difficultyMedium => 'Mittel';

  @override
  String get difficultyHard => 'Schwer';

  @override
  String mistakes(int count) {
    return 'Fehler: $count';
  }

  @override
  String get newGame => 'Neues Spiel';

  @override
  String newGameWithDifficulty(String difficulty) {
    return 'Neues Spiel: $difficulty';
  }

  @override
  String get notesTooltip => 'Notizen (P)';

  @override
  String get eraseTooltip => 'Löschen (Del)';

  @override
  String get language => 'Sprache';

  @override
  String get systemLanguage => 'Systemsprache';

  @override
  String get solvedTitle => 'Gelöst!';

  @override
  String solvedMessage(String difficulty, String time, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mit $count Fehlern',
      one: 'mit 1 Fehler',
      zero: 'keine Fehler',
    );
    return '$difficulty in $time, $_temp0.';
  }

  @override
  String get close => 'Schließen';
}
