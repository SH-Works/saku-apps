import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

import '../../../transaction/presentation/providers/transaction_provider.dart';
import '../../data/datasources/recuring_local_datasource.dart';
import '../../data/models/recuring_model.dart';
import '../../data/repositories/recuring_repository_impl.dart';
import '../../domain/entities/recuring_transaction.dart';
import '../../domain/repositories/recuring_repository.dart';
import '../../domain/usecases/add_recurring.dart';
import '../../domain/usecases/delete_recurring.dart';
import '../../domain/usecases/process_due_recurring.dart';
import '../../domain/usecases/toggle_recurring_active.dart';
import '../../domain/usecases/update_recurring.dart';

final recuringBoxProvider = Provider<Box<RecuringModel>>((ref) {
  throw UnimplementedError('recuringBoxProvider must be overridden in main.dart');
});

final recuringLocalDataSourceProvider =
    Provider<RecuringLocalDataSource>((ref) {
  return RecuringLocalDataSourceImpl(ref.watch(recuringBoxProvider));
});

final recuringRepositoryProvider = Provider<RecuringRepository>((ref) {
  return RecuringRepositoryImpl(ref.watch(recuringLocalDataSourceProvider));
});

final addRecurringProvider = Provider<AddRecurring>((ref) {
  return AddRecurring(ref.watch(recuringRepositoryProvider));
});

final updateRecurringProvider = Provider<UpdateRecurring>((ref) {
  return UpdateRecurring(ref.watch(recuringRepositoryProvider));
});

final deleteRecurringProvider = Provider<DeleteRecurring>((ref) {
  return DeleteRecurring(ref.watch(recuringRepositoryProvider));
});

final toggleRecurringActiveProvider = Provider<ToggleRecurringActive>((ref) {
  return ToggleRecurringActive(ref.watch(recuringRepositoryProvider));
});

final allRecurringProvider = StreamProvider<List<RecuringTransaction>>((ref) {
  return ref.watch(recuringRepositoryProvider).watchAllRecurring();
});

final processDueRecurringProvider = Provider<ProcessDueRecurring>((ref) {
  return ProcessDueRecurring(
    ref.watch(recuringRepositoryProvider),
    ref.watch(addTransactionUseCaseProvider),
  );
});
