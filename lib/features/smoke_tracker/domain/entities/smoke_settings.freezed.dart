// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smoke_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SmokeSettings {

 bool get isEnabled; int get dailyLimit; int get cigarettesPerPack; int get pricePerPack; bool get notifyAtLimit; bool get notifyAt80Percent; bool get autoLogExpense; String get expenseWalletId;
/// Create a copy of SmokeSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmokeSettingsCopyWith<SmokeSettings> get copyWith => _$SmokeSettingsCopyWithImpl<SmokeSettings>(this as SmokeSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmokeSettings&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.dailyLimit, dailyLimit) || other.dailyLimit == dailyLimit)&&(identical(other.cigarettesPerPack, cigarettesPerPack) || other.cigarettesPerPack == cigarettesPerPack)&&(identical(other.pricePerPack, pricePerPack) || other.pricePerPack == pricePerPack)&&(identical(other.notifyAtLimit, notifyAtLimit) || other.notifyAtLimit == notifyAtLimit)&&(identical(other.notifyAt80Percent, notifyAt80Percent) || other.notifyAt80Percent == notifyAt80Percent)&&(identical(other.autoLogExpense, autoLogExpense) || other.autoLogExpense == autoLogExpense)&&(identical(other.expenseWalletId, expenseWalletId) || other.expenseWalletId == expenseWalletId));
}


@override
int get hashCode => Object.hash(runtimeType,isEnabled,dailyLimit,cigarettesPerPack,pricePerPack,notifyAtLimit,notifyAt80Percent,autoLogExpense,expenseWalletId);

@override
String toString() {
  return 'SmokeSettings(isEnabled: $isEnabled, dailyLimit: $dailyLimit, cigarettesPerPack: $cigarettesPerPack, pricePerPack: $pricePerPack, notifyAtLimit: $notifyAtLimit, notifyAt80Percent: $notifyAt80Percent, autoLogExpense: $autoLogExpense, expenseWalletId: $expenseWalletId)';
}


}

/// @nodoc
abstract mixin class $SmokeSettingsCopyWith<$Res>  {
  factory $SmokeSettingsCopyWith(SmokeSettings value, $Res Function(SmokeSettings) _then) = _$SmokeSettingsCopyWithImpl;
@useResult
$Res call({
 bool isEnabled, int dailyLimit, int cigarettesPerPack, int pricePerPack, bool notifyAtLimit, bool notifyAt80Percent, bool autoLogExpense, String expenseWalletId
});




}
/// @nodoc
class _$SmokeSettingsCopyWithImpl<$Res>
    implements $SmokeSettingsCopyWith<$Res> {
  _$SmokeSettingsCopyWithImpl(this._self, this._then);

  final SmokeSettings _self;
  final $Res Function(SmokeSettings) _then;

/// Create a copy of SmokeSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isEnabled = null,Object? dailyLimit = null,Object? cigarettesPerPack = null,Object? pricePerPack = null,Object? notifyAtLimit = null,Object? notifyAt80Percent = null,Object? autoLogExpense = null,Object? expenseWalletId = null,}) {
  return _then(_self.copyWith(
isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,dailyLimit: null == dailyLimit ? _self.dailyLimit : dailyLimit // ignore: cast_nullable_to_non_nullable
as int,cigarettesPerPack: null == cigarettesPerPack ? _self.cigarettesPerPack : cigarettesPerPack // ignore: cast_nullable_to_non_nullable
as int,pricePerPack: null == pricePerPack ? _self.pricePerPack : pricePerPack // ignore: cast_nullable_to_non_nullable
as int,notifyAtLimit: null == notifyAtLimit ? _self.notifyAtLimit : notifyAtLimit // ignore: cast_nullable_to_non_nullable
as bool,notifyAt80Percent: null == notifyAt80Percent ? _self.notifyAt80Percent : notifyAt80Percent // ignore: cast_nullable_to_non_nullable
as bool,autoLogExpense: null == autoLogExpense ? _self.autoLogExpense : autoLogExpense // ignore: cast_nullable_to_non_nullable
as bool,expenseWalletId: null == expenseWalletId ? _self.expenseWalletId : expenseWalletId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SmokeSettings].
extension SmokeSettingsPatterns on SmokeSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmokeSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmokeSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmokeSettings value)  $default,){
final _that = this;
switch (_that) {
case _SmokeSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmokeSettings value)?  $default,){
final _that = this;
switch (_that) {
case _SmokeSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isEnabled,  int dailyLimit,  int cigarettesPerPack,  int pricePerPack,  bool notifyAtLimit,  bool notifyAt80Percent,  bool autoLogExpense,  String expenseWalletId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmokeSettings() when $default != null:
return $default(_that.isEnabled,_that.dailyLimit,_that.cigarettesPerPack,_that.pricePerPack,_that.notifyAtLimit,_that.notifyAt80Percent,_that.autoLogExpense,_that.expenseWalletId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isEnabled,  int dailyLimit,  int cigarettesPerPack,  int pricePerPack,  bool notifyAtLimit,  bool notifyAt80Percent,  bool autoLogExpense,  String expenseWalletId)  $default,) {final _that = this;
switch (_that) {
case _SmokeSettings():
return $default(_that.isEnabled,_that.dailyLimit,_that.cigarettesPerPack,_that.pricePerPack,_that.notifyAtLimit,_that.notifyAt80Percent,_that.autoLogExpense,_that.expenseWalletId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isEnabled,  int dailyLimit,  int cigarettesPerPack,  int pricePerPack,  bool notifyAtLimit,  bool notifyAt80Percent,  bool autoLogExpense,  String expenseWalletId)?  $default,) {final _that = this;
switch (_that) {
case _SmokeSettings() when $default != null:
return $default(_that.isEnabled,_that.dailyLimit,_that.cigarettesPerPack,_that.pricePerPack,_that.notifyAtLimit,_that.notifyAt80Percent,_that.autoLogExpense,_that.expenseWalletId);case _:
  return null;

}
}

}

/// @nodoc


class _SmokeSettings implements SmokeSettings {
  const _SmokeSettings({required this.isEnabled, required this.dailyLimit, required this.cigarettesPerPack, required this.pricePerPack, required this.notifyAtLimit, required this.notifyAt80Percent, required this.autoLogExpense, required this.expenseWalletId});
  

@override final  bool isEnabled;
@override final  int dailyLimit;
@override final  int cigarettesPerPack;
@override final  int pricePerPack;
@override final  bool notifyAtLimit;
@override final  bool notifyAt80Percent;
@override final  bool autoLogExpense;
@override final  String expenseWalletId;

/// Create a copy of SmokeSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmokeSettingsCopyWith<_SmokeSettings> get copyWith => __$SmokeSettingsCopyWithImpl<_SmokeSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmokeSettings&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.dailyLimit, dailyLimit) || other.dailyLimit == dailyLimit)&&(identical(other.cigarettesPerPack, cigarettesPerPack) || other.cigarettesPerPack == cigarettesPerPack)&&(identical(other.pricePerPack, pricePerPack) || other.pricePerPack == pricePerPack)&&(identical(other.notifyAtLimit, notifyAtLimit) || other.notifyAtLimit == notifyAtLimit)&&(identical(other.notifyAt80Percent, notifyAt80Percent) || other.notifyAt80Percent == notifyAt80Percent)&&(identical(other.autoLogExpense, autoLogExpense) || other.autoLogExpense == autoLogExpense)&&(identical(other.expenseWalletId, expenseWalletId) || other.expenseWalletId == expenseWalletId));
}


@override
int get hashCode => Object.hash(runtimeType,isEnabled,dailyLimit,cigarettesPerPack,pricePerPack,notifyAtLimit,notifyAt80Percent,autoLogExpense,expenseWalletId);

@override
String toString() {
  return 'SmokeSettings(isEnabled: $isEnabled, dailyLimit: $dailyLimit, cigarettesPerPack: $cigarettesPerPack, pricePerPack: $pricePerPack, notifyAtLimit: $notifyAtLimit, notifyAt80Percent: $notifyAt80Percent, autoLogExpense: $autoLogExpense, expenseWalletId: $expenseWalletId)';
}


}

/// @nodoc
abstract mixin class _$SmokeSettingsCopyWith<$Res> implements $SmokeSettingsCopyWith<$Res> {
  factory _$SmokeSettingsCopyWith(_SmokeSettings value, $Res Function(_SmokeSettings) _then) = __$SmokeSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool isEnabled, int dailyLimit, int cigarettesPerPack, int pricePerPack, bool notifyAtLimit, bool notifyAt80Percent, bool autoLogExpense, String expenseWalletId
});




}
/// @nodoc
class __$SmokeSettingsCopyWithImpl<$Res>
    implements _$SmokeSettingsCopyWith<$Res> {
  __$SmokeSettingsCopyWithImpl(this._self, this._then);

  final _SmokeSettings _self;
  final $Res Function(_SmokeSettings) _then;

/// Create a copy of SmokeSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isEnabled = null,Object? dailyLimit = null,Object? cigarettesPerPack = null,Object? pricePerPack = null,Object? notifyAtLimit = null,Object? notifyAt80Percent = null,Object? autoLogExpense = null,Object? expenseWalletId = null,}) {
  return _then(_SmokeSettings(
isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,dailyLimit: null == dailyLimit ? _self.dailyLimit : dailyLimit // ignore: cast_nullable_to_non_nullable
as int,cigarettesPerPack: null == cigarettesPerPack ? _self.cigarettesPerPack : cigarettesPerPack // ignore: cast_nullable_to_non_nullable
as int,pricePerPack: null == pricePerPack ? _self.pricePerPack : pricePerPack // ignore: cast_nullable_to_non_nullable
as int,notifyAtLimit: null == notifyAtLimit ? _self.notifyAtLimit : notifyAtLimit // ignore: cast_nullable_to_non_nullable
as bool,notifyAt80Percent: null == notifyAt80Percent ? _self.notifyAt80Percent : notifyAt80Percent // ignore: cast_nullable_to_non_nullable
as bool,autoLogExpense: null == autoLogExpense ? _self.autoLogExpense : autoLogExpense // ignore: cast_nullable_to_non_nullable
as bool,expenseWalletId: null == expenseWalletId ? _self.expenseWalletId : expenseWalletId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
