import 'package:verify/verify.dart';

class User {
  final String phone;
  final String mail;
  final int age;

  User(this.phone, this.mail, this.age);
}

class Error extends ValidationError {
  final String message;

  Error(this.message);

  @override
  String get errorDescription => message;

  @override
  List<Object> get props => [message];
}

void main() {
  final containsAtSign = Verify.property(
    (String email) => email.contains('@'),
    error: Error('email has to contain @'),
  );

  final notEmpty = Verify.property<String>((str) => !str.isEmpty,
      error: Error('field required'));

  final Validator_<String> emailValidator =
      Verify.all([containsAtSign, notEmpty]);
  final userValidator = Verify.empty<User>()
      .check((user) => !user.phone.isEmpty, error: Error('phone empty'))
      .checkField((user) => user.mail, emailValidator);

  final someUser = User('', '', 25);
  final Either<List<Error>, User> validationResult =
      userValidator.verify(someUser);

  print(validationResult);
}
