import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_verify/flutter_verify.dart';
import 'package:test/test.dart';

class User extends Equatable {
  final String phone;
  final String mail;
  final int age;

  User(this.phone, this.mail, this.age);

  @override
  List<Object> get props => [phone, mail, age];
}

void main() {
  final tUserGood = User('3116419582', 'd.cardona.rojas@gmail.com', 25);
  final tUserBad = User('31123123', 'd.cardona.rojas', 25);
  final tUserBadPhoneLength = 'phone numbers must be of length 11';
  final tUserBadEmail = 'bad email';
  final tUserBadPhoneEmpty = 'phone cant be empty';

// API1
  // final tPhoneValidationV1 = Verify<User>.property((user) {
  //   return user.phone.length == 11;
  // }, otherwise: tUserBadPhoneLength);

  // final tEmailValidation = Verify.onField((User user) => user.mail,
  //     VerifyString.contains('@', errorMessage: tUserBadEmail));

  test('Can validate subfield of model with checkProperty method', () {
    final user = User('', '1', 25);

    final userValidator = Verify.empty<String, User>()
        .checkProperty((user) => !user.phone.isEmpty,
            error: 'user phone cant be empty')
        .checkProperty((user) => !user.mail.isEmpty && user.mail.contains('@'),
            error: 'user mail cant be empty');

    final result = userValidator.verify(user);
    final errors = result.fold((errors) => errors.length, (_) => 0);
    assert(result.isLeft());
    assert(errors == 2);
  });

  test('Can validate subfield of model with other validator', () {
    final user = User('', '1', 25);

    final emptyStringValidator = Verify.property(
        (String string) => !string.isEmpty,
        otherwise: 'cant be empty');

    final emailValidator = Verify.property(
        (String email) => email.contains('@'),
        otherwise: 'email has to contain @');

    final userValidator = Verify.error<String, User>('user name not valid')
        .validatingField((user) => user.phone, emptyStringValidator)
        .validatingField((user) => user.mail, emailValidator);

    final result = userValidator.verify(user);
    final errors = result.fold((errors) => errors.length, (_) => 0);
    assert(result.isLeft());
    assert(errors == 3);
  });

  test('Can create and run an always succeding validator', () {
    final validator = Verify.valid(tUserGood);
    final result = validator.verify(tUserBad);
    assert(result.isRight());
  });

  test('Can run an error validator to any subject type', () {
    final errorValidator = Verify.error<String, User>('some errror');
    final result = errorValidator.verify(tUserGood);
    assert(result.isLeft());
  });

  test('Can transform output of validator', () {
    final stringValidator = Verify.valid<String, String>('123');
    final intValidator = stringValidator.map((value) => int.tryParse(value));
    final result =
        intValidator.verify('').fold((_) => 0, (parsedValue) => parsedValue);
    assert(result == 123);
  });

  test('Can create and run an always failing validator', () {
    final validator = Verify.error('some error');
    final result = validator.verify(tUserBad);
    assert(result.isLeft());
  });

  test('Can coerce error to any validator type', () {
    final errorValidator = Verify.error<String, User>('some errror');
    final result = errorValidator.verify(tUserGood);
    assert(result.isLeft());
  });

  test('Accumulates errors when running more than one failing validator', () {
    final errorValidator = Verify.error<String, User>('some errror');
    final errorValidator2 = Verify.error<String, User>('some errror');

    final validator = Verify.all([errorValidator, errorValidator2]);
    final result = validator.verify(tUserBad);

    expect(result, isA<Left>());
    final errorCount = result.fold((l) => l.length, (_) => 0);
    expect(errorCount, 2);
  });

  test('Validator error preserve the order they where added in', () {
    final firstErrorMsg = 'error1';
    final secondErrorMsg = 'error2';
    final errorValidator = Verify.error<String, User>(firstErrorMsg);
    final errorValidator2 = Verify.error<String, User>(secondErrorMsg);
    final validator = Verify.all([errorValidator, errorValidator2]);
    final result = validator.verify(tUserBad);
    final List<String> errorMessages = result.fold((l) => l, (_) => []);
    expect(errorMessages, [firstErrorMsg, secondErrorMsg]);
  });

  // test('Different Validator apis yield the same result', () {
  //   final tPhoneValidationV2 = Verify.onField(
  //       (User user) => user.phone,
  //       Verify.all([
  //         VerifyString.minLength(11, otherwise: tUserBadPhoneLength),
  //         VerifyString.notEmpty(errorMessage: tUserBadPhoneEmpty),
  //       ]));

  //   final Selector<User, String> phoneSelector = (user) => user.phone;
  //   final tPhoneValidationV3 = phoneSelector.ensureAll([
  //     VerifyString.minLength(11, otherwise: tUserBadPhoneLength),
  //     VerifyString.notEmpty(errorMessage: tUserBadPhoneEmpty),
  //   ]);

  //   final result1 = tPhoneValidationV2.verify(tUserBad);
  //   final result2 = tPhoneValidationV3.verify(tUserBad);

  //   final Function eq = const DeepCollectionEquality().equals;
  //   final result = eq(result1.toIterable(), result2.toIterable()) as bool;
  //   // assert(result);
  // });
}
