import 'package:meta/meta.dart';
import 'package:verify/verify.dart';

enum SignUpFormField {
  email,
  password,
  passwordConfirmation,
}

class SignUpError implements ValidationError {
  final SignUpFormField field;
  final String message;

  SignUpError({@required this.field, @required this.message});

  @override
  String get errorDescription => message;
}
