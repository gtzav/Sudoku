import 'package:flutter/material.dart';

import 'game.dart';
import 'sudoku.dart';

/// Board colors derived from the app's theme, so light and dark mode work.
class BoardColors {
  BoardColors.of(ColorScheme cs)
      : cell = cs.surface,
        peer = Color.lerp(cs.surface, cs.primary, 0.08)!,
        same = Color.lerp(cs.surface, cs.primary, 0.22)!,
        selected = Color.lerp(cs.surface, cs.primary, 0.38)!,
        wrongBg = Color.lerp(cs.surface, cs.error, 0.18)!,
        given = cs.onSurface,
        user = cs.primary,
        wrong = cs.error,
        note = cs.onSurfaceVariant,
        thinLine = cs.outlineVariant,
        thickLine = cs.onSurface;

  final Color cell, peer, same, selected, wrongBg;
  final Color given, user, wrong, note, thinLine, thickLine;
}

class BoardPainter extends CustomPainter {
  BoardPainter(this.game, this.colors) : super(repaint: game);

  final Game game;
  final BoardColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / 9;
    final sel = game.selected;
    final selDigit = game.board[sel];
    final fill = Paint();

    for (var i = 0; i < 81; i++) {
      final r = i ~/ 9, c = i % 9;
      final rect = Rect.fromLTWH(c * cell, r * cell, cell, cell);
      final v = game.board[i];
      final wrong = game.isWrong(i);

      if (i == sel) {
        fill.color = colors.selected;
      } else if (wrong) {
        fill.color = colors.wrongBg;
      } else if (selDigit != 0 && v == selDigit) {
        fill.color = colors.same;
      } else if (arePeers(i, sel)) {
        fill.color = colors.peer;
      } else {
        fill.color = colors.cell;
      }
      canvas.drawRect(rect, fill);

      if (v != 0) {
        final given = game.isGiven(i);
        _text(canvas, '$v', rect.center, cell * 0.58,
            given ? colors.given : (wrong ? colors.wrong : colors.user),
            given ? FontWeight.w600 : FontWeight.w400);
      } else if (game.notes[i] != 0) {
        final sub = cell / 3;
        for (var d = 1; d <= 9; d++) {
          if (game.notes[i] & (1 << d) == 0) continue;
          final center = Offset(
            rect.left + ((d - 1) % 3 + 0.5) * sub,
            rect.top + ((d - 1) ~/ 3 + 0.5) * sub,
          );
          _text(canvas, '$d', center, sub * 0.72, colors.note,
              FontWeight.w400);
        }
      }
    }

    // Thin cell lines, then thick box borders on top.
    final thin = Paint()
      ..color = colors.thinLine
      ..strokeWidth = 1;
    for (var k = 1; k < 9; k++) {
      if (k % 3 == 0) continue;
      final p = k * cell;
      canvas.drawLine(Offset(p, 0), Offset(p, size.height), thin);
      canvas.drawLine(Offset(0, p), Offset(size.width, p), thin);
    }
    const w = 2.5;
    final thick = Paint()
      ..color = colors.thickLine
      ..strokeWidth = w;
    for (var k = 0; k <= 9; k += 3) {
      // Keep the outer border fully inside the canvas.
      final p = (k * cell).clamp(w / 2, size.width - w / 2).toDouble();
      canvas.drawLine(Offset(p, 0), Offset(p, size.height), thick);
      canvas.drawLine(Offset(0, p), Offset(size.width, p), thick);
    }
  }

  void _text(Canvas canvas, String s, Offset center, double fontSize,
      Color color, FontWeight weight) {
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(fontSize: fontSize, color: color, fontWeight: weight),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  // The Game object is mutated in place, so always repaint when asked.
  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) => true;
}
