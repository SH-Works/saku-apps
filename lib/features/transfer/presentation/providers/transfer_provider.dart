import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

import '../../data/datasources/transfer_local_datasource.dart';
import '../../data/models/wallet_transfer_model.dart';
import '../../data/repositories/transfer_repository_impl.dart';
import '../../domain/entities/wallet_transfer.dart';
import '../../domain/repositories/transfer_repository.dart';
import '../../domain/usecases/delete_transfer.dart';
import '../../domain/usecases/execute_transfer.dart';
import '../../domain/usecases/get_all_transfers.dart';
import '../../domain/usecases/get_transfers_by_wallet.dart';
import '../../../transaction/presentation/providers/transaction_provider.dart';
import '../../../wallets/presentation/providers/wallet_provider.dart';

/// Must be overridden in main.dart after Hive initialization.
final transferBoxProvider = Provider<Box<WalletTransferModel>>((ref) {
  throw UnimplementedError('transferBoxProvider must be overridden in main.dart');
});

final transferLocalDataSourceProvider =
    Provider<TransferLocalDataSource>((ref) {
  return TransferLocalDataSourceImpl(ref.watch(transferBoxProvider));
});

final transferRepositoryProvider = Provider<TransferRepository>((ref) {
  return TransferRepositoryImpl(ref.watch(transferLocalDataSourceProvider));
});

final executeTransferUseCaseProvider = Provider<ExecuteTransfer>((ref) {
  return ExecuteTransfer(
    ref.watch(transferRepositoryProvider),
    ref.watch(walletRepositoryProvider),
    ref.watch(transactionRepositoryProvider),
  );
});

final deleteTransferUseCaseProvider = Provider<DeleteTransfer>((ref) {
  return DeleteTransfer(ref.watch(transferRepositoryProvider));
});

final getAllTransfersUseCaseProvider = Provider<GetAllTransfers>((ref) {
  return GetAllTransfers(ref.watch(transferRepositoryProvider));
});

final getTransfersByWalletUseCaseProvider =
    Provider<GetTransfersByWallet>((ref) {
  return GetTransfersByWallet(ref.watch(transferRepositoryProvider));
});

/// Reactive stream of all wallet transfers.
final allTransfersStreamProvider =
    StreamProvider<List<WalletTransfer>>((ref) {
  return ref.watch(transferRepositoryProvider).watchAllTransfers();
});

/// Transfers for the currently-selected month (History tab).
final monthTransfersProvider = Provider<List<WalletTransfer>>((ref) {
  final selected = ref.watch(selectedMonthProvider);
  return ref.watch(allTransfersStreamProvider).maybeWhen(
        data: (list) => list
            .where((t) =>
                t.date.year == selected.year &&
                t.date.month == selected.month)
            .toList(),
        orElse: () => <WalletTransfer>[],
      );
});
