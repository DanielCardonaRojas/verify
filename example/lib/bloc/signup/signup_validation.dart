import 'package:verify/verify.dart';
import 'package:verify_example/bloc/signup/signup_bloc.dart';
import 'package:verify_example/bloc/signup/signup_error.dart';

final Validator_<SignUpState> signUpValidation = Verify.all<SignUpState>([
  Verify.subject<SignUpState>().checkField(
      (state) => state.password,
      Verify.property<String?>((s) => s != null && s.length > 4,
          error: SignUpError(
            field: SignUpFormField.password,
            message: 'incorrect length',
          ))),
  Verify.subject<SignUpState>().checkField(
      (state) => state.email,
      Verify.property<String?>((s) => s?.contains('@') ?? false,
          error: SignUpError(
            field: SignUpFormField.email,
            message: 'invalid format',
          ))),
  Verify.property((SignUpState state) => state.confirmation == state.password,
      error: SignUpError(
        field: SignUpFormField.passwordConfirmation,
        message: 'not match',
      )).ignoreWhen((state) => state.confirmation == null),
]);
