import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'core/config/flavor_config.dart';
import 'core/services/notification_service.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'features/transaction/data/datasources/transaction_local_datasource.dart';
import 'features/transaction/data/models/transaction_model.dart';
import 'features/transaction/presentation/providers/transaction_provider.dart';
import 'hive_registrar.g.dart';

/// Default entry point — runs the development flavor.
/// For explicit flavor builds use:
///   `flutter run -t lib/main_development.dart`
///   `flutter run -t lib/main_production.dart`
Future<void> main() async {
  await bootstrap(Flavor.development);
}

Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  FlavorConfig.initialize(flavor);

  await Hive.initFlutter();
  Hive.registerAdapters();

  final txBoxName =
      '${TransactionLocalDataSourceImpl.boxName}${FlavorConfig.instance.hiveBoxSuffix}';
  final txBox = await Hive.openBox<TransactionModel>(txBoxName);
  final settingsBox =
      await Hive.openBox('settings${FlavorConfig.instance.hiveBoxSuffix}');

  await NotificationService.init();

  runApp(
    ProviderScope(
      overrides: [
        transactionBoxProvider.overrideWithValue(txBox),
        settingsBoxProvider.overrideWithValue(settingsBox),
      ],
      child: const SakuApp(),
    ),
  );
}
