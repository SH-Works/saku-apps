import 'package:hive_ce/hive.dart';

class SettingsLocalDataSource {
  static const _keyThemeMode = 'themeMode';
  static const _keyNotifEnabled = 'notifEnabled';
  static const _keyNotifHour = 'notifHour';
  static const _keyNotifMinute = 'notifMinute';

  final Box box;
  SettingsLocalDataSource(this.box);

  int getThemeMode() => box.get(_keyThemeMode, defaultValue: 0) as int;
  Future<void> setThemeMode(int mode) => box.put(_keyThemeMode, mode);

  bool getNotifEnabled() =>
      box.get(_keyNotifEnabled, defaultValue: false) as bool;
  Future<void> setNotifEnabled(bool v) => box.put(_keyNotifEnabled, v);

  int getNotifHour() => box.get(_keyNotifHour, defaultValue: 8) as int;
  Future<void> setNotifHour(int h) => box.put(_keyNotifHour, h);

  int getNotifMinute() => box.get(_keyNotifMinute, defaultValue: 0) as int;
  Future<void> setNotifMinute(int m) => box.put(_keyNotifMinute, m);
}
