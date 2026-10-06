// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'Σουντόκου';

  @override
  String get difficultyEasy => 'Εύκολο';

  @override
  String get difficultyMedium => 'Μεσαίο';

  @override
  String get difficultyHard => 'Δύσκολο';

  @override
  String mistakes(int count) {
    return 'Λάθη: $count';
  }

  @override
  String get newGame => 'Νέο παιχνίδι';

  @override
  String newGameWithDifficulty(String difficulty) {
    return 'Νέο παιχνίδι: $difficulty';
  }

  @override
  String get notesTooltip => 'Σημειώσεις (P)';

  @override
  String get eraseTooltip => 'Διαγραφή (Del)';

  @override
  String get language => 'Γλώσσα';

  @override
  String get systemLanguage => 'Γλώσσα συστήματος';

  @override
  String get solvedTitle => 'Λύθηκε!';

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
      other: 'με $count λάθη',
      one: 'με 1 λάθος',
      zero: 'χωρίς λάθη',
    );
    return '$difficulty σε $time, $_temp0.';
  }

  @override
  String get close => 'Κλείσιμο';
}
