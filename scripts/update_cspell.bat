@echo off
cd scripts
dart pub get
dart update_cspell.dart
cd ..
