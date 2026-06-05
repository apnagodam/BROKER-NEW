// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sbt_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SbtProductsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SbtProductResponse products) loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SbtProductResponse products)? loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SbtProductResponse products)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SbtProductsStateCopyWith<$Res> {
  factory $SbtProductsStateCopyWith(
    SbtProductsState value,
    $Res Function(SbtProductsState) then,
  ) = _$SbtProductsStateCopyWithImpl<$Res, SbtProductsState>;
}

/// @nodoc
class _$SbtProductsStateCopyWithImpl<$Res, $Val extends SbtProductsState>
    implements $SbtProductsStateCopyWith<$Res> {
  _$SbtProductsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SbtProductsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
    _$InitialImpl value,
    $Res Function(_$InitialImpl) then,
  ) = __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$SbtProductsStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SbtProductsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'SbtProductsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SbtProductResponse products) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SbtProductResponse products)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SbtProductResponse products)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements SbtProductsState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
    _$LoadingImpl value,
    $Res Function(_$LoadingImpl) then,
  ) = __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$SbtProductsStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
    _$LoadingImpl _value,
    $Res Function(_$LoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SbtProductsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'SbtProductsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SbtProductResponse products) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SbtProductResponse products)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SbtProductResponse products)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements SbtProductsState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$LoadedImplCopyWith<$Res> {
  factory _$$LoadedImplCopyWith(
    _$LoadedImpl value,
    $Res Function(_$LoadedImpl) then,
  ) = __$$LoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SbtProductResponse products});
}

/// @nodoc
class __$$LoadedImplCopyWithImpl<$Res>
    extends _$SbtProductsStateCopyWithImpl<$Res, _$LoadedImpl>
    implements _$$LoadedImplCopyWith<$Res> {
  __$$LoadedImplCopyWithImpl(
    _$LoadedImpl _value,
    $Res Function(_$LoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SbtProductsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? products = null}) {
    return _then(
      _$LoadedImpl(
        null == products
            ? _value.products
            : products // ignore: cast_nullable_to_non_nullable
                  as SbtProductResponse,
      ),
    );
  }
}

/// @nodoc

class _$LoadedImpl implements _Loaded {
  const _$LoadedImpl(this.products);

  @override
  final SbtProductResponse products;

  @override
  String toString() {
    return 'SbtProductsState.loaded(products: $products)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedImpl &&
            (identical(other.products, products) ||
                other.products == products));
  }

  @override
  int get hashCode => Object.hash(runtimeType, products);

  /// Create a copy of SbtProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      __$$LoadedImplCopyWithImpl<_$LoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SbtProductResponse products) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(products);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SbtProductResponse products)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(products);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SbtProductResponse products)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(products);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _Loaded implements SbtProductsState {
  const factory _Loaded(final SbtProductResponse products) = _$LoadedImpl;

  SbtProductResponse get products;

  /// Create a copy of SbtProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
    _$ErrorImpl value,
    $Res Function(_$ErrorImpl) then,
  ) = __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$SbtProductsStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
    _$ErrorImpl _value,
    $Res Function(_$ErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SbtProductsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SbtProductsState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SbtProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SbtProductResponse products) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SbtProductResponse products)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SbtProductResponse products)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements SbtProductsState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of SbtProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DeliveryCentersState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(DeliveryCentersModel centers) loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(DeliveryCentersModel centers)? loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(DeliveryCentersModel centers)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DeliveryCentersInitial value) initial,
    required TResult Function(_DeliveryCentersLoading value) loading,
    required TResult Function(_DeliveryCentersLoaded value) loaded,
    required TResult Function(_DeliveryCentersError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DeliveryCentersInitial value)? initial,
    TResult? Function(_DeliveryCentersLoading value)? loading,
    TResult? Function(_DeliveryCentersLoaded value)? loaded,
    TResult? Function(_DeliveryCentersError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DeliveryCentersInitial value)? initial,
    TResult Function(_DeliveryCentersLoading value)? loading,
    TResult Function(_DeliveryCentersLoaded value)? loaded,
    TResult Function(_DeliveryCentersError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryCentersStateCopyWith<$Res> {
  factory $DeliveryCentersStateCopyWith(
    DeliveryCentersState value,
    $Res Function(DeliveryCentersState) then,
  ) = _$DeliveryCentersStateCopyWithImpl<$Res, DeliveryCentersState>;
}

/// @nodoc
class _$DeliveryCentersStateCopyWithImpl<
  $Res,
  $Val extends DeliveryCentersState
>
    implements $DeliveryCentersStateCopyWith<$Res> {
  _$DeliveryCentersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeliveryCentersState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DeliveryCentersInitialImplCopyWith<$Res> {
  factory _$$DeliveryCentersInitialImplCopyWith(
    _$DeliveryCentersInitialImpl value,
    $Res Function(_$DeliveryCentersInitialImpl) then,
  ) = __$$DeliveryCentersInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeliveryCentersInitialImplCopyWithImpl<$Res>
    extends
        _$DeliveryCentersStateCopyWithImpl<$Res, _$DeliveryCentersInitialImpl>
    implements _$$DeliveryCentersInitialImplCopyWith<$Res> {
  __$$DeliveryCentersInitialImplCopyWithImpl(
    _$DeliveryCentersInitialImpl _value,
    $Res Function(_$DeliveryCentersInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryCentersState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DeliveryCentersInitialImpl implements _DeliveryCentersInitial {
  const _$DeliveryCentersInitialImpl();

  @override
  String toString() {
    return 'DeliveryCentersState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryCentersInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(DeliveryCentersModel centers) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(DeliveryCentersModel centers)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(DeliveryCentersModel centers)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DeliveryCentersInitial value) initial,
    required TResult Function(_DeliveryCentersLoading value) loading,
    required TResult Function(_DeliveryCentersLoaded value) loaded,
    required TResult Function(_DeliveryCentersError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DeliveryCentersInitial value)? initial,
    TResult? Function(_DeliveryCentersLoading value)? loading,
    TResult? Function(_DeliveryCentersLoaded value)? loaded,
    TResult? Function(_DeliveryCentersError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DeliveryCentersInitial value)? initial,
    TResult Function(_DeliveryCentersLoading value)? loading,
    TResult Function(_DeliveryCentersLoaded value)? loaded,
    TResult Function(_DeliveryCentersError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _DeliveryCentersInitial implements DeliveryCentersState {
  const factory _DeliveryCentersInitial() = _$DeliveryCentersInitialImpl;
}

/// @nodoc
abstract class _$$DeliveryCentersLoadingImplCopyWith<$Res> {
  factory _$$DeliveryCentersLoadingImplCopyWith(
    _$DeliveryCentersLoadingImpl value,
    $Res Function(_$DeliveryCentersLoadingImpl) then,
  ) = __$$DeliveryCentersLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeliveryCentersLoadingImplCopyWithImpl<$Res>
    extends
        _$DeliveryCentersStateCopyWithImpl<$Res, _$DeliveryCentersLoadingImpl>
    implements _$$DeliveryCentersLoadingImplCopyWith<$Res> {
  __$$DeliveryCentersLoadingImplCopyWithImpl(
    _$DeliveryCentersLoadingImpl _value,
    $Res Function(_$DeliveryCentersLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryCentersState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DeliveryCentersLoadingImpl implements _DeliveryCentersLoading {
  const _$DeliveryCentersLoadingImpl();

  @override
  String toString() {
    return 'DeliveryCentersState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryCentersLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(DeliveryCentersModel centers) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(DeliveryCentersModel centers)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(DeliveryCentersModel centers)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DeliveryCentersInitial value) initial,
    required TResult Function(_DeliveryCentersLoading value) loading,
    required TResult Function(_DeliveryCentersLoaded value) loaded,
    required TResult Function(_DeliveryCentersError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DeliveryCentersInitial value)? initial,
    TResult? Function(_DeliveryCentersLoading value)? loading,
    TResult? Function(_DeliveryCentersLoaded value)? loaded,
    TResult? Function(_DeliveryCentersError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DeliveryCentersInitial value)? initial,
    TResult Function(_DeliveryCentersLoading value)? loading,
    TResult Function(_DeliveryCentersLoaded value)? loaded,
    TResult Function(_DeliveryCentersError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _DeliveryCentersLoading implements DeliveryCentersState {
  const factory _DeliveryCentersLoading() = _$DeliveryCentersLoadingImpl;
}

/// @nodoc
abstract class _$$DeliveryCentersLoadedImplCopyWith<$Res> {
  factory _$$DeliveryCentersLoadedImplCopyWith(
    _$DeliveryCentersLoadedImpl value,
    $Res Function(_$DeliveryCentersLoadedImpl) then,
  ) = __$$DeliveryCentersLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DeliveryCentersModel centers});
}

/// @nodoc
class __$$DeliveryCentersLoadedImplCopyWithImpl<$Res>
    extends
        _$DeliveryCentersStateCopyWithImpl<$Res, _$DeliveryCentersLoadedImpl>
    implements _$$DeliveryCentersLoadedImplCopyWith<$Res> {
  __$$DeliveryCentersLoadedImplCopyWithImpl(
    _$DeliveryCentersLoadedImpl _value,
    $Res Function(_$DeliveryCentersLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryCentersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? centers = null}) {
    return _then(
      _$DeliveryCentersLoadedImpl(
        null == centers
            ? _value.centers
            : centers // ignore: cast_nullable_to_non_nullable
                  as DeliveryCentersModel,
      ),
    );
  }
}

/// @nodoc

class _$DeliveryCentersLoadedImpl implements _DeliveryCentersLoaded {
  const _$DeliveryCentersLoadedImpl(this.centers);

  @override
  final DeliveryCentersModel centers;

  @override
  String toString() {
    return 'DeliveryCentersState.loaded(centers: $centers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryCentersLoadedImpl &&
            (identical(other.centers, centers) || other.centers == centers));
  }

  @override
  int get hashCode => Object.hash(runtimeType, centers);

  /// Create a copy of DeliveryCentersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryCentersLoadedImplCopyWith<_$DeliveryCentersLoadedImpl>
  get copyWith =>
      __$$DeliveryCentersLoadedImplCopyWithImpl<_$DeliveryCentersLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(DeliveryCentersModel centers) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(centers);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(DeliveryCentersModel centers)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(centers);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(DeliveryCentersModel centers)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(centers);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DeliveryCentersInitial value) initial,
    required TResult Function(_DeliveryCentersLoading value) loading,
    required TResult Function(_DeliveryCentersLoaded value) loaded,
    required TResult Function(_DeliveryCentersError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DeliveryCentersInitial value)? initial,
    TResult? Function(_DeliveryCentersLoading value)? loading,
    TResult? Function(_DeliveryCentersLoaded value)? loaded,
    TResult? Function(_DeliveryCentersError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DeliveryCentersInitial value)? initial,
    TResult Function(_DeliveryCentersLoading value)? loading,
    TResult Function(_DeliveryCentersLoaded value)? loaded,
    TResult Function(_DeliveryCentersError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _DeliveryCentersLoaded implements DeliveryCentersState {
  const factory _DeliveryCentersLoaded(final DeliveryCentersModel centers) =
      _$DeliveryCentersLoadedImpl;

  DeliveryCentersModel get centers;

  /// Create a copy of DeliveryCentersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliveryCentersLoadedImplCopyWith<_$DeliveryCentersLoadedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeliveryCentersErrorImplCopyWith<$Res> {
  factory _$$DeliveryCentersErrorImplCopyWith(
    _$DeliveryCentersErrorImpl value,
    $Res Function(_$DeliveryCentersErrorImpl) then,
  ) = __$$DeliveryCentersErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$DeliveryCentersErrorImplCopyWithImpl<$Res>
    extends _$DeliveryCentersStateCopyWithImpl<$Res, _$DeliveryCentersErrorImpl>
    implements _$$DeliveryCentersErrorImplCopyWith<$Res> {
  __$$DeliveryCentersErrorImplCopyWithImpl(
    _$DeliveryCentersErrorImpl _value,
    $Res Function(_$DeliveryCentersErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryCentersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$DeliveryCentersErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DeliveryCentersErrorImpl implements _DeliveryCentersError {
  const _$DeliveryCentersErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'DeliveryCentersState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryCentersErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of DeliveryCentersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryCentersErrorImplCopyWith<_$DeliveryCentersErrorImpl>
  get copyWith =>
      __$$DeliveryCentersErrorImplCopyWithImpl<_$DeliveryCentersErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(DeliveryCentersModel centers) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(DeliveryCentersModel centers)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(DeliveryCentersModel centers)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DeliveryCentersInitial value) initial,
    required TResult Function(_DeliveryCentersLoading value) loading,
    required TResult Function(_DeliveryCentersLoaded value) loaded,
    required TResult Function(_DeliveryCentersError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DeliveryCentersInitial value)? initial,
    TResult? Function(_DeliveryCentersLoading value)? loading,
    TResult? Function(_DeliveryCentersLoaded value)? loaded,
    TResult? Function(_DeliveryCentersError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DeliveryCentersInitial value)? initial,
    TResult Function(_DeliveryCentersLoading value)? loading,
    TResult Function(_DeliveryCentersLoaded value)? loaded,
    TResult Function(_DeliveryCentersError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _DeliveryCentersError implements DeliveryCentersState {
  const factory _DeliveryCentersError(final String message) =
      _$DeliveryCentersErrorImpl;

  String get message;

  /// Create a copy of DeliveryCentersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliveryCentersErrorImplCopyWith<_$DeliveryCentersErrorImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MatchedOrdersState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SbtMatchedOrderResponse orders) loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SbtMatchedOrderResponse orders)? loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SbtMatchedOrderResponse orders)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_MatchedOrdersInitial value) initial,
    required TResult Function(_MatchedOrdersLoading value) loading,
    required TResult Function(_MatchedOrdersLoaded value) loaded,
    required TResult Function(_MatchedOrdersError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_MatchedOrdersInitial value)? initial,
    TResult? Function(_MatchedOrdersLoading value)? loading,
    TResult? Function(_MatchedOrdersLoaded value)? loaded,
    TResult? Function(_MatchedOrdersError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_MatchedOrdersInitial value)? initial,
    TResult Function(_MatchedOrdersLoading value)? loading,
    TResult Function(_MatchedOrdersLoaded value)? loaded,
    TResult Function(_MatchedOrdersError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchedOrdersStateCopyWith<$Res> {
  factory $MatchedOrdersStateCopyWith(
    MatchedOrdersState value,
    $Res Function(MatchedOrdersState) then,
  ) = _$MatchedOrdersStateCopyWithImpl<$Res, MatchedOrdersState>;
}

/// @nodoc
class _$MatchedOrdersStateCopyWithImpl<$Res, $Val extends MatchedOrdersState>
    implements $MatchedOrdersStateCopyWith<$Res> {
  _$MatchedOrdersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchedOrdersState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$MatchedOrdersInitialImplCopyWith<$Res> {
  factory _$$MatchedOrdersInitialImplCopyWith(
    _$MatchedOrdersInitialImpl value,
    $Res Function(_$MatchedOrdersInitialImpl) then,
  ) = __$$MatchedOrdersInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$MatchedOrdersInitialImplCopyWithImpl<$Res>
    extends _$MatchedOrdersStateCopyWithImpl<$Res, _$MatchedOrdersInitialImpl>
    implements _$$MatchedOrdersInitialImplCopyWith<$Res> {
  __$$MatchedOrdersInitialImplCopyWithImpl(
    _$MatchedOrdersInitialImpl _value,
    $Res Function(_$MatchedOrdersInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchedOrdersState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$MatchedOrdersInitialImpl implements _MatchedOrdersInitial {
  const _$MatchedOrdersInitialImpl();

  @override
  String toString() {
    return 'MatchedOrdersState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchedOrdersInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SbtMatchedOrderResponse orders) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SbtMatchedOrderResponse orders)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SbtMatchedOrderResponse orders)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_MatchedOrdersInitial value) initial,
    required TResult Function(_MatchedOrdersLoading value) loading,
    required TResult Function(_MatchedOrdersLoaded value) loaded,
    required TResult Function(_MatchedOrdersError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_MatchedOrdersInitial value)? initial,
    TResult? Function(_MatchedOrdersLoading value)? loading,
    TResult? Function(_MatchedOrdersLoaded value)? loaded,
    TResult? Function(_MatchedOrdersError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_MatchedOrdersInitial value)? initial,
    TResult Function(_MatchedOrdersLoading value)? loading,
    TResult Function(_MatchedOrdersLoaded value)? loaded,
    TResult Function(_MatchedOrdersError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _MatchedOrdersInitial implements MatchedOrdersState {
  const factory _MatchedOrdersInitial() = _$MatchedOrdersInitialImpl;
}

/// @nodoc
abstract class _$$MatchedOrdersLoadingImplCopyWith<$Res> {
  factory _$$MatchedOrdersLoadingImplCopyWith(
    _$MatchedOrdersLoadingImpl value,
    $Res Function(_$MatchedOrdersLoadingImpl) then,
  ) = __$$MatchedOrdersLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$MatchedOrdersLoadingImplCopyWithImpl<$Res>
    extends _$MatchedOrdersStateCopyWithImpl<$Res, _$MatchedOrdersLoadingImpl>
    implements _$$MatchedOrdersLoadingImplCopyWith<$Res> {
  __$$MatchedOrdersLoadingImplCopyWithImpl(
    _$MatchedOrdersLoadingImpl _value,
    $Res Function(_$MatchedOrdersLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchedOrdersState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$MatchedOrdersLoadingImpl implements _MatchedOrdersLoading {
  const _$MatchedOrdersLoadingImpl();

  @override
  String toString() {
    return 'MatchedOrdersState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchedOrdersLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SbtMatchedOrderResponse orders) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SbtMatchedOrderResponse orders)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SbtMatchedOrderResponse orders)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_MatchedOrdersInitial value) initial,
    required TResult Function(_MatchedOrdersLoading value) loading,
    required TResult Function(_MatchedOrdersLoaded value) loaded,
    required TResult Function(_MatchedOrdersError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_MatchedOrdersInitial value)? initial,
    TResult? Function(_MatchedOrdersLoading value)? loading,
    TResult? Function(_MatchedOrdersLoaded value)? loaded,
    TResult? Function(_MatchedOrdersError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_MatchedOrdersInitial value)? initial,
    TResult Function(_MatchedOrdersLoading value)? loading,
    TResult Function(_MatchedOrdersLoaded value)? loaded,
    TResult Function(_MatchedOrdersError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _MatchedOrdersLoading implements MatchedOrdersState {
  const factory _MatchedOrdersLoading() = _$MatchedOrdersLoadingImpl;
}

/// @nodoc
abstract class _$$MatchedOrdersLoadedImplCopyWith<$Res> {
  factory _$$MatchedOrdersLoadedImplCopyWith(
    _$MatchedOrdersLoadedImpl value,
    $Res Function(_$MatchedOrdersLoadedImpl) then,
  ) = __$$MatchedOrdersLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SbtMatchedOrderResponse orders});
}

/// @nodoc
class __$$MatchedOrdersLoadedImplCopyWithImpl<$Res>
    extends _$MatchedOrdersStateCopyWithImpl<$Res, _$MatchedOrdersLoadedImpl>
    implements _$$MatchedOrdersLoadedImplCopyWith<$Res> {
  __$$MatchedOrdersLoadedImplCopyWithImpl(
    _$MatchedOrdersLoadedImpl _value,
    $Res Function(_$MatchedOrdersLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchedOrdersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? orders = null}) {
    return _then(
      _$MatchedOrdersLoadedImpl(
        null == orders
            ? _value.orders
            : orders // ignore: cast_nullable_to_non_nullable
                  as SbtMatchedOrderResponse,
      ),
    );
  }
}

/// @nodoc

class _$MatchedOrdersLoadedImpl implements _MatchedOrdersLoaded {
  const _$MatchedOrdersLoadedImpl(this.orders);

  @override
  final SbtMatchedOrderResponse orders;

  @override
  String toString() {
    return 'MatchedOrdersState.loaded(orders: $orders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchedOrdersLoadedImpl &&
            (identical(other.orders, orders) || other.orders == orders));
  }

  @override
  int get hashCode => Object.hash(runtimeType, orders);

  /// Create a copy of MatchedOrdersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchedOrdersLoadedImplCopyWith<_$MatchedOrdersLoadedImpl> get copyWith =>
      __$$MatchedOrdersLoadedImplCopyWithImpl<_$MatchedOrdersLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SbtMatchedOrderResponse orders) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(orders);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SbtMatchedOrderResponse orders)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(orders);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SbtMatchedOrderResponse orders)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(orders);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_MatchedOrdersInitial value) initial,
    required TResult Function(_MatchedOrdersLoading value) loading,
    required TResult Function(_MatchedOrdersLoaded value) loaded,
    required TResult Function(_MatchedOrdersError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_MatchedOrdersInitial value)? initial,
    TResult? Function(_MatchedOrdersLoading value)? loading,
    TResult? Function(_MatchedOrdersLoaded value)? loaded,
    TResult? Function(_MatchedOrdersError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_MatchedOrdersInitial value)? initial,
    TResult Function(_MatchedOrdersLoading value)? loading,
    TResult Function(_MatchedOrdersLoaded value)? loaded,
    TResult Function(_MatchedOrdersError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _MatchedOrdersLoaded implements MatchedOrdersState {
  const factory _MatchedOrdersLoaded(final SbtMatchedOrderResponse orders) =
      _$MatchedOrdersLoadedImpl;

  SbtMatchedOrderResponse get orders;

  /// Create a copy of MatchedOrdersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchedOrdersLoadedImplCopyWith<_$MatchedOrdersLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MatchedOrdersErrorImplCopyWith<$Res> {
  factory _$$MatchedOrdersErrorImplCopyWith(
    _$MatchedOrdersErrorImpl value,
    $Res Function(_$MatchedOrdersErrorImpl) then,
  ) = __$$MatchedOrdersErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$MatchedOrdersErrorImplCopyWithImpl<$Res>
    extends _$MatchedOrdersStateCopyWithImpl<$Res, _$MatchedOrdersErrorImpl>
    implements _$$MatchedOrdersErrorImplCopyWith<$Res> {
  __$$MatchedOrdersErrorImplCopyWithImpl(
    _$MatchedOrdersErrorImpl _value,
    $Res Function(_$MatchedOrdersErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchedOrdersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$MatchedOrdersErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$MatchedOrdersErrorImpl implements _MatchedOrdersError {
  const _$MatchedOrdersErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'MatchedOrdersState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchedOrdersErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of MatchedOrdersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchedOrdersErrorImplCopyWith<_$MatchedOrdersErrorImpl> get copyWith =>
      __$$MatchedOrdersErrorImplCopyWithImpl<_$MatchedOrdersErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SbtMatchedOrderResponse orders) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SbtMatchedOrderResponse orders)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SbtMatchedOrderResponse orders)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_MatchedOrdersInitial value) initial,
    required TResult Function(_MatchedOrdersLoading value) loading,
    required TResult Function(_MatchedOrdersLoaded value) loaded,
    required TResult Function(_MatchedOrdersError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_MatchedOrdersInitial value)? initial,
    TResult? Function(_MatchedOrdersLoading value)? loading,
    TResult? Function(_MatchedOrdersLoaded value)? loaded,
    TResult? Function(_MatchedOrdersError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_MatchedOrdersInitial value)? initial,
    TResult Function(_MatchedOrdersLoading value)? loading,
    TResult Function(_MatchedOrdersLoaded value)? loaded,
    TResult Function(_MatchedOrdersError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _MatchedOrdersError implements MatchedOrdersState {
  const factory _MatchedOrdersError(final String message) =
      _$MatchedOrdersErrorImpl;

  String get message;

  /// Create a copy of MatchedOrdersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchedOrdersErrorImplCopyWith<_$MatchedOrdersErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TradeListState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TradeListModel tradeList) loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TradeListModel tradeList)? loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TradeListModel tradeList)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TradeListInitial value) initial,
    required TResult Function(_TradeListLoading value) loading,
    required TResult Function(_TradeListLoaded value) loaded,
    required TResult Function(_TradeListError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TradeListInitial value)? initial,
    TResult? Function(_TradeListLoading value)? loading,
    TResult? Function(_TradeListLoaded value)? loaded,
    TResult? Function(_TradeListError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TradeListInitial value)? initial,
    TResult Function(_TradeListLoading value)? loading,
    TResult Function(_TradeListLoaded value)? loaded,
    TResult Function(_TradeListError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TradeListStateCopyWith<$Res> {
  factory $TradeListStateCopyWith(
    TradeListState value,
    $Res Function(TradeListState) then,
  ) = _$TradeListStateCopyWithImpl<$Res, TradeListState>;
}

/// @nodoc
class _$TradeListStateCopyWithImpl<$Res, $Val extends TradeListState>
    implements $TradeListStateCopyWith<$Res> {
  _$TradeListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TradeListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$TradeListInitialImplCopyWith<$Res> {
  factory _$$TradeListInitialImplCopyWith(
    _$TradeListInitialImpl value,
    $Res Function(_$TradeListInitialImpl) then,
  ) = __$$TradeListInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TradeListInitialImplCopyWithImpl<$Res>
    extends _$TradeListStateCopyWithImpl<$Res, _$TradeListInitialImpl>
    implements _$$TradeListInitialImplCopyWith<$Res> {
  __$$TradeListInitialImplCopyWithImpl(
    _$TradeListInitialImpl _value,
    $Res Function(_$TradeListInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TradeListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TradeListInitialImpl implements _TradeListInitial {
  const _$TradeListInitialImpl();

  @override
  String toString() {
    return 'TradeListState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TradeListInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TradeListModel tradeList) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TradeListModel tradeList)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TradeListModel tradeList)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TradeListInitial value) initial,
    required TResult Function(_TradeListLoading value) loading,
    required TResult Function(_TradeListLoaded value) loaded,
    required TResult Function(_TradeListError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TradeListInitial value)? initial,
    TResult? Function(_TradeListLoading value)? loading,
    TResult? Function(_TradeListLoaded value)? loaded,
    TResult? Function(_TradeListError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TradeListInitial value)? initial,
    TResult Function(_TradeListLoading value)? loading,
    TResult Function(_TradeListLoaded value)? loaded,
    TResult Function(_TradeListError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _TradeListInitial implements TradeListState {
  const factory _TradeListInitial() = _$TradeListInitialImpl;
}

/// @nodoc
abstract class _$$TradeListLoadingImplCopyWith<$Res> {
  factory _$$TradeListLoadingImplCopyWith(
    _$TradeListLoadingImpl value,
    $Res Function(_$TradeListLoadingImpl) then,
  ) = __$$TradeListLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TradeListLoadingImplCopyWithImpl<$Res>
    extends _$TradeListStateCopyWithImpl<$Res, _$TradeListLoadingImpl>
    implements _$$TradeListLoadingImplCopyWith<$Res> {
  __$$TradeListLoadingImplCopyWithImpl(
    _$TradeListLoadingImpl _value,
    $Res Function(_$TradeListLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TradeListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TradeListLoadingImpl implements _TradeListLoading {
  const _$TradeListLoadingImpl();

  @override
  String toString() {
    return 'TradeListState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TradeListLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TradeListModel tradeList) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TradeListModel tradeList)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TradeListModel tradeList)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TradeListInitial value) initial,
    required TResult Function(_TradeListLoading value) loading,
    required TResult Function(_TradeListLoaded value) loaded,
    required TResult Function(_TradeListError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TradeListInitial value)? initial,
    TResult? Function(_TradeListLoading value)? loading,
    TResult? Function(_TradeListLoaded value)? loaded,
    TResult? Function(_TradeListError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TradeListInitial value)? initial,
    TResult Function(_TradeListLoading value)? loading,
    TResult Function(_TradeListLoaded value)? loaded,
    TResult Function(_TradeListError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _TradeListLoading implements TradeListState {
  const factory _TradeListLoading() = _$TradeListLoadingImpl;
}

/// @nodoc
abstract class _$$TradeListLoadedImplCopyWith<$Res> {
  factory _$$TradeListLoadedImplCopyWith(
    _$TradeListLoadedImpl value,
    $Res Function(_$TradeListLoadedImpl) then,
  ) = __$$TradeListLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TradeListModel tradeList});
}

/// @nodoc
class __$$TradeListLoadedImplCopyWithImpl<$Res>
    extends _$TradeListStateCopyWithImpl<$Res, _$TradeListLoadedImpl>
    implements _$$TradeListLoadedImplCopyWith<$Res> {
  __$$TradeListLoadedImplCopyWithImpl(
    _$TradeListLoadedImpl _value,
    $Res Function(_$TradeListLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TradeListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tradeList = null}) {
    return _then(
      _$TradeListLoadedImpl(
        null == tradeList
            ? _value.tradeList
            : tradeList // ignore: cast_nullable_to_non_nullable
                  as TradeListModel,
      ),
    );
  }
}

/// @nodoc

class _$TradeListLoadedImpl implements _TradeListLoaded {
  const _$TradeListLoadedImpl(this.tradeList);

  @override
  final TradeListModel tradeList;

  @override
  String toString() {
    return 'TradeListState.loaded(tradeList: $tradeList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TradeListLoadedImpl &&
            (identical(other.tradeList, tradeList) ||
                other.tradeList == tradeList));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tradeList);

  /// Create a copy of TradeListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TradeListLoadedImplCopyWith<_$TradeListLoadedImpl> get copyWith =>
      __$$TradeListLoadedImplCopyWithImpl<_$TradeListLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TradeListModel tradeList) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(tradeList);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TradeListModel tradeList)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(tradeList);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TradeListModel tradeList)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(tradeList);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TradeListInitial value) initial,
    required TResult Function(_TradeListLoading value) loading,
    required TResult Function(_TradeListLoaded value) loaded,
    required TResult Function(_TradeListError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TradeListInitial value)? initial,
    TResult? Function(_TradeListLoading value)? loading,
    TResult? Function(_TradeListLoaded value)? loaded,
    TResult? Function(_TradeListError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TradeListInitial value)? initial,
    TResult Function(_TradeListLoading value)? loading,
    TResult Function(_TradeListLoaded value)? loaded,
    TResult Function(_TradeListError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _TradeListLoaded implements TradeListState {
  const factory _TradeListLoaded(final TradeListModel tradeList) =
      _$TradeListLoadedImpl;

  TradeListModel get tradeList;

  /// Create a copy of TradeListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TradeListLoadedImplCopyWith<_$TradeListLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TradeListErrorImplCopyWith<$Res> {
  factory _$$TradeListErrorImplCopyWith(
    _$TradeListErrorImpl value,
    $Res Function(_$TradeListErrorImpl) then,
  ) = __$$TradeListErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$TradeListErrorImplCopyWithImpl<$Res>
    extends _$TradeListStateCopyWithImpl<$Res, _$TradeListErrorImpl>
    implements _$$TradeListErrorImplCopyWith<$Res> {
  __$$TradeListErrorImplCopyWithImpl(
    _$TradeListErrorImpl _value,
    $Res Function(_$TradeListErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TradeListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$TradeListErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$TradeListErrorImpl implements _TradeListError {
  const _$TradeListErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'TradeListState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TradeListErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of TradeListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TradeListErrorImplCopyWith<_$TradeListErrorImpl> get copyWith =>
      __$$TradeListErrorImplCopyWithImpl<_$TradeListErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TradeListModel tradeList) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TradeListModel tradeList)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TradeListModel tradeList)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TradeListInitial value) initial,
    required TResult Function(_TradeListLoading value) loading,
    required TResult Function(_TradeListLoaded value) loaded,
    required TResult Function(_TradeListError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TradeListInitial value)? initial,
    TResult? Function(_TradeListLoading value)? loading,
    TResult? Function(_TradeListLoaded value)? loaded,
    TResult? Function(_TradeListError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TradeListInitial value)? initial,
    TResult Function(_TradeListLoading value)? loading,
    TResult Function(_TradeListLoaded value)? loaded,
    TResult Function(_TradeListError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _TradeListError implements TradeListState {
  const factory _TradeListError(final String message) = _$TradeListErrorImpl;

  String get message;

  /// Create a copy of TradeListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TradeListErrorImplCopyWith<_$TradeListErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
