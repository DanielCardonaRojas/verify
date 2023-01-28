library signup_bloc;

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:verify_example/bloc/signup/signup_error.dart';
import 'package:verify_example/bloc/signup/signup_validation.dart';
import 'package:verify/verify.dart';

import './signup_event.dart';
import './signup_state.dart';

export './signup_event.dart';
export './signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpState.initial());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    print('processing event: $event');
    final newState = event.when(
      setEmail: (str) => state.copyWith(email: str),
      setPassword: (str) => state.copyWith(password: str),
      setPasswordConfirmation: (str) => state.copyWith(confirmation: str),
    );

    final errors = signUpValidation
        .verify<SignUpError>(newState)
        .errorsGroupedBy((error) => error.field)
        .messages;

    yield newState.copyWith(errors: errors);
  }
}
