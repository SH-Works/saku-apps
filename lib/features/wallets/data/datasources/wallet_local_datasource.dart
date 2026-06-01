import 'package:hive_ce/hive.dart';

import '../../domain/entities/wallet.dart';
import '../models/wallet_model.dart';

abstract class WalletLocalDataSource {
  List<Wallet> getAllWallets();
  Wallet? getWalletById(String id);
  Future<void> saveWallet(WalletModel model);
  Future<void> deleteWallet(String id);
  Stream<List<Wallet>> watchAllWallets();
  static const String boxName = 'wallets';
}

class WalletLocalDataSourceImpl implements WalletLocalDataSource {
  final Box<WalletModel> _box;

  WalletLocalDataSourceImpl(this._box);

  @override
  List<Wallet> getAllWallets() =>
      _box.values.map((m) => m.toEntity()).toList();

  @override
  Wallet? getWalletById(String id) {
    try {
      return _box.values
          .firstWhere((m) => m.id == id)
          .toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveWallet(WalletModel model) async {
    await _box.put(model.id, model);
  }

  @override
  Future<void> deleteWallet(String id) async {
    await _box.delete(id);
  }

  @override
  Stream<List<Wallet>> watchAllWallets() async* {
    yield getAllWallets();
    yield* _box.watch().map((_) => getAllWallets());
  }
}
