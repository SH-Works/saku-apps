import 'package:hive_ce/hive.dart';

import '../../domain/entities/budget.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 3)
class BudgetModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String categoryId;

  @HiveField(2)
  late int limitAmount;

  @HiveField(3)
  late int month;

  @HiveField(4)
  late int year;

  @HiveField(5)
  late DateTime createdAt;

  BudgetModel();

  Budget toEntity() => Budget(
        id: id,
        categoryId: categoryId,
        limitAmount: limitAmount,
        month: month,
        year: year,
        createdAt: createdAt,
      );

  static BudgetModel fromEntity(Budget b) => BudgetModel()
    ..id = b.id
    ..categoryId = b.categoryId
    ..limitAmount = b.limitAmount
    ..month = b.month
    ..year = b.year
    ..createdAt = b.createdAt;
}
