// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get difficultyEasy => 'Fácil';

  @override
  String get difficultyMedium => 'Medio';

  @override
  String get difficultyHard => 'Difícil';

  @override
  String mistakes(int count) {
    return 'Errores: $count';
  }

  @override
  String get newGame => 'Nueva partida';

  @override
  String newGameWithDifficulty(String difficulty) {
    return 'Nueva partida: $difficulty';
  }

  @override
  String get notesTooltip => 'Notas (P)';

  @override
  String get eraseTooltip => 'Borrar (Del)';

  @override
  String get language => 'Idioma';

  @override
  String get systemLanguage => 'Idioma del sistema';

  @override
  String get solvedTitle => '¡Resuelto!';

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
      other: 'con $count errores',
      one: 'con 1 error',
      zero: 'sin errores',
    );
    return '$dificultad en $time, $_temp0.';
  }

  @override
  String get close => 'Cerrar';
}
