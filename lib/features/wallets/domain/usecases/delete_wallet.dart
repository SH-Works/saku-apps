import '../repositories/wallet_repository.dart';

class DeleteWallet {
  final WalletRepository repository;
  DeleteWallet(this.repository);

  Future<void> call(String id) => repository.deleteWallet(id);
}
