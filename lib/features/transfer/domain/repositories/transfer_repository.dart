import '../entities/wallet_transfer.dart';

abstract class TransferRepository {
  List<WalletTransfer> getAllTransfers();
  List<WalletTransfer> getTransfersByWallet(String walletId);
  Future<void> saveTransfer(WalletTransfer transfer);
  Future<void> deleteTransfer(String id);
  Stream<List<WalletTransfer>> watchAllTransfers();
}
