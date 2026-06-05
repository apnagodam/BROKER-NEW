// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String phoneNumber) otpSent,
    required TResult Function(Map<String, dynamic> userData) authenticated,
    required TResult Function(String phoneNumber, Map<String, dynamic> response)
    partialLogin,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String phoneNumber)? otpSent,
    TResult? Function(Map<String, dynamic> userData)? authenticated,
    TResult? Function(String phoneNumber, Map<String, dynamic> response)?
    partialLogin,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String phoneNumber)? otpSent,
    TResult Function(Map<String, dynamic> userData)? authenticated,
    TResult Function(String phoneNumber, Map<String, dynamic> response)?
    partialLogin,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_PartialLogin value) partialLogin,
    required TResult Function(_Error value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_PartialLogin value)? partialLogin,
    TResult? Function(_Error value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_PartialLogin value)? partialLogin,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
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
    extends _$AuthStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'AuthState.initial()';
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
    required TResult Function(String phoneNumber) otpSent,
    required TResult Function(Map<String, dynamic> userData) authenticated,
    required TResult Function(String phoneNumber, Map<String, dynamic> response)
    partialLogin,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String phoneNumber)? otpSent,
    TResult? Function(Map<String, dynamic> userData)? authenticated,
    TResult? Function(String phoneNumber, Map<String, dynamic> response)?
    partialLogin,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String phoneNumber)? otpSent,
    TResult Function(Map<String, dynamic> userData)? authenticated,
    TResult Function(String phoneNumber, Map<String, dynamic> response)?
    partialLogin,
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
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_PartialLogin value) partialLogin,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_PartialLogin value)? partialLogin,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_PartialLogin value)? partialLogin,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements AuthState {
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
    extends _$AuthStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
    _$LoadingImpl _value,
    $Res Function(_$LoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'AuthState.loading()';
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
    required TResult Function(String phoneNumber) otpSent,
    required TResult Function(Map<String, dynamic> userData) authenticated,
    required TResult Function(String phoneNumber, Map<String, dynamic> response)
    partialLogin,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String phoneNumber)? otpSent,
    TResult? Function(Map<String, dynamic> userData)? authenticated,
    TResult? Function(String phoneNumber, Map<String, dynamic> response)?
    partialLogin,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String phoneNumber)? otpSent,
    TResult Function(Map<String, dynamic> userData)? authenticated,
    TResult Function(String phoneNumber, Map<String, dynamic> response)?
    partialLogin,
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
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_PartialLogin value) partialLogin,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_PartialLogin value)? partialLogin,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_PartialLogin value)? partialLogin,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements AuthState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$OtpSentImplCopyWith<$Res> {
  factory _$$OtpSentImplCopyWith(
    _$OtpSentImpl value,
    $Res Function(_$OtpSentImpl) then,
  ) = __$$OtpSentImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String phoneNumber});
}

/// @nodoc
class __$$OtpSentImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$OtpSentImpl>
    implements _$$OtpSentImplCopyWith<$Res> {
  __$$OtpSentImplCopyWithImpl(
    _$OtpSentImpl _value,
    $Res Function(_$OtpSentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? phoneNumber = null}) {
    return _then(
      _$OtpSentImpl(
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$OtpSentImpl implements _OtpSent {
  const _$OtpSentImpl({required this.phoneNumber});

  @override
  final String phoneNumber;

  @override
  String toString() {
    return 'AuthState.otpSent(phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpSentImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @override
  int get hashCode => Object.hash(runtimeType, phoneNumber);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpSentImplCopyWith<_$OtpSentImpl> get copyWith =>
      __$$OtpSentImplCopyWithImpl<_$OtpSentImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String phoneNumber) otpSent,
    required TResult Function(Map<String, dynamic> userData) authenticated,
    required TResult Function(String phoneNumber, Map<String, dynamic> response)
    partialLogin,
    required TResult Function(String message) error,
  }) {
    return otpSent(phoneNumber);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String phoneNumber)? otpSent,
    TResult? Function(Map<String, dynamic> userData)? authenticated,
    TResult? Function(String phoneNumber, Map<String, dynamic> response)?
    partialLogin,
    TResult? Function(String message)? error,
  }) {
    return otpSent?.call(phoneNumber);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String phoneNumber)? otpSent,
    TResult Function(Map<String, dynamic> userData)? authenticated,
    TResult Function(String phoneNumber, Map<String, dynamic> response)?
    partialLogin,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (otpSent != null) {
      return otpSent(phoneNumber);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_PartialLogin value) partialLogin,
    required TResult Function(_Error value) error,
  }) {
    return otpSent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_PartialLogin value)? partialLogin,
    TResult? Function(_Error value)? error,
  }) {
    return otpSent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_PartialLogin value)? partialLogin,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (otpSent != null) {
      return otpSent(this);
    }
    return orElse();
  }
}

abstract class _OtpSent implements AuthState {
  const factory _OtpSent({required final String phoneNumber}) = _$OtpSentImpl;

  String get phoneNumber;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OtpSentImplCopyWith<_$OtpSentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthenticatedImplCopyWith<$Res> {
  factory _$$AuthenticatedImplCopyWith(
    _$AuthenticatedImpl value,
    $Res Function(_$AuthenticatedImpl) then,
  ) = __$$AuthenticatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Map<String, dynamic> userData});
}

/// @nodoc
class __$$AuthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthenticatedImpl>
    implements _$$AuthenticatedImplCopyWith<$Res> {
  __$$AuthenticatedImplCopyWithImpl(
    _$AuthenticatedImpl _value,
    $Res Function(_$AuthenticatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userData = null}) {
    return _then(
      _$AuthenticatedImpl(
        userData: null == userData
            ? _value._userData
            : userData // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc

class _$AuthenticatedImpl implements _Authenticated {
  const _$AuthenticatedImpl({required final Map<String, dynamic> userData})
    : _userData = userData;

  final Map<String, dynamic> _userData;
  @override
  Map<String, dynamic> get userData {
    if (_userData is EqualUnmodifiableMapView) return _userData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_userData);
  }

  @override
  String toString() {
    return 'AuthState.authenticated(userData: $userData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticatedImpl &&
            const DeepCollectionEquality().equals(other._userData, _userData));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_userData));

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticatedImplCopyWith<_$AuthenticatedImpl> get copyWith =>
      __$$AuthenticatedImplCopyWithImpl<_$AuthenticatedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String phoneNumber) otpSent,
    required TResult Function(Map<String, dynamic> userData) authenticated,
    required TResult Function(String phoneNumber, Map<String, dynamic> response)
    partialLogin,
    required TResult Function(String message) error,
  }) {
    return authenticated(userData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String phoneNumber)? otpSent,
    TResult? Function(Map<String, dynamic> userData)? authenticated,
    TResult? Function(String phoneNumber, Map<String, dynamic> response)?
    partialLogin,
    TResult? Function(String message)? error,
  }) {
    return authenticated?.call(userData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String phoneNumber)? otpSent,
    TResult Function(Map<String, dynamic> userData)? authenticated,
    TResult Function(String phoneNumber, Map<String, dynamic> response)?
    partialLogin,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(userData);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_PartialLogin value) partialLogin,
    required TResult Function(_Error value) error,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_PartialLogin value)? partialLogin,
    TResult? Function(_Error value)? error,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_PartialLogin value)? partialLogin,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class _Authenticated implements AuthState {
  const factory _Authenticated({required final Map<String, dynamic> userData}) =
      _$AuthenticatedImpl;

  Map<String, dynamic> get userData;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthenticatedImplCopyWith<_$AuthenticatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PartialLoginImplCopyWith<$Res> {
  factory _$$PartialLoginImplCopyWith(
    _$PartialLoginImpl value,
    $Res Function(_$PartialLoginImpl) then,
  ) = __$$PartialLoginImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String phoneNumber, Map<String, dynamic> response});
}

/// @nodoc
class __$$PartialLoginImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$PartialLoginImpl>
    implements _$$PartialLoginImplCopyWith<$Res> {
  __$$PartialLoginImplCopyWithImpl(
    _$PartialLoginImpl _value,
    $Res Function(_$PartialLoginImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? phoneNumber = null, Object? response = null}) {
    return _then(
      _$PartialLoginImpl(
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        response: null == response
            ? _value._response
            : response // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc

class _$PartialLoginImpl implements _PartialLogin {
  const _$PartialLoginImpl({
    required this.phoneNumber,
    required final Map<String, dynamic> response,
  }) : _response = response;

  @override
  final String phoneNumber;
  final Map<String, dynamic> _response;
  @override
  Map<String, dynamic> get response {
    if (_response is EqualUnmodifiableMapView) return _response;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_response);
  }

  @override
  String toString() {
    return 'AuthState.partialLogin(phoneNumber: $phoneNumber, response: $response)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartialLoginImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            const DeepCollectionEquality().equals(other._response, _response));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    phoneNumber,
    const DeepCollectionEquality().hash(_response),
  );

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartialLoginImplCopyWith<_$PartialLoginImpl> get copyWith =>
      __$$PartialLoginImplCopyWithImpl<_$PartialLoginImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String phoneNumber) otpSent,
    required TResult Function(Map<String, dynamic> userData) authenticated,
    required TResult Function(String phoneNumber, Map<String, dynamic> response)
    partialLogin,
    required TResult Function(String message) error,
  }) {
    return partialLogin(phoneNumber, response);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String phoneNumber)? otpSent,
    TResult? Function(Map<String, dynamic> userData)? authenticated,
    TResult? Function(String phoneNumber, Map<String, dynamic> response)?
    partialLogin,
    TResult? Function(String message)? error,
  }) {
    return partialLogin?.call(phoneNumber, response);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String phoneNumber)? otpSent,
    TResult Function(Map<String, dynamic> userData)? authenticated,
    TResult Function(String phoneNumber, Map<String, dynamic> response)?
    partialLogin,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (partialLogin != null) {
      return partialLogin(phoneNumber, response);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_PartialLogin value) partialLogin,
    required TResult Function(_Error value) error,
  }) {
    return partialLogin(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_PartialLogin value)? partialLogin,
    TResult? Function(_Error value)? error,
  }) {
    return partialLogin?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_PartialLogin value)? partialLogin,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (partialLogin != null) {
      return partialLogin(this);
    }
    return orElse();
  }
}

abstract class _PartialLogin implements AuthState {
  const factory _PartialLogin({
    required final String phoneNumber,
    required final Map<String, dynamic> response,
  }) = _$PartialLoginImpl;

  String get phoneNumber;
  Map<String, dynamic> get response;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartialLoginImplCopyWith<_$PartialLoginImpl> get copyWith =>
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
    extends _$AuthStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
    _$ErrorImpl _value,
    $Res Function(_$ErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'AuthState.error(message: $message)';
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

  /// Create a copy of AuthState
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
    required TResult Function(String phoneNumber) otpSent,
    required TResult Function(Map<String, dynamic> userData) authenticated,
    required TResult Function(String phoneNumber, Map<String, dynamic> response)
    partialLogin,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String phoneNumber)? otpSent,
    TResult? Function(Map<String, dynamic> userData)? authenticated,
    TResult? Function(String phoneNumber, Map<String, dynamic> response)?
    partialLogin,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String phoneNumber)? otpSent,
    TResult Function(Map<String, dynamic> userData)? authenticated,
    TResult Function(String phoneNumber, Map<String, dynamic> response)?
    partialLogin,
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
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_PartialLogin value) partialLogin,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_PartialLogin value)? partialLogin,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_PartialLogin value)? partialLogin,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements AuthState {
  const factory _Error({required final String message}) = _$ErrorImpl;

  String get message;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
