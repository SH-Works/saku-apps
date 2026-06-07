import '../../domain/entities/wallet_transfer.dart';
import '../../domain/repositories/transfer_repository.dart';
import '../datasources/transfer_local_datasource.dart';
import '../models/wallet_transfer_model.dart';

class TransferRepositoryImpl implements TransferRepository {
  final TransferLocalDataSource _ds;

  TransferRepositoryImpl(this._ds);

  @override
  List<WalletTransfer> getAllTransfers() => _ds.getAllTransfers();

  @override
  List<WalletTransfer> getTransfersByWallet(String walletId) =>
      _ds.getTransfersByWallet(walletId);

  @override
  Future<void> saveTransfer(WalletTransfer transfer) =>
      _ds.saveTransfer(WalletTransferModel.fromEntity(transfer));

  @override
  Future<void> deleteTransfer(String id) => _ds.deleteTransfer(id);

  @override
  Stream<List<WalletTransfer>> watchAllTransfers() => _ds.watchAllTransfers();
}
