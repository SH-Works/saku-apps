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
import 'features/wallets/data/datasources/wallet_local_datasource.dart';
import 'features/wallets/data/models/wallet_model.dart';
import 'features/wallets/data/repositories/wallet_repository_impl.dart';
import 'features/wallets/presentation/providers/wallet_provider.dart';
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

  final suffix = FlavorConfig.instance.hiveBoxSuffix;

  final txBoxName = '${TransactionLocalDataSourceImpl.boxName}$suffix';
  final txBox = await Hive.openBox<TransactionModel>(txBoxName);

  final walletBoxName = '${WalletLocalDataSource.boxName}$suffix';
  final walletBox = await Hive.openBox<WalletModel>(walletBoxName);

  final settingsBox = await Hive.openBox('settings$suffix');

  // Seed the default "Kas" wallet on first launch.
  final walletRepo = WalletRepositoryImpl(WalletLocalDataSourceImpl(walletBox));
  await ensureDefaultWallet(walletRepo);

  await NotificationService.init();

  runApp(
    ProviderScope(
      overrides: [
        transactionBoxProvider.overrideWithValue(txBox),
        walletBoxProvider.overrideWithValue(walletBox),
        settingsBoxProvider.overrideWithValue(settingsBox),
      ],
      child: const SakuApp(),
    ),
  );
}
