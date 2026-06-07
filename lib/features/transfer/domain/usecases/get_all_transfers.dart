import '../entities/wallet_transfer.dart';
import '../repositories/transfer_repository.dart';

class GetAllTransfers {
  final TransferRepository repository;
  GetAllTransfers(this.repository);

  List<WalletTransfer> call() => repository.getAllTransfers();
}
