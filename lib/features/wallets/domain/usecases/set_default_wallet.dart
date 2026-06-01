import '../repositories/wallet_repository.dart';

class SetDefaultWallet {
  final WalletRepository repository;
  SetDefaultWallet(this.repository);

  Future<void> call(String id) => repository.setDefaultWallet(id);
}
