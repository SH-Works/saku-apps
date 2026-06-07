import '../entities/wallet_transfer.dart';
import '../repositories/transfer_repository.dart';

class GetTransfersByWallet {
  final TransferRepository repository;
  GetTransfersByWallet(this.repository);

  List<WalletTransfer> call(String walletId) =>
      repository.getTransfersByWallet(walletId);
}
