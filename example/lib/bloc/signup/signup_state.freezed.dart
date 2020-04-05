// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'signup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

mixin _$SignUpState {
  String get email;
  String get password;
  String get confirmation;
  Map<SignUpFormField, List<String>> get errors;

  SignUpState copyWith(
      {String email,
      String password,
      String confirmation,
      Map<SignUpFormField, List<String>> errors});
}

class _$SignUpStateTearOff {
  const _$SignUpStateTearOff();

  _SignUpState call(
      {String email,
      String password,
      String confirmation,
      Map<SignUpFormField, List<String>> errors}) {
    return _SignUpState(
      email: email,
      password: password,
      confirmation: confirmation,
      errors: errors,
    );
  }
}

const $SignUpState = _$SignUpStateTearOff();

class _$_SignUpState implements _SignUpState {
  const _$_SignUpState(
      {this.email, this.password, this.confirmation, this.errors});

  @override
  final String email;
  @override
  final String password;
  @override
  final String confirmation;
  @override
  final Map<SignUpFormField, List<String>> errors;

  @override
  String toString() {
    return 'SignUpState(email: $email, password: $password, confirmation: $confirmation, errors: $errors)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SignUpState &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)) &&
            (identical(other.confirmation, confirmation) ||
                const DeepCollectionEquality()
                    .equals(other.confirmation, confirmation)) &&
            (identical(other.errors, errors) ||
                const DeepCollectionEquality().equals(other.errors, errors)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password) ^
      const DeepCollectionEquality().hash(confirmation) ^
      const DeepCollectionEquality().hash(errors);

  @override
  _$_SignUpState copyWith({
    Object email = freezed,
    Object password = freezed,
    Object confirmation = freezed,
    Object errors = freezed,
  }) {
    return _$_SignUpState(
      email: email == freezed ? this.email : email as String,
      password: password == freezed ? this.password : password as String,
      confirmation:
          confirmation == freezed ? this.confirmation : confirmation as String,
      errors: errors == freezed
          ? this.errors
          : errors as Map<SignUpFormField, List<String>>,
    );
  }
}

abstract class _SignUpState implements SignUpState {
  const factory _SignUpState(
      {String email,
      String password,
      String confirmation,
      Map<SignUpFormField, List<String>> errors}) = _$_SignUpState;

  @override
  String get email;
  @override
  String get password;
  @override
  String get confirmation;
  @override
  Map<SignUpFormField, List<String>> get errors;

  @override
  _SignUpState copyWith(
      {String email,
      String password,
      String confirmation,
      Map<SignUpFormField, List<String>> errors});
}
