import 'package:hive_ce/hive.dart';

import '../../../transaction/domain/entities/transaction.dart';
import '../../domain/entities/recuring_transaction.dart';
part 'recuring_model.g.dart';

@HiveType(typeId: 2)
class RecuringModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String type;

  @HiveField(2)
  late int amount;

  @HiveField(3)
  late String categoryId;

  @HiveField(4)
  late String walletId;

  @HiveField(5)
  late String frequency;

  @HiveField(6)
  late int dayOfMonth;

  @HiveField(7)
  late DateTime startDate;

  @HiveField(8)
  DateTime? endDate;

  @HiveField(9)
  DateTime? lastProcessedDate;

  @HiveField(10)
  late bool isActive;

  @HiveField(11)
  String? notes;

  @HiveField(12)
  late String label;

  @HiveField(13)
  late DateTime createdAt;

  RecuringModel();

  RecuringTransaction toEntity() => RecuringTransaction(
        id: id,
        type: type == 'income'
            ? TransactionType.income
            : TransactionType.expense,
        amount: amount,
        categoryId: categoryId,
        walletId: walletId,
        frequency: RecuringFrequency.values.byName(frequency),
        dayOfMonth: dayOfMonth,
        startDate: startDate,
        endDate: endDate,
        lastProcessedDate: lastProcessedDate,
        isActive: isActive,
        notes: notes,
        label: label,
        createdAt: createdAt,
      );

  static RecuringModel fromEntity(RecuringTransaction r) => RecuringModel()
    ..id = r.id
    ..type = r.type.name
    ..amount = r.amount
    ..categoryId = r.categoryId
    ..walletId = r.walletId
    ..frequency = r.frequency.name
    ..dayOfMonth = r.dayOfMonth
    ..startDate = r.startDate
    ..endDate = r.endDate
    ..lastProcessedDate = r.lastProcessedDate
    ..isActive = r.isActive
    ..notes = r.notes
    ..label = r.label
    ..createdAt = r.createdAt;
}
