// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get difficultyEasy => 'Facile';

  @override
  String get difficultyMedium => 'Moyen';

  @override
  String get difficultyHard => 'Difficile';

  @override
  String mistakes(int count) {
    return 'Erreurs : $count';
  }

  @override
  String get newGame => 'Nouvelle partie';

  @override
  String newGameWithDifficulty(String difficulty) {
    return 'Nouvelle partie : $difficulty';
  }

  @override
  String get notesTooltip => 'Notes (P)';

  @override
  String get eraseTooltip => 'Supprimer (Del)';

  @override
  String get language => 'Langue';

  @override
  String get systemLanguage => 'Langue du système';

  @override
  String get solvedTitle => 'Résolu !';

  @override
  String solvedMessage(String difficulty, String time, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'avec $count erreurs',
      one: 'avec 1 erreur',
      zero: 'aucune erreur',
    );
    return '$difficulty en $time, $_temp0.';
  }

  @override
  String get close => 'Fermer';
}
