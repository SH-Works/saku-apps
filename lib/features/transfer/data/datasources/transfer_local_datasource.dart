import 'package:hive_ce/hive.dart';

import '../../domain/entities/wallet_transfer.dart';
import '../models/wallet_transfer_model.dart';

abstract class TransferLocalDataSource {
  List<WalletTransfer> getAllTransfers();
  List<WalletTransfer> getTransfersByWallet(String walletId);
  Future<void> saveTransfer(WalletTransferModel model);
  Future<void> deleteTransfer(String id);
  Stream<List<WalletTransfer>> watchAllTransfers();
  static const String boxName = 'wallet_transfers';
}

class TransferLocalDataSourceImpl implements TransferLocalDataSource {
  final Box<WalletTransferModel> _box;

  TransferLocalDataSourceImpl(this._box);

  @override
  List<WalletTransfer> getAllTransfers() {
    final list = _box.values.map((m) => m.toEntity()).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  List<WalletTransfer> getTransfersByWallet(String walletId) {
    return _box.values
        .where((m) =>
            m.fromWalletId == walletId || m.toWalletId == walletId)
        .map((m) => m.toEntity())
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<void> saveTransfer(WalletTransferModel model) async {
    await _box.put(model.id, model);
  }

  @override
  Future<void> deleteTransfer(String id) async {
    await _box.delete(id);
  }

  @override
  Stream<List<WalletTransfer>> watchAllTransfers() async* {
    yield getAllTransfers();
    yield* _box.watch().map((_) => getAllTransfers());
  }
}
