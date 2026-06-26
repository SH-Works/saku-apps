// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smoke_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SmokeLog {

 String get id; DateTime get loggedAt; DateTime get date; String? get notes; DateTime get createdAt;
/// Create a copy of SmokeLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmokeLogCopyWith<SmokeLog> get copyWith => _$SmokeLogCopyWithImpl<SmokeLog>(this as SmokeLog, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmokeLog&&(identical(other.id, id) || other.id == id)&&(identical(other.loggedAt, loggedAt) || other.loggedAt == loggedAt)&&(identical(other.date, date) || other.date == date)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,loggedAt,date,notes,createdAt);

@override
String toString() {
  return 'SmokeLog(id: $id, loggedAt: $loggedAt, date: $date, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SmokeLogCopyWith<$Res>  {
  factory $SmokeLogCopyWith(SmokeLog value, $Res Function(SmokeLog) _then) = _$SmokeLogCopyWithImpl;
@useResult
$Res call({
 String id, DateTime loggedAt, DateTime date, String? notes, DateTime createdAt
});




}
/// @nodoc
class _$SmokeLogCopyWithImpl<$Res>
    implements $SmokeLogCopyWith<$Res> {
  _$SmokeLogCopyWithImpl(this._self, this._then);

  final SmokeLog _self;
  final $Res Function(SmokeLog) _then;

/// Create a copy of SmokeLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? loggedAt = null,Object? date = null,Object? notes = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,loggedAt: null == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SmokeLog].
extension SmokeLogPatterns on SmokeLog {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmokeLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmokeLog() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmokeLog value)  $default,){
final _that = this;
switch (_that) {
case _SmokeLog():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmokeLog value)?  $default,){
final _that = this;
switch (_that) {
case _SmokeLog() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime loggedAt,  DateTime date,  String? notes,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmokeLog() when $default != null:
return $default(_that.id,_that.loggedAt,_that.date,_that.notes,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime loggedAt,  DateTime date,  String? notes,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SmokeLog():
return $default(_that.id,_that.loggedAt,_that.date,_that.notes,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime loggedAt,  DateTime date,  String? notes,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SmokeLog() when $default != null:
return $default(_that.id,_that.loggedAt,_that.date,_that.notes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _SmokeLog implements SmokeLog {
  const _SmokeLog({required this.id, required this.loggedAt, required this.date, this.notes, required this.createdAt});
  

@override final  String id;
@override final  DateTime loggedAt;
@override final  DateTime date;
@override final  String? notes;
@override final  DateTime createdAt;

/// Create a copy of SmokeLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmokeLogCopyWith<_SmokeLog> get copyWith => __$SmokeLogCopyWithImpl<_SmokeLog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmokeLog&&(identical(other.id, id) || other.id == id)&&(identical(other.loggedAt, loggedAt) || other.loggedAt == loggedAt)&&(identical(other.date, date) || other.date == date)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,loggedAt,date,notes,createdAt);

@override
String toString() {
  return 'SmokeLog(id: $id, loggedAt: $loggedAt, date: $date, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SmokeLogCopyWith<$Res> implements $SmokeLogCopyWith<$Res> {
  factory _$SmokeLogCopyWith(_SmokeLog value, $Res Function(_SmokeLog) _then) = __$SmokeLogCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime loggedAt, DateTime date, String? notes, DateTime createdAt
});




}
/// @nodoc
class __$SmokeLogCopyWithImpl<$Res>
    implements _$SmokeLogCopyWith<$Res> {
  __$SmokeLogCopyWithImpl(this._self, this._then);

  final _SmokeLog _self;
  final $Res Function(_SmokeLog) _then;

/// Create a copy of SmokeLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? loggedAt = null,Object? date = null,Object? notes = freezed,Object? createdAt = null,}) {
  return _then(_SmokeLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,loggedAt: null == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
