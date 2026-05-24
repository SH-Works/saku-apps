import 'package:hive_ce/hive.dart';

import '../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getAll();
  Future<List<TransactionModel>> getByMonth(int year, int month);
  Future<void> add(TransactionModel transaction);
  Future<void> delete(String id);
  Stream<List<TransactionModel>> watchAll();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  static const String boxName = 'transactions';

  final Box<TransactionModel> box;

  TransactionLocalDataSourceImpl(this.box);

  @override
  Future<List<TransactionModel>> getAll() async {
    final items = box.values.toList();
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  @override
  Future<List<TransactionModel>> getByMonth(int year, int month) async {
    final items = box.values.where((tx) {
      return tx.date.year == year && tx.date.month == month;
    }).toList();
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  @override
  Future<void> add(TransactionModel transaction) async {
    await box.put(transaction.id, transaction);
  }

  @override
  Future<void> delete(String id) async {
    await box.delete(id);
  }

  @override
  Stream<List<TransactionModel>> watchAll() async* {
    yield await getAll();
    yield* box.watch().asyncMap((_) => getAll());
  }
}
