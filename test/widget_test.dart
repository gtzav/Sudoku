// Named widget_test.dart on purpose: `flutter create .` skips this file when it
// exists, instead of generating a default test that references a missing MyApp.
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_flutter/src/sudoku.dart';

void main() {
  for (final d in Difficulty.values) {
    test('${d.label} puzzle is valid and has exactly one solution', () {
      final p = SudokuGenerator().generate(d);

      // Solution is a complete, valid grid.
      for (var i = 0; i < 81; i++) {
        expect(p.solution[i], inInclusiveRange(1, 9));
        expect(isValidPlacement(p.solution, i, p.solution[i]), isTrue);
      }
      // Every given agrees with the solution.
      for (var i = 0; i < 81; i++) {
        if (p.givens[i] != 0) expect(p.givens[i], p.solution[i]);
      }
      // Unique solution.
      expect(countSolutions(List.of(p.givens), 2), 1);
    });
  }
}
