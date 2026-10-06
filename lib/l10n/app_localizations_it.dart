// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get difficultyEasy => 'Facile';

  @override
  String get difficultyMedium => 'Media';

  @override
  String get difficultyHard => 'Difficile';

  @override
  String mistakes(int count) {
    return 'Errori: $count';
  }

  @override
  String get newGame => 'Nuova partita';

  @override
  String newGameWithDifficulty(String difficulty) {
    return 'Nuova partita: $difficulty';
  }

  @override
  String get notesTooltip => 'Note (P)';

  @override
  String get eraseTooltip => 'Cancella (Del)';

  @override
  String get language => 'Lingua';

  @override
  String get systemLanguage => 'Lingua di sistema';

  @override
  String get solvedTitle => 'Risolto!';

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
      other: 'con $count errori',
      one: 'con 1 errore',
      zero: 'nessun errore',
    );
    return '$difficulty in $time, $_temp0.';
  }

  @override
  String get close => 'Chiudi';
}
