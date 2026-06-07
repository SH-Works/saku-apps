// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_transfer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalletTransfer {

 String get id; String get fromWalletId; String get toWalletId; int get amount; DateTime get date; String? get notes; DateTime get createdAt;
/// Create a copy of WalletTransfer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletTransferCopyWith<WalletTransfer> get copyWith => _$WalletTransferCopyWithImpl<WalletTransfer>(this as WalletTransfer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletTransfer&&(identical(other.id, id) || other.id == id)&&(identical(other.fromWalletId, fromWalletId) || other.fromWalletId == fromWalletId)&&(identical(other.toWalletId, toWalletId) || other.toWalletId == toWalletId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,fromWalletId,toWalletId,amount,date,notes,createdAt);

@override
String toString() {
  return 'WalletTransfer(id: $id, fromWalletId: $fromWalletId, toWalletId: $toWalletId, amount: $amount, date: $date, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $WalletTransferCopyWith<$Res>  {
  factory $WalletTransferCopyWith(WalletTransfer value, $Res Function(WalletTransfer) _then) = _$WalletTransferCopyWithImpl;
@useResult
$Res call({
 String id, String fromWalletId, String toWalletId, int amount, DateTime date, String? notes, DateTime createdAt
});




}
/// @nodoc
class _$WalletTransferCopyWithImpl<$Res>
    implements $WalletTransferCopyWith<$Res> {
  _$WalletTransferCopyWithImpl(this._self, this._then);

  final WalletTransfer _self;
  final $Res Function(WalletTransfer) _then;

/// Create a copy of WalletTransfer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fromWalletId = null,Object? toWalletId = null,Object? amount = null,Object? date = null,Object? notes = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromWalletId: null == fromWalletId ? _self.fromWalletId : fromWalletId // ignore: cast_nullable_to_non_nullable
as String,toWalletId: null == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletTransfer].
extension WalletTransferPatterns on WalletTransfer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletTransfer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletTransfer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletTransfer value)  $default,){
final _that = this;
switch (_that) {
case _WalletTransfer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletTransfer value)?  $default,){
final _that = this;
switch (_that) {
case _WalletTransfer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fromWalletId,  String toWalletId,  int amount,  DateTime date,  String? notes,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletTransfer() when $default != null:
return $default(_that.id,_that.fromWalletId,_that.toWalletId,_that.amount,_that.date,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fromWalletId,  String toWalletId,  int amount,  DateTime date,  String? notes,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _WalletTransfer():
return $default(_that.id,_that.fromWalletId,_that.toWalletId,_that.amount,_that.date,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fromWalletId,  String toWalletId,  int amount,  DateTime date,  String? notes,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WalletTransfer() when $default != null:
return $default(_that.id,_that.fromWalletId,_that.toWalletId,_that.amount,_that.date,_that.notes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _WalletTransfer implements WalletTransfer {
  const _WalletTransfer({required this.id, required this.fromWalletId, required this.toWalletId, required this.amount, required this.date, this.notes, required this.createdAt});
  

@override final  String id;
@override final  String fromWalletId;
@override final  String toWalletId;
@override final  int amount;
@override final  DateTime date;
@override final  String? notes;
@override final  DateTime createdAt;

/// Create a copy of WalletTransfer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletTransferCopyWith<_WalletTransfer> get copyWith => __$WalletTransferCopyWithImpl<_WalletTransfer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletTransfer&&(identical(other.id, id) || other.id == id)&&(identical(other.fromWalletId, fromWalletId) || other.fromWalletId == fromWalletId)&&(identical(other.toWalletId, toWalletId) || other.toWalletId == toWalletId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,fromWalletId,toWalletId,amount,date,notes,createdAt);

@override
String toString() {
  return 'WalletTransfer(id: $id, fromWalletId: $fromWalletId, toWalletId: $toWalletId, amount: $amount, date: $date, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WalletTransferCopyWith<$Res> implements $WalletTransferCopyWith<$Res> {
  factory _$WalletTransferCopyWith(_WalletTransfer value, $Res Function(_WalletTransfer) _then) = __$WalletTransferCopyWithImpl;
@override @useResult
$Res call({
 String id, String fromWalletId, String toWalletId, int amount, DateTime date, String? notes, DateTime createdAt
});




}
/// @nodoc
class __$WalletTransferCopyWithImpl<$Res>
    implements _$WalletTransferCopyWith<$Res> {
  __$WalletTransferCopyWithImpl(this._self, this._then);

  final _WalletTransfer _self;
  final $Res Function(_WalletTransfer) _then;

/// Create a copy of WalletTransfer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromWalletId = null,Object? toWalletId = null,Object? amount = null,Object? date = null,Object? notes = freezed,Object? createdAt = null,}) {
  return _then(_WalletTransfer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromWalletId: null == fromWalletId ? _self.fromWalletId : fromWalletId // ignore: cast_nullable_to_non_nullable
as String,toWalletId: null == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
