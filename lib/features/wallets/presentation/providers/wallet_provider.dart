import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../../features/transaction/presentation/providers/transaction_provider.dart';
import '../../data/datasources/wallet_local_datasource.dart';
import '../../data/models/wallet_model.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../domain/usecases/add_wallet.dart';
import '../../domain/usecases/delete_wallet.dart';
import '../../domain/usecases/get_all_wallets.dart';
import '../../domain/usecases/set_default_wallet.dart';
import '../../domain/usecases/update_wallet.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../domain/utils/wallet_balance.dart';
import '../../../transfer/domain/entities/wallet_transfer.dart';
import '../../../transfer/presentation/providers/transfer_provider.dart';

/// Must be overridden in main.dart after Hive initialization.
final walletBoxProvider = Provider<Box<WalletModel>>((ref) {
  throw UnimplementedError('walletBoxProvider must be overridden in main.dart');
});

final walletLocalDataSourceProvider = Provider<WalletLocalDataSource>((ref) {
  return WalletLocalDataSourceImpl(ref.watch(walletBoxProvider));
});

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepositoryImpl(ref.watch(walletLocalDataSourceProvider));
});

// ---- Use cases ----

final addWalletUseCaseProvider = Provider<AddWallet>((ref) {
  return AddWallet(ref.watch(walletRepositoryProvider));
});

final updateWalletUseCaseProvider = Provider<UpdateWallet>((ref) {
  return UpdateWallet(ref.watch(walletRepositoryProvider));
});

final deleteWalletUseCaseProvider = Provider<DeleteWallet>((ref) {
  return DeleteWallet(ref.watch(walletRepositoryProvider));
});

final getAllWalletsUseCaseProvider = Provider<GetAllWallets>((ref) {
  return GetAllWallets(ref.watch(walletRepositoryProvider));
});

final setDefaultWalletUseCaseProvider = Provider<SetDefaultWallet>((ref) {
  return SetDefaultWallet(ref.watch(walletRepositoryProvider));
});

// ---- Streams / state ----

/// Emits the full wallet list whenever the Hive box changes.
final walletsStreamProvider = StreamProvider<List<Wallet>>((ref) {
  final repo = ref.watch(walletRepositoryProvider);
  // Seed with current value then listen to changes.
  return repo.watchAllWallets();
});

/// The currently-selected wallet id for filtering.
/// `null` = "Semua" (all wallets combined).
final selectedWalletIdProvider = StateProvider<String?>((ref) => null);

/// Ensure a "Kas" default wallet exists when the box is empty.
/// Call this once during app bootstrap or from [walletsStreamProvider].
Future<void> ensureDefaultWallet(WalletRepository repo) async {
  final wallets = repo.getAllWallets();
  if (wallets.isEmpty) {
    await repo.addWallet(Wallet(
      id: 'default',
      name: 'Kas',
      icon: '💵',
      seedBalance: 0,
      isDefault: true,
      createdAt: DateTime.now(),
    ));
  }
}

/// Computes current balance for a specific wallet:
/// seedBalance + sum of income - sum of expense transactions linked to it.
final walletCurrentBalanceProvider =
    Provider.family<int, String>((ref, walletId) {
  final wallet = ref.watch(walletsStreamProvider).maybeWhen(
        data: (list) => list.where((w) => w.id == walletId).firstOrNull,
        orElse: () => null,
      );
  if (wallet == null) return 0;

  final txsAsync = ref.watch(allTransactionsStreamProvider);
  final transfers = ref.watch(allTransfersStreamProvider).maybeWhen(
        data: (list) => list,
        orElse: () => <WalletTransfer>[],
      );

  final transactions = txsAsync.maybeWhen(
    data: (list) => list.where((tx) => tx.walletId == walletId).toList(),
    orElse: () => <Transaction>[],
  );

  return computeWalletBalance(
    wallet: wallet,
    transactions: transactions,
    transfers: transfers,
  );
});

/// Total balance across ALL wallets.
final totalBalanceProvider = Provider<int>((ref) {
  final wallets = ref.watch(walletsStreamProvider).maybeWhen(
        data: (list) => list,
        orElse: () => <Wallet>[],
      );
  return wallets.fold(
    0,
    (sum, w) => sum + ref.watch(walletCurrentBalanceProvider(w.id)),
  );
});

/// Helper — creates a new wallet with a generated UUID.
Wallet buildWallet({
  required String name,
  required String icon,
  required int seedBalance,
  bool isDefault = false,
}) =>
    Wallet(
      id: const Uuid().v4(),
      name: name,
      icon: icon,
      seedBalance: seedBalance,
      isDefault: isDefault,
      createdAt: DateTime.now(),
    );
