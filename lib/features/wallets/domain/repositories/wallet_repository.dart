import '../entities/wallet.dart';

abstract class WalletRepository {
  List<Wallet> getAllWallets();
  Wallet? getWalletById(String id);
  Future<void> addWallet(Wallet wallet);
  Future<void> updateWallet(Wallet wallet);
  Future<void> deleteWallet(String id);
  Future<void> setDefaultWallet(String id);
  Stream<List<Wallet>> watchAllWallets();
}
