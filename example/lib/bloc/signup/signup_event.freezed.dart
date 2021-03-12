// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'signup_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$SignUpEventTearOff {
  const _$SignUpEventTearOff();

  SignUpSetEmail setEmail(String email) {
    return SignUpSetEmail(
      email,
    );
  }

  SignUpSetPassword setPassword(String password) {
    return SignUpSetPassword(
      password,
    );
  }

  SignUpSetPasswordConfirmation setPasswordConfirmation(String password) {
    return SignUpSetPasswordConfirmation(
      password,
    );
  }
}

/// @nodoc
const $SignUpEvent = _$SignUpEventTearOff();

/// @nodoc
mixin _$SignUpEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email) setEmail,
    required TResult Function(String password) setPassword,
    required TResult Function(String password) setPasswordConfirmation,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email)? setEmail,
    TResult Function(String password)? setPassword,
    TResult Function(String password)? setPasswordConfirmation,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignUpSetEmail value) setEmail,
    required TResult Function(SignUpSetPassword value) setPassword,
    required TResult Function(SignUpSetPasswordConfirmation value)
        setPasswordConfirmation,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpSetEmail value)? setEmail,
    TResult Function(SignUpSetPassword value)? setPassword,
    TResult Function(SignUpSetPasswordConfirmation value)?
        setPasswordConfirmation,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignUpEventCopyWith<$Res> {
  factory $SignUpEventCopyWith(
          SignUpEvent value, $Res Function(SignUpEvent) then) =
      _$SignUpEventCopyWithImpl<$Res>;
}

/// @nodoc
class _$SignUpEventCopyWithImpl<$Res> implements $SignUpEventCopyWith<$Res> {
  _$SignUpEventCopyWithImpl(this._value, this._then);

  final SignUpEvent _value;
  // ignore: unused_field
  final $Res Function(SignUpEvent) _then;
}

/// @nodoc
abstract class $SignUpSetEmailCopyWith<$Res> {
  factory $SignUpSetEmailCopyWith(
          SignUpSetEmail value, $Res Function(SignUpSetEmail) then) =
      _$SignUpSetEmailCopyWithImpl<$Res>;
  $Res call({String email});
}

/// @nodoc
class _$SignUpSetEmailCopyWithImpl<$Res> extends _$SignUpEventCopyWithImpl<$Res>
    implements $SignUpSetEmailCopyWith<$Res> {
  _$SignUpSetEmailCopyWithImpl(
      SignUpSetEmail _value, $Res Function(SignUpSetEmail) _then)
      : super(_value, (v) => _then(v as SignUpSetEmail));

  @override
  SignUpSetEmail get _value => super._value as SignUpSetEmail;

  @override
  $Res call({
    Object? email = freezed,
  }) {
    return _then(SignUpSetEmail(
      email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
class _$SignUpSetEmail implements SignUpSetEmail {
  const _$SignUpSetEmail(this.email);

  @override
  final String email;

  @override
  String toString() {
    return 'SignUpEvent.setEmail(email: $email)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is SignUpSetEmail &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(email);

  @JsonKey(ignore: true)
  @override
  $SignUpSetEmailCopyWith<SignUpSetEmail> get copyWith =>
      _$SignUpSetEmailCopyWithImpl<SignUpSetEmail>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email) setEmail,
    required TResult Function(String password) setPassword,
    required TResult Function(String password) setPasswordConfirmation,
  }) {
    return setEmail(email);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email)? setEmail,
    TResult Function(String password)? setPassword,
    TResult Function(String password)? setPasswordConfirmation,
    required TResult orElse(),
  }) {
    if (setEmail != null) {
      return setEmail(email);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignUpSetEmail value) setEmail,
    required TResult Function(SignUpSetPassword value) setPassword,
    required TResult Function(SignUpSetPasswordConfirmation value)
        setPasswordConfirmation,
  }) {
    return setEmail(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpSetEmail value)? setEmail,
    TResult Function(SignUpSetPassword value)? setPassword,
    TResult Function(SignUpSetPasswordConfirmation value)?
        setPasswordConfirmation,
    required TResult orElse(),
  }) {
    if (setEmail != null) {
      return setEmail(this);
    }
    return orElse();
  }
}

abstract class SignUpSetEmail implements SignUpEvent {
  const factory SignUpSetEmail(String email) = _$SignUpSetEmail;

  String get email => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SignUpSetEmailCopyWith<SignUpSetEmail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignUpSetPasswordCopyWith<$Res> {
  factory $SignUpSetPasswordCopyWith(
          SignUpSetPassword value, $Res Function(SignUpSetPassword) then) =
      _$SignUpSetPasswordCopyWithImpl<$Res>;
  $Res call({String password});
}

/// @nodoc
class _$SignUpSetPasswordCopyWithImpl<$Res>
    extends _$SignUpEventCopyWithImpl<$Res>
    implements $SignUpSetPasswordCopyWith<$Res> {
  _$SignUpSetPasswordCopyWithImpl(
      SignUpSetPassword _value, $Res Function(SignUpSetPassword) _then)
      : super(_value, (v) => _then(v as SignUpSetPassword));

  @override
  SignUpSetPassword get _value => super._value as SignUpSetPassword;

  @override
  $Res call({
    Object? password = freezed,
  }) {
    return _then(SignUpSetPassword(
      password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
class _$SignUpSetPassword implements SignUpSetPassword {
  const _$SignUpSetPassword(this.password);

  @override
  final String password;

  @override
  String toString() {
    return 'SignUpEvent.setPassword(password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is SignUpSetPassword &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(password);

  @JsonKey(ignore: true)
  @override
  $SignUpSetPasswordCopyWith<SignUpSetPassword> get copyWith =>
      _$SignUpSetPasswordCopyWithImpl<SignUpSetPassword>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email) setEmail,
    required TResult Function(String password) setPassword,
    required TResult Function(String password) setPasswordConfirmation,
  }) {
    return setPassword(password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email)? setEmail,
    TResult Function(String password)? setPassword,
    TResult Function(String password)? setPasswordConfirmation,
    required TResult orElse(),
  }) {
    if (setPassword != null) {
      return setPassword(password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignUpSetEmail value) setEmail,
    required TResult Function(SignUpSetPassword value) setPassword,
    required TResult Function(SignUpSetPasswordConfirmation value)
        setPasswordConfirmation,
  }) {
    return setPassword(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpSetEmail value)? setEmail,
    TResult Function(SignUpSetPassword value)? setPassword,
    TResult Function(SignUpSetPasswordConfirmation value)?
        setPasswordConfirmation,
    required TResult orElse(),
  }) {
    if (setPassword != null) {
      return setPassword(this);
    }
    return orElse();
  }
}

abstract class SignUpSetPassword implements SignUpEvent {
  const factory SignUpSetPassword(String password) = _$SignUpSetPassword;

  String get password => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SignUpSetPasswordCopyWith<SignUpSetPassword> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignUpSetPasswordConfirmationCopyWith<$Res> {
  factory $SignUpSetPasswordConfirmationCopyWith(
          SignUpSetPasswordConfirmation value,
          $Res Function(SignUpSetPasswordConfirmation) then) =
      _$SignUpSetPasswordConfirmationCopyWithImpl<$Res>;
  $Res call({String password});
}

/// @nodoc
class _$SignUpSetPasswordConfirmationCopyWithImpl<$Res>
    extends _$SignUpEventCopyWithImpl<$Res>
    implements $SignUpSetPasswordConfirmationCopyWith<$Res> {
  _$SignUpSetPasswordConfirmationCopyWithImpl(
      SignUpSetPasswordConfirmation _value,
      $Res Function(SignUpSetPasswordConfirmation) _then)
      : super(_value, (v) => _then(v as SignUpSetPasswordConfirmation));

  @override
  SignUpSetPasswordConfirmation get _value =>
      super._value as SignUpSetPasswordConfirmation;

  @override
  $Res call({
    Object? password = freezed,
  }) {
    return _then(SignUpSetPasswordConfirmation(
      password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
class _$SignUpSetPasswordConfirmation implements SignUpSetPasswordConfirmation {
  const _$SignUpSetPasswordConfirmation(this.password);

  @override
  final String password;

  @override
  String toString() {
    return 'SignUpEvent.setPasswordConfirmation(password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is SignUpSetPasswordConfirmation &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(password);

  @JsonKey(ignore: true)
  @override
  $SignUpSetPasswordConfirmationCopyWith<SignUpSetPasswordConfirmation>
      get copyWith => _$SignUpSetPasswordConfirmationCopyWithImpl<
          SignUpSetPasswordConfirmation>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email) setEmail,
    required TResult Function(String password) setPassword,
    required TResult Function(String password) setPasswordConfirmation,
  }) {
    return setPasswordConfirmation(password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email)? setEmail,
    TResult Function(String password)? setPassword,
    TResult Function(String password)? setPasswordConfirmation,
    required TResult orElse(),
  }) {
    if (setPasswordConfirmation != null) {
      return setPasswordConfirmation(password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignUpSetEmail value) setEmail,
    required TResult Function(SignUpSetPassword value) setPassword,
    required TResult Function(SignUpSetPasswordConfirmation value)
        setPasswordConfirmation,
  }) {
    return setPasswordConfirmation(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpSetEmail value)? setEmail,
    TResult Function(SignUpSetPassword value)? setPassword,
    TResult Function(SignUpSetPasswordConfirmation value)?
        setPasswordConfirmation,
    required TResult orElse(),
  }) {
    if (setPasswordConfirmation != null) {
      return setPasswordConfirmation(this);
    }
    return orElse();
  }
}

abstract class SignUpSetPasswordConfirmation implements SignUpEvent {
  const factory SignUpSetPasswordConfirmation(String password) =
      _$SignUpSetPasswordConfirmation;

  String get password => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SignUpSetPasswordConfirmationCopyWith<SignUpSetPasswordConfirmation>
      get copyWith => throw _privateConstructorUsedError;
}
