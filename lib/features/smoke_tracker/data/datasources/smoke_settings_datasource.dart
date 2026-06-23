import 'package:hive_ce/hive.dart';

import '../../domain/entities/smoke_settings.dart';
import '../models/smoke_settings_model.dart';

abstract class SmokeSettingsDataSource {
  SmokeSettings? getSettings();
  Future<void> saveSettings(SmokeSettingsModel model);
  static const String boxName = 'smoke_settings';
  static const String settingsKey = 'settings';
}

class SmokeSettingsDataSourceImpl implements SmokeSettingsDataSource {
  final Box<SmokeSettingsModel> _box;

  SmokeSettingsDataSourceImpl(this._box);

  @override
  SmokeSettings? getSettings() {
    final model = _box.get(SmokeSettingsDataSource.settingsKey);
    return model?.toEntity();
  }

  @override
  Future<void> saveSettings(SmokeSettingsModel model) async {
    await _box.put(SmokeSettingsDataSource.settingsKey, model);
  }
}
