import '../entities/wallet.dart';
import '../repositories/wallet_repository.dart';

class GetAllWallets {
  final WalletRepository repository;
  GetAllWallets(this.repository);

  List<Wallet> call() => repository.getAllWallets();
}
