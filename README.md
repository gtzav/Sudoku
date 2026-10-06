# Sudoku — Flutter

A Sudoku game in plain Flutter. The grid is drawn with a `CustomPainter` and
there are no native dependencies, so it runs on Linux, Windows, macOS,
Android, iOS and the web.

## Files

```
lib/main.dart              app, layout, keyboard and touch input
lib/src/board_painter.dart CustomPainter for the grid (theme-aware colors)
lib/src/game.dart          game state (ChangeNotifier)
lib/src/sudoku.dart        generator + solver (pure Dart)
lib/l10n/app_en.arb        English strings (template)
lib/l10n/app_el.arb        Greek strings
lib/l10n/app_??.arb        Other language strings
l10n.yaml                  gen-l10n configuration
test/widget_test.dart      generator tests
```

## Run

```sh
git clone https://github.com/gtzav/Sudoku.git
cd sudoku
flutter create --project-name sudoku .   # adds platform folders; keeps existing files
flutter pub get
flutter gen-l10n                         # generates lib/l10n/app_localizations*.dart
flutter run -d linux                     # or: -d chrome, -d android, ...
```

`flutter create` doesn't overwrite files that already exist, so `lib/`,
`test/` and `pubspec.yaml` stay as they are. To create only the Linux runner,
use `flutter create --platforms=linux --project-name sudoku .`

If `flutter run -d linux` complains about missing tools, run `flutter doctor`.
On Debian/Ubuntu the Linux desktop toolchain is usually:

```sh
sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev
```

Tests: `flutter test`

## Localization

The app ships in English, Greek and other languages. It follows the system
language and falls back to English, and the translate icon in the app bar
overrides that at runtime. To test Greek without the menu: `LANG=el_GR.UTF-8
flutter run -d linux`.

To add a language, for example German:

1. Copy `lib/l10n/app_en.arb` to `lib/l10n/app_de.arb`, set `"@@locale": "de"`,
   translate the values, and drop the `@key` metadata entries.
2. Run `flutter gen-l10n`. `supportedLocales` picks up the new file
   automatically.
3. Add a `PopupMenuItem` for it in the language menu in `lib/main.dart`.

On iOS and macOS, also list the languages under `CFBundleLocalizations` in
`ios/Runner/Info.plist` and `macos/Runner/Info.plist`.

## Controls

| Input | Action |
|---|---|
| Tap / click, arrow keys | Select a cell |
| 1–9 (keyboard, numpad or on-screen pad) | Enter a digit; the same digit again erases it |
| 0 / Backspace / Delete, or the erase button | Clear the cell |
| P, or the pencil button | Toggle pencil-notes mode |
| **+** in the app bar | New Easy / Medium / Hard game |

Wrong entries turn red and count as mistakes. A correct entry removes that
digit from the notes in its row, column and box. The small number on each pad
button shows how many of that digit are still missing. Puzzles are generated
in a background isolate, and each one has exactly one solution.

Requires Flutter 3.10 or later (Dart 3).
