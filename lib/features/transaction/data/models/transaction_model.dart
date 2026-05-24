import 'package:hive_ce/hive.dart';

import '../../domain/entities/transaction.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String type;

  @HiveField(2)
  late int amount;

  @HiveField(3)
  late String categoryId;

  @HiveField(4)
  late DateTime date;

  @HiveField(5)
  String? notes;

  @HiveField(6)
  late DateTime createdAt;

  TransactionModel();

  Transaction toEntity() => Transaction(
        id: id,
        type: type == 'income'
            ? TransactionType.income
            : TransactionType.expense,
        amount: amount,
        categoryId: categoryId,
        date: date,
        notes: notes,
        createdAt: createdAt,
      );

  static TransactionModel fromEntity(Transaction tx) => TransactionModel()
    ..id = tx.id
    ..type = tx.type.name
    ..amount = tx.amount
    ..categoryId = tx.categoryId
    ..date = tx.date
    ..notes = tx.notes
    ..createdAt = tx.createdAt;
}
