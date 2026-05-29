import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

import '../../../../core/services/notification_service.dart';
import '../../data/settings_datasource.dart';

class SettingsState {
  final ThemeMode themeMode;
  final bool notifEnabled;
  final int notifHour;
  final int notifMinute;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.notifEnabled = false,
    this.notifHour = 8,
    this.notifMinute = 0,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    bool? notifEnabled,
    int? notifHour,
    int? notifMinute,
  }) =>
      SettingsState(
        themeMode: themeMode ?? this.themeMode,
        notifEnabled: notifEnabled ?? this.notifEnabled,
        notifHour: notifHour ?? this.notifHour,
        notifMinute: notifMinute ?? this.notifMinute,
      );
}

/// Must be overridden in main.dart after Hive.openBox.
final settingsBoxProvider = Provider<Box>((ref) {
  throw UnimplementedError('settingsBoxProvider must be overridden in main.dart');
});

final _settingsDataSourceProvider = Provider<SettingsLocalDataSource>((ref) {
  return SettingsLocalDataSource(ref.watch(settingsBoxProvider));
});

class SettingsNotifier extends StateNotifier<SettingsState> {
  final SettingsLocalDataSource _ds;

  SettingsNotifier(this._ds)
      : super(SettingsState(
          themeMode: _fromInt(_ds.getThemeMode()),
          notifEnabled: _ds.getNotifEnabled(),
          notifHour: _ds.getNotifHour(),
          notifMinute: _ds.getNotifMinute(),
        ));

  static ThemeMode _fromInt(int v) => switch (v) {
        1 => ThemeMode.light,
        2 => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  static int _toInt(ThemeMode m) => switch (m) {
        ThemeMode.light => 1,
        ThemeMode.dark => 2,
        _ => 0,
      };

  Future<void> setThemeMode(ThemeMode mode) async {
    await _ds.setThemeMode(_toInt(mode));
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setNotifEnabled(bool enabled) async {
    final granted = enabled ? await NotificationService.requestPermission() : true;
    if (!granted) return;

    await _ds.setNotifEnabled(enabled);
    state = state.copyWith(notifEnabled: enabled);

    if (enabled) {
      await NotificationService.scheduleDailyReminder(
          state.notifHour, state.notifMinute);
    } else {
      await NotificationService.cancelAll();
    }
  }

  Future<void> setNotifTime(int hour, int minute) async {
    await _ds.setNotifHour(hour);
    await _ds.setNotifMinute(minute);
    state = state.copyWith(notifHour: hour, notifMinute: minute);
    if (state.notifEnabled) {
      await NotificationService.scheduleDailyReminder(hour, minute);
    }
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(ref.watch(_settingsDataSourceProvider));
});
