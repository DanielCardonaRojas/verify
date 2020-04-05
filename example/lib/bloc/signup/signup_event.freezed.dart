// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'signup_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

mixin _$SignUpEvent {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result setEmail(String email),
    @required Result setPassword(String password),
    @required Result setPasswordConfirmation(String password),
  });

  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result setEmail(String email),
    Result setPassword(String password),
    Result setPasswordConfirmation(String password),
    @required Result orElse(),
  });

  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result setEmail(SignUpSetEmail value),
    @required Result setPassword(SignUpSetPassword value),
    @required
        Result setPasswordConfirmation(SignUpSetPasswordConfirmation value),
  });

  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result setEmail(SignUpSetEmail value),
    Result setPassword(SignUpSetPassword value),
    Result setPasswordConfirmation(SignUpSetPasswordConfirmation value),
    @required Result orElse(),
  });
}

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

const $SignUpEvent = _$SignUpEventTearOff();

class _$SignUpSetEmail implements SignUpSetEmail {
  const _$SignUpSetEmail(this.email) : assert(email != null);

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

  @override
  _$SignUpSetEmail copyWith({
    Object email = freezed,
  }) {
    return _$SignUpSetEmail(
      email == freezed ? this.email : email as String,
    );
  }

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result setEmail(String email),
    @required Result setPassword(String password),
    @required Result setPasswordConfirmation(String password),
  }) {
    assert(setEmail != null);
    assert(setPassword != null);
    assert(setPasswordConfirmation != null);
    return setEmail(email);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result setEmail(String email),
    Result setPassword(String password),
    Result setPasswordConfirmation(String password),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (setEmail != null) {
      return setEmail(email);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result setEmail(SignUpSetEmail value),
    @required Result setPassword(SignUpSetPassword value),
    @required
        Result setPasswordConfirmation(SignUpSetPasswordConfirmation value),
  }) {
    assert(setEmail != null);
    assert(setPassword != null);
    assert(setPasswordConfirmation != null);
    return setEmail(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result setEmail(SignUpSetEmail value),
    Result setPassword(SignUpSetPassword value),
    Result setPasswordConfirmation(SignUpSetPasswordConfirmation value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (setEmail != null) {
      return setEmail(this);
    }
    return orElse();
  }
}

abstract class SignUpSetEmail implements SignUpEvent {
  const factory SignUpSetEmail(String email) = _$SignUpSetEmail;

  String get email;

  SignUpSetEmail copyWith({String email});
}

class _$SignUpSetPassword implements SignUpSetPassword {
  const _$SignUpSetPassword(this.password) : assert(password != null);

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

  @override
  _$SignUpSetPassword copyWith({
    Object password = freezed,
  }) {
    return _$SignUpSetPassword(
      password == freezed ? this.password : password as String,
    );
  }

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result setEmail(String email),
    @required Result setPassword(String password),
    @required Result setPasswordConfirmation(String password),
  }) {
    assert(setEmail != null);
    assert(setPassword != null);
    assert(setPasswordConfirmation != null);
    return setPassword(password);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result setEmail(String email),
    Result setPassword(String password),
    Result setPasswordConfirmation(String password),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (setPassword != null) {
      return setPassword(password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result setEmail(SignUpSetEmail value),
    @required Result setPassword(SignUpSetPassword value),
    @required
        Result setPasswordConfirmation(SignUpSetPasswordConfirmation value),
  }) {
    assert(setEmail != null);
    assert(setPassword != null);
    assert(setPasswordConfirmation != null);
    return setPassword(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result setEmail(SignUpSetEmail value),
    Result setPassword(SignUpSetPassword value),
    Result setPasswordConfirmation(SignUpSetPasswordConfirmation value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (setPassword != null) {
      return setPassword(this);
    }
    return orElse();
  }
}

abstract class SignUpSetPassword implements SignUpEvent {
  const factory SignUpSetPassword(String password) = _$SignUpSetPassword;

  String get password;

  SignUpSetPassword copyWith({String password});
}

class _$SignUpSetPasswordConfirmation implements SignUpSetPasswordConfirmation {
  const _$SignUpSetPasswordConfirmation(this.password)
      : assert(password != null);

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

  @override
  _$SignUpSetPasswordConfirmation copyWith({
    Object password = freezed,
  }) {
    return _$SignUpSetPasswordConfirmation(
      password == freezed ? this.password : password as String,
    );
  }

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result setEmail(String email),
    @required Result setPassword(String password),
    @required Result setPasswordConfirmation(String password),
  }) {
    assert(setEmail != null);
    assert(setPassword != null);
    assert(setPasswordConfirmation != null);
    return setPasswordConfirmation(password);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result setEmail(String email),
    Result setPassword(String password),
    Result setPasswordConfirmation(String password),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (setPasswordConfirmation != null) {
      return setPasswordConfirmation(password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result setEmail(SignUpSetEmail value),
    @required Result setPassword(SignUpSetPassword value),
    @required
        Result setPasswordConfirmation(SignUpSetPasswordConfirmation value),
  }) {
    assert(setEmail != null);
    assert(setPassword != null);
    assert(setPasswordConfirmation != null);
    return setPasswordConfirmation(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result setEmail(SignUpSetEmail value),
    Result setPassword(SignUpSetPassword value),
    Result setPasswordConfirmation(SignUpSetPasswordConfirmation value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (setPasswordConfirmation != null) {
      return setPasswordConfirmation(this);
    }
    return orElse();
  }
}

abstract class SignUpSetPasswordConfirmation implements SignUpEvent {
  const factory SignUpSetPasswordConfirmation(String password) =
      _$SignUpSetPasswordConfirmation;

  String get password;

  SignUpSetPasswordConfirmation copyWith({String password});
}
