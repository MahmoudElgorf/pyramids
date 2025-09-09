import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeController._(this._mode);

  static const _prefsKey = 'theme_mode';

  ThemeMode _mode;
  ThemeMode get mode => _mode;

  // استرجاع الحالة عند بدء التشغيل
  static Future<ThemeController> init() async {
    final sp = await SharedPreferences.getInstance();
    final v = sp.getString(_prefsKey);
    final startMode = switch (v) {
      'light' => ThemeMode.light,
      'dark'  => ThemeMode.dark,
      _       => ThemeMode.system,
    };
    return ThemeController._(startMode);
  }

  // تغيير الثيم + حفظه
  Future<void> setMode(ThemeMode m) async {
    if (_mode == m) return;
    _mode = m;
    notifyListeners();
    final sp = await SharedPreferences.getInstance();
    final str = switch (m) {
      ThemeMode.light  => 'light',
      ThemeMode.dark   => 'dark',
      ThemeMode.system => 'system',
    };
    await sp.setString(_prefsKey, str);
  }
}
