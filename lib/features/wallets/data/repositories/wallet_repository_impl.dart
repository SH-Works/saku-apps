import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_local_datasource.dart';
import '../models/wallet_model.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletLocalDataSource _ds;

  WalletRepositoryImpl(this._ds);

  @override
  List<Wallet> getAllWallets() => _ds.getAllWallets();

  @override
  Wallet? getWalletById(String id) => _ds.getWalletById(id);

  @override
  Future<void> addWallet(Wallet wallet) =>
      _ds.saveWallet(WalletModel.fromEntity(wallet));

  @override
  Future<void> updateWallet(Wallet wallet) =>
      _ds.saveWallet(WalletModel.fromEntity(wallet));

  @override
  Future<void> deleteWallet(String id) => _ds.deleteWallet(id);

  @override
  Future<void> setDefaultWallet(String newDefaultId) async {
    final wallets = _ds.getAllWallets();
    for (final w in wallets) {
      final updated = w.copyWith(isDefault: w.id == newDefaultId);
      await _ds.saveWallet(WalletModel.fromEntity(updated));
    }
  }

  @override
  Stream<List<Wallet>> watchAllWallets() => _ds.watchAllWallets();
}
