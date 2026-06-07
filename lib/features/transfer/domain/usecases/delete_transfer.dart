import '../entities/wallet_transfer.dart';
import '../repositories/transfer_repository.dart';

/// Deleting a transfer record automatically reverses its balance effect
/// because balance is computed from stored transfers.
class DeleteTransfer {
  final TransferRepository transferRepo;

  DeleteTransfer(this.transferRepo);

  Future<void> call(WalletTransfer transfer) =>
      transferRepo.deleteTransfer(transfer.id);
}
