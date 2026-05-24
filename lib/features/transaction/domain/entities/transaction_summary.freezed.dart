// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionSummary {

 int get totalIncome; int get totalExpense; int get balance; Map<String, int> get byCategory; Map<int, int> get dailyExpense;
/// Create a copy of TransactionSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionSummaryCopyWith<TransactionSummary> get copyWith => _$TransactionSummaryCopyWithImpl<TransactionSummary>(this as TransactionSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionSummary&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.balance, balance) || other.balance == balance)&&const DeepCollectionEquality().equals(other.byCategory, byCategory)&&const DeepCollectionEquality().equals(other.dailyExpense, dailyExpense));
}


@override
int get hashCode => Object.hash(runtimeType,totalIncome,totalExpense,balance,const DeepCollectionEquality().hash(byCategory),const DeepCollectionEquality().hash(dailyExpense));

@override
String toString() {
  return 'TransactionSummary(totalIncome: $totalIncome, totalExpense: $totalExpense, balance: $balance, byCategory: $byCategory, dailyExpense: $dailyExpense)';
}


}

/// @nodoc
abstract mixin class $TransactionSummaryCopyWith<$Res>  {
  factory $TransactionSummaryCopyWith(TransactionSummary value, $Res Function(TransactionSummary) _then) = _$TransactionSummaryCopyWithImpl;
@useResult
$Res call({
 int totalIncome, int totalExpense, int balance, Map<String, int> byCategory, Map<int, int> dailyExpense
});




}
/// @nodoc
class _$TransactionSummaryCopyWithImpl<$Res>
    implements $TransactionSummaryCopyWith<$Res> {
  _$TransactionSummaryCopyWithImpl(this._self, this._then);

  final TransactionSummary _self;
  final $Res Function(TransactionSummary) _then;

/// Create a copy of TransactionSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalIncome = null,Object? totalExpense = null,Object? balance = null,Object? byCategory = null,Object? dailyExpense = null,}) {
  return _then(_self.copyWith(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as int,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as int,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,byCategory: null == byCategory ? _self.byCategory : byCategory // ignore: cast_nullable_to_non_nullable
as Map<String, int>,dailyExpense: null == dailyExpense ? _self.dailyExpense : dailyExpense // ignore: cast_nullable_to_non_nullable
as Map<int, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionSummary].
extension TransactionSummaryPatterns on TransactionSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionSummary value)  $default,){
final _that = this;
switch (_that) {
case _TransactionSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionSummary value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalIncome,  int totalExpense,  int balance,  Map<String, int> byCategory,  Map<int, int> dailyExpense)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionSummary() when $default != null:
return $default(_that.totalIncome,_that.totalExpense,_that.balance,_that.byCategory,_that.dailyExpense);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalIncome,  int totalExpense,  int balance,  Map<String, int> byCategory,  Map<int, int> dailyExpense)  $default,) {final _that = this;
switch (_that) {
case _TransactionSummary():
return $default(_that.totalIncome,_that.totalExpense,_that.balance,_that.byCategory,_that.dailyExpense);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalIncome,  int totalExpense,  int balance,  Map<String, int> byCategory,  Map<int, int> dailyExpense)?  $default,) {final _that = this;
switch (_that) {
case _TransactionSummary() when $default != null:
return $default(_that.totalIncome,_that.totalExpense,_that.balance,_that.byCategory,_that.dailyExpense);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionSummary implements TransactionSummary {
  const _TransactionSummary({required this.totalIncome, required this.totalExpense, required this.balance, required final  Map<String, int> byCategory, required final  Map<int, int> dailyExpense}): _byCategory = byCategory,_dailyExpense = dailyExpense;
  

@override final  int totalIncome;
@override final  int totalExpense;
@override final  int balance;
 final  Map<String, int> _byCategory;
@override Map<String, int> get byCategory {
  if (_byCategory is EqualUnmodifiableMapView) return _byCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_byCategory);
}

 final  Map<int, int> _dailyExpense;
@override Map<int, int> get dailyExpense {
  if (_dailyExpense is EqualUnmodifiableMapView) return _dailyExpense;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_dailyExpense);
}


/// Create a copy of TransactionSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionSummaryCopyWith<_TransactionSummary> get copyWith => __$TransactionSummaryCopyWithImpl<_TransactionSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionSummary&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.balance, balance) || other.balance == balance)&&const DeepCollectionEquality().equals(other._byCategory, _byCategory)&&const DeepCollectionEquality().equals(other._dailyExpense, _dailyExpense));
}


@override
int get hashCode => Object.hash(runtimeType,totalIncome,totalExpense,balance,const DeepCollectionEquality().hash(_byCategory),const DeepCollectionEquality().hash(_dailyExpense));

@override
String toString() {
  return 'TransactionSummary(totalIncome: $totalIncome, totalExpense: $totalExpense, balance: $balance, byCategory: $byCategory, dailyExpense: $dailyExpense)';
}


}

/// @nodoc
abstract mixin class _$TransactionSummaryCopyWith<$Res> implements $TransactionSummaryCopyWith<$Res> {
  factory _$TransactionSummaryCopyWith(_TransactionSummary value, $Res Function(_TransactionSummary) _then) = __$TransactionSummaryCopyWithImpl;
@override @useResult
$Res call({
 int totalIncome, int totalExpense, int balance, Map<String, int> byCategory, Map<int, int> dailyExpense
});




}
/// @nodoc
class __$TransactionSummaryCopyWithImpl<$Res>
    implements _$TransactionSummaryCopyWith<$Res> {
  __$TransactionSummaryCopyWithImpl(this._self, this._then);

  final _TransactionSummary _self;
  final $Res Function(_TransactionSummary) _then;

/// Create a copy of TransactionSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalIncome = null,Object? totalExpense = null,Object? balance = null,Object? byCategory = null,Object? dailyExpense = null,}) {
  return _then(_TransactionSummary(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as int,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as int,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,byCategory: null == byCategory ? _self._byCategory : byCategory // ignore: cast_nullable_to_non_nullable
as Map<String, int>,dailyExpense: null == dailyExpense ? _self._dailyExpense : dailyExpense // ignore: cast_nullable_to_non_nullable
as Map<int, int>,
  ));
}


}

// dart format on
