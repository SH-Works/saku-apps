import '../entities/wallet.dart';
import '../repositories/wallet_repository.dart';

class AddWallet {
  final WalletRepository repository;
  AddWallet(this.repository);

  Future<void> call(Wallet wallet) => repository.addWallet(wallet);
}
