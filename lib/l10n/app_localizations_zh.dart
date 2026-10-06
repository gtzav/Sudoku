// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '数独';

  @override
  String get difficultyEasy => '简单';

  @override
  String get difficultyMedium => '中等';

  @override
  String get difficultyHard => '困难';

  @override
  String mistakes(int count) {
    return '错误数：$count';
  }

  @override
  String get newGame => '新游戏';

  @override
  String newGameWithDifficulty(String difficulty) {
    return '新游戏：$difficulty';
  }

  @override
  String get notesTooltip => '备注 (P)';

  @override
  String get eraseTooltip => '删除 (Del)';

  @override
  String get language => '语言';

  @override
  String get systemLanguage => '系统语言';

  @override
  String get solvedTitle => '已解出！';

  @override
  String solvedMessage(String difficulty, String time, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有 $count 个错误',
      one: '有 1 个错误',
      zero: '无错误',
    );
    return '$difficulty 用时 $time，$_temp0.';
  }

  @override
  String get close => '关闭';
}
