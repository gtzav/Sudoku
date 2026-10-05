/// Pure-Dart Sudoku logic with no Flutter dependency.
/// Boards are flat lists of 81 ints, row-major, with 0 meaning empty.
library;

import 'dart:math';

enum Difficulty {
  easy(40, 'Easy'),
  medium(32, 'Medium'),
  hard(26, 'Hard');

  const Difficulty(this.targetClues, this.label);

  /// Givens to aim for. The generator stops removing earlier if no further
  /// cell can be removed without breaking uniqueness.
  final int targetClues;
  final String label;
}

class Puzzle {
  Puzzle(this.givens, this.solution);
  final List<int> givens;
  final List<int> solution;
}

/// True if digit [d] can sit at [idx] without clashing with its row,
/// column or 3x3 box. The cell itself is ignored.
bool isValidPlacement(List<int> b, int idx, int d) {
  final r = idx ~/ 9, c = idx % 9;
  for (var k = 0; k < 9; k++) {
    final rowIdx = r * 9 + k, colIdx = k * 9 + c;
    if (rowIdx != idx && b[rowIdx] == d) return false;
    if (colIdx != idx && b[colIdx] == d) return false;
  }
  final br = r - r % 3, bc = c - c % 3;
  for (var rr = br; rr < br + 3; rr++) {
    for (var cc = bc; cc < bc + 3; cc++) {
      final j = rr * 9 + cc;
      if (j != idx && b[j] == d) return false;
    }
  }
  return true;
}

/// True if cells [a] and [b] share a row, column or box.
bool arePeers(int a, int b) {
  final ra = a ~/ 9, ca = a % 9, rb = b ~/ 9, cb = b % 9;
  return ra == rb || ca == cb || (ra ~/ 3 == rb ~/ 3 && ca ~/ 3 == cb ~/ 3);
}

/// Counts solutions of [b], stopping once [limit] is reached.
/// Mutates [b] during search but restores it before returning.
int countSolutions(List<int> b, int limit) {
  // Branch on the empty cell with the fewest candidates (much faster).
  var best = -1;
  List<int>? bestCands;
  for (var i = 0; i < 81; i++) {
    if (b[i] != 0) continue;
    final cands = <int>[];
    for (var d = 1; d <= 9; d++) {
      if (isValidPlacement(b, i, d)) cands.add(d);
    }
    if (cands.isEmpty) return 0;
    if (bestCands == null || cands.length < bestCands.length) {
      best = i;
      bestCands = cands;
      if (cands.length == 1) break;
    }
  }
  if (best == -1) return 1; // board full: one solution

  var total = 0;
  for (final d in bestCands!) {
    b[best] = d;
    total += countSolutions(b, limit - total);
    if (total >= limit) break;
  }
  b[best] = 0;
  return total;
}

class SudokuGenerator {
  SudokuGenerator([Random? rng]) : _rng = rng ?? Random();
  final Random _rng;

  Puzzle generate(Difficulty difficulty) {
    final solution = List<int>.filled(81, 0);
    _fillRandom(solution);

    final givens = List<int>.of(solution);
    final order = List<int>.generate(81, (i) => i)..shuffle(_rng);
    var clues = 81;
    for (final i in order) {
      if (clues <= difficulty.targetClues) break;
      final saved = givens[i];
      givens[i] = 0;
      if (countSolutions(List<int>.of(givens), 2) == 1) {
        clues--;
      } else {
        givens[i] = saved; // removing it would allow multiple solutions
      }
    }
    return Puzzle(givens, solution);
  }

  bool _fillRandom(List<int> b) {
    final i = b.indexOf(0);
    if (i == -1) return true;
    final digits = List<int>.generate(9, (k) => k + 1)..shuffle(_rng);
    for (final d in digits) {
      if (isValidPlacement(b, i, d)) {
        b[i] = d;
        if (_fillRandom(b)) return true;
        b[i] = 0;
      }
    }
    return false;
  }
}
