import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../transaction/domain/entities/transaction.dart';

part 'recuring_transaction.freezed.dart';

enum RecuringFrequency { daily, weekly, monthly, yearly }

@freezed
abstract class RecuringTransaction with _$RecuringTransaction {
  const factory RecuringTransaction({
    required String id,
    required TransactionType type,
    required int amount,
    required String categoryId,
    required String walletId,
    required RecuringFrequency frequency,
    required int dayOfMonth,
    required DateTime startDate,
    DateTime? endDate,
    DateTime? lastProcessedDate,
    required bool isActive,
    String? notes,
    required String label,
    required DateTime createdAt,
  }) = _RecuringTransaction;
}
