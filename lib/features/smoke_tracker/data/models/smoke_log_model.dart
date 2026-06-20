import 'package:hive_ce/hive.dart';

import '../../domain/entities/smoke_log.dart';

part 'smoke_log_model.g.dart';

@HiveType(typeId: 5)
class SmokeLogModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late DateTime loggedAt;

  @HiveField(2)
  late DateTime date;

  @HiveField(3)
  String? notes;

  @HiveField(4)
  late DateTime createdAt;

  SmokeLogModel();

  SmokeLog toEntity() => SmokeLog(
        id: id,
        loggedAt: loggedAt,
        date: date,
        notes: notes,
        createdAt: createdAt,
      );

  static SmokeLogModel fromEntity(SmokeLog s) => SmokeLogModel()
    ..id = s.id
    ..loggedAt = s.loggedAt
    ..date = s.date
    ..notes = s.notes
    ..createdAt = s.createdAt;
}
