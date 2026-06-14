// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recuring_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecuringTransaction {

 String get id; TransactionType get type; int get amount; String get categoryId; String get walletId; RecuringFrequency get frequency; int get dayOfMonth; DateTime get startDate; DateTime? get endDate; DateTime? get lastProcessedDate; bool get isActive; String? get notes; String get label; DateTime get createdAt;
/// Create a copy of RecuringTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecuringTransactionCopyWith<RecuringTransaction> get copyWith => _$RecuringTransactionCopyWithImpl<RecuringTransaction>(this as RecuringTransaction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecuringTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.dayOfMonth, dayOfMonth) || other.dayOfMonth == dayOfMonth)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.lastProcessedDate, lastProcessedDate) || other.lastProcessedDate == lastProcessedDate)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.label, label) || other.label == label)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,amount,categoryId,walletId,frequency,dayOfMonth,startDate,endDate,lastProcessedDate,isActive,notes,label,createdAt);

@override
String toString() {
  return 'RecuringTransaction(id: $id, type: $type, amount: $amount, categoryId: $categoryId, walletId: $walletId, frequency: $frequency, dayOfMonth: $dayOfMonth, startDate: $startDate, endDate: $endDate, lastProcessedDate: $lastProcessedDate, isActive: $isActive, notes: $notes, label: $label, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RecuringTransactionCopyWith<$Res>  {
  factory $RecuringTransactionCopyWith(RecuringTransaction value, $Res Function(RecuringTransaction) _then) = _$RecuringTransactionCopyWithImpl;
@useResult
$Res call({
 String id, TransactionType type, int amount, String categoryId, String walletId, RecuringFrequency frequency, int dayOfMonth, DateTime startDate, DateTime? endDate, DateTime? lastProcessedDate, bool isActive, String? notes, String label, DateTime createdAt
});




}
/// @nodoc
class _$RecuringTransactionCopyWithImpl<$Res>
    implements $RecuringTransactionCopyWith<$Res> {
  _$RecuringTransactionCopyWithImpl(this._self, this._then);

  final RecuringTransaction _self;
  final $Res Function(RecuringTransaction) _then;

/// Create a copy of RecuringTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? categoryId = null,Object? walletId = null,Object? frequency = null,Object? dayOfMonth = null,Object? startDate = null,Object? endDate = freezed,Object? lastProcessedDate = freezed,Object? isActive = null,Object? notes = freezed,Object? label = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecuringFrequency,dayOfMonth: null == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,lastProcessedDate: freezed == lastProcessedDate ? _self.lastProcessedDate : lastProcessedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RecuringTransaction].
extension RecuringTransactionPatterns on RecuringTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecuringTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecuringTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecuringTransaction value)  $default,){
final _that = this;
switch (_that) {
case _RecuringTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecuringTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _RecuringTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TransactionType type,  int amount,  String categoryId,  String walletId,  RecuringFrequency frequency,  int dayOfMonth,  DateTime startDate,  DateTime? endDate,  DateTime? lastProcessedDate,  bool isActive,  String? notes,  String label,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecuringTransaction() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.categoryId,_that.walletId,_that.frequency,_that.dayOfMonth,_that.startDate,_that.endDate,_that.lastProcessedDate,_that.isActive,_that.notes,_that.label,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TransactionType type,  int amount,  String categoryId,  String walletId,  RecuringFrequency frequency,  int dayOfMonth,  DateTime startDate,  DateTime? endDate,  DateTime? lastProcessedDate,  bool isActive,  String? notes,  String label,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _RecuringTransaction():
return $default(_that.id,_that.type,_that.amount,_that.categoryId,_that.walletId,_that.frequency,_that.dayOfMonth,_that.startDate,_that.endDate,_that.lastProcessedDate,_that.isActive,_that.notes,_that.label,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TransactionType type,  int amount,  String categoryId,  String walletId,  RecuringFrequency frequency,  int dayOfMonth,  DateTime startDate,  DateTime? endDate,  DateTime? lastProcessedDate,  bool isActive,  String? notes,  String label,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RecuringTransaction() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.categoryId,_that.walletId,_that.frequency,_that.dayOfMonth,_that.startDate,_that.endDate,_that.lastProcessedDate,_that.isActive,_that.notes,_that.label,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _RecuringTransaction implements RecuringTransaction {
  const _RecuringTransaction({required this.id, required this.type, required this.amount, required this.categoryId, required this.walletId, required this.frequency, required this.dayOfMonth, required this.startDate, this.endDate, this.lastProcessedDate, required this.isActive, this.notes, required this.label, required this.createdAt});
  

@override final  String id;
@override final  TransactionType type;
@override final  int amount;
@override final  String categoryId;
@override final  String walletId;
@override final  RecuringFrequency frequency;
@override final  int dayOfMonth;
@override final  DateTime startDate;
@override final  DateTime? endDate;
@override final  DateTime? lastProcessedDate;
@override final  bool isActive;
@override final  String? notes;
@override final  String label;
@override final  DateTime createdAt;

/// Create a copy of RecuringTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecuringTransactionCopyWith<_RecuringTransaction> get copyWith => __$RecuringTransactionCopyWithImpl<_RecuringTransaction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecuringTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.dayOfMonth, dayOfMonth) || other.dayOfMonth == dayOfMonth)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.lastProcessedDate, lastProcessedDate) || other.lastProcessedDate == lastProcessedDate)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.label, label) || other.label == label)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,amount,categoryId,walletId,frequency,dayOfMonth,startDate,endDate,lastProcessedDate,isActive,notes,label,createdAt);

@override
String toString() {
  return 'RecuringTransaction(id: $id, type: $type, amount: $amount, categoryId: $categoryId, walletId: $walletId, frequency: $frequency, dayOfMonth: $dayOfMonth, startDate: $startDate, endDate: $endDate, lastProcessedDate: $lastProcessedDate, isActive: $isActive, notes: $notes, label: $label, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RecuringTransactionCopyWith<$Res> implements $RecuringTransactionCopyWith<$Res> {
  factory _$RecuringTransactionCopyWith(_RecuringTransaction value, $Res Function(_RecuringTransaction) _then) = __$RecuringTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, TransactionType type, int amount, String categoryId, String walletId, RecuringFrequency frequency, int dayOfMonth, DateTime startDate, DateTime? endDate, DateTime? lastProcessedDate, bool isActive, String? notes, String label, DateTime createdAt
});




}
/// @nodoc
class __$RecuringTransactionCopyWithImpl<$Res>
    implements _$RecuringTransactionCopyWith<$Res> {
  __$RecuringTransactionCopyWithImpl(this._self, this._then);

  final _RecuringTransaction _self;
  final $Res Function(_RecuringTransaction) _then;

/// Create a copy of RecuringTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? categoryId = null,Object? walletId = null,Object? frequency = null,Object? dayOfMonth = null,Object? startDate = null,Object? endDate = freezed,Object? lastProcessedDate = freezed,Object? isActive = null,Object? notes = freezed,Object? label = null,Object? createdAt = null,}) {
  return _then(_RecuringTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecuringFrequency,dayOfMonth: null == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,lastProcessedDate: freezed == lastProcessedDate ? _self.lastProcessedDate : lastProcessedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
