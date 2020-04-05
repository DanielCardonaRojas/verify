import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';
import 'package:verify_example/bloc/signup/signup_bloc.dart';
import 'package:verify_example/bloc/signup/signup_error.dart';

part 'signup_state.freezed.dart';

@freezed
abstract class SignUpState with _$SignUpState {
  const factory SignUpState(
      {String email,
      String password,
      String confirmation,
      Map<SignUpFormField, List<String>> errors}) = _SignUpState;

  factory SignUpState.initial() {
    return SignUpState(errors: {
      SignUpFormField.email: [],
      SignUpFormField.password: [],
      SignUpFormField.passwordConfirmation: [],
    });
  }
}
