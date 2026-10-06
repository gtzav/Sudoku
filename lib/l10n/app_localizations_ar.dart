// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get difficultyEasy => 'سهل';

  @override
  String get difficultyMedium => 'متوسط';

  @override
  String get difficultyHard => 'صعب';

  @override
  String mistakes(int count) {
    return 'الأخطاء: $count';
  }

  @override
  String get newGame => 'لعبة جديدة';

  @override
  String newGameWithDifficulty(String difficulty) {
    return 'لعبة جديدة: $difficulty';
  }

  @override
  String get notesTooltip => 'ملاحظات (P)';

  @override
  String get eraseTooltip => 'حذف (Del)';

  @override
  String get language => 'اللغة';

  @override
  String get systemLanguage => 'لغة النظام';

  @override
  String get solvedTitle => 'تم الحل!';

  @override
  String solvedMessage(String difficulty, String time, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'with $count errors',
      one: 'with 1 error',
      zero: 'no errors',
    );
    return '$difficulty in $time, $_temp0.';
  }

  @override
  String get close => 'إغلاق';
}
