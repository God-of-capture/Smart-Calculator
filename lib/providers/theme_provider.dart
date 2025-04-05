import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeBox = 'settings';
  static const String _themeKey = 'themeMode';
  
  late Box _box;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox(_themeBox);
    _themeMode = ThemeMode.values[_box.get(_themeKey, defaultValue: ThemeMode.system.index)];
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _box.put(_themeKey, mode.index);
    notifyListeners();
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;
} 