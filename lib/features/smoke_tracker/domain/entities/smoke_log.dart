import 'package:freezed_annotation/freezed_annotation.dart';

part 'smoke_log.freezed.dart';

@freezed
abstract class SmokeLog with _$SmokeLog {
  const factory SmokeLog({
    required String id,
    required DateTime loggedAt,
    required DateTime date,
    String? notes,
    required DateTime createdAt,
  }) = _SmokeLog;
}
