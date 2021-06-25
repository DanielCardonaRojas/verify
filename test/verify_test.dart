import 'package:dartz/dartz.dart';
import 'package:verify/verify.dart';
import 'package:test/test.dart';
import 'package:collection/collection.dart';

import 'data/enumerated_error.dart';
import 'data/error.dart';
import 'data/product_error.dart';
import 'data/user.dart';

class ValidateString {
  static Validator<String> length(int length,
      {required ValidationError error}) {
    return Verify.that((s) => s.length == length, error: error);
  }
}

void main() {
  final listEquality = const ListEquality().equals;

  const tUserGood = User('3116419582', 'd.cardona.rojas@gmail.com', 25);
  const tUserBad = User('31123123', 'd.cardona.rojas', 25);

  test(
      'transforming output type of validator does not have effect on failing validator',
      () {
    final errorValidator = Verify.error<User>(Error('validation error'));
    final ValidatorT<User, int> transformedValidator =
        errorValidator.map((_) => 25);
    final result = transformedValidator.verify(tUserGood);
    final result2 = errorValidator.verify(tUserGood);

    final error1 = result.fold((e) => e.first, (_) => Error('1'));
    final error2 = result2.fold((e) => e.first, (_) => Error('2'));
    assert(result.isLeft());
    assert(error1 == error2);
  });

  test('flatmap does not collect both validator errors', () {
    const someUser = User('', '', null);
    final error1 = Error('validation error');
    final error2 = Error('age is required');
    final errorValidator = Verify.error<User>(error1);
    final ageNotNullValidator = Verify.notNull<int?>(error2);
    final validator =
        errorValidator.join((user) => ageNotNullValidator.verify(user.age));
    final result = validator.verify(someUser);
    final errors = result.fold((e) => e, (_) => [Error('')]);

    assert(result.isLeft());
    assert(errors.length == 1);
    assert(errors.first == error1);
  });

  test('a >>+= b yields errors of b when a succeeds but b fails', () {
    const someUser = User('', '', null);
    final error2 = Error('age is required');
    final userValidator = Verify.valid<User>(someUser);
    final ageNotNullValidator = Verify.notNull<int?>(error2);
    final validator =
        userValidator.join((user) => ageNotNullValidator.verify(user.age));
    final result = validator.verify(someUser);
    final errors = result.fold((e) => e, (_) => [Error('')]);

    assert(result.isLeft());
    assert(errors.length == 1);
    assert(errors.first == error2);
  });

  test('join only accumulates on error at a time', () {
    final numberValidator = Verify.subject<int>()
        .then(Verify.that(
          (subject) => subject % 2 == 0,
          error: Error('not even'),
        ))
        .then(Verify.that(
          (subject) => subject >= 10,
          error: Error('single digit'),
        ));

    final errors2 = numberValidator.errors(3);
    final errors = numberValidator.errors(4);

    // Since then is join and performs sequential verification we expect the first error
    // to emerge but no the second.
    assert(errors.length == 1);
    assert(errors2.length == 1);
    assert(numberValidator.errors(14).isEmpty);
  });

  test(
      'Validator<S,T> >>+= Validator<T, O> returns Validator<S,O> that combines both mappings',
      () {
    final countStringLength = Verify.lift((String str) => str.length);
    final greaterThenOne = Verify.lift((int count) => count > 1);
    final validator = countStringLength.join(greaterThenOne);
    final result = validator.verify('123').fold((_) => -1, (v) => v);
    assert(result == true);
  });

  test('Can validate subfield of model with checkProperty method', () {
    const user = User('', '1', 25);

    final userValidator = Verify.empty<User>()
        .check((user) => user.phone!.isNotEmpty,
            error: Error.fromCode(ErrorCode.userPhoneEmpty))
        .check((user) => user.mail!.isNotEmpty && user.mail!.contains('@'),
            error: Error.fromCode(ErrorCode.userMailFormat));

    final result = userValidator.verify(user);
    final errors = result.fold((errors) => errors.length, (_) => 0);
    assert(result.isLeft());
    assert(errors > 0);
  });

  test('Can validate subfield of model with other validator', () {
    const user = User('', '1', 25);

    final emptyStringValidator = Verify.that(
        (String string) => string.isNotEmpty,
        error: Error('string cant be empty'));

    final emailValidator = Verify.that((String email) => email.contains('@'),
        error: Error('email has to contain @'));

    final userValidator = Verify.error<User>(Error('user name not valid'))
        .checkField((user) => user.phone!, emptyStringValidator)
        .checkField((user) => user.mail!, emailValidator);

    final result = userValidator.verify(user);
    assert(result.isLeft());
  });

  test('Can create and run an always succeding validator', () {
    final validator = Verify.valid(tUserGood);
    final result = validator.verify(tUserBad);
    assert(result.isRight());
  });

  test('Can handle errors with onException combinator', () {
    final error = Error('not a proper int');
    final ValidatorT<String, int> intParsingValidator =
        (String str) => Right(int.parse(str));
    final validator = intParsingValidator.catching((_) => error);
    final result = validator.verify('12s');
    final resultError = result.fold((e) => e.first, (v) => Error(''));
    assert(resultError == error);
  });

  test('Can run an error validator to any subject type', () {
    final errorValidator = Verify.error<User>(Error('some errror'));
    final result = errorValidator.verify(tUserGood);
    assert(result.isLeft());
  });

  test('Can transform output of validator', () {
    final stringValidator = Verify.valid<String>('123');
    final intValidator = stringValidator.map((value) => int.tryParse(value));
    final result =
        intValidator.verify('').fold((_) => 0, (parsedValue) => parsedValue);
    assert(result == 123);
  });

  test('Can create and run an always failing validator', () {
    final validator = Verify.error(Error('some error'));
    final result = validator.verify(tUserBad);
    assert(result.isLeft());
  });

  test('Can coerce error to any validator type', () {
    final errorValidator = Verify.error<User>(Error('some errror'));
    final result = errorValidator.verify(tUserGood);
    assert(result.isLeft());
  });

  test('Accumulates errors when running more than one failing validator', () {
    final errorValidator = Verify.error<User>(Error('some errror'));
    final errorValidator2 = Verify.error<User>(Error('some errror'));

    final validator = Verify.all([errorValidator, errorValidator2]);
    final result = validator.verify(tUserBad);

    expect(result, isA<Left>());
    final errorCount = result.fold((l) => l.length, (_) => 0);
    expect(errorCount, 2);
  });

  test('Validator error preserve the order they where added in', () {
    final firstErrorMsg = Error('error1');
    final secondErrorMsg = Error('error2');
    final errorValidator = Verify.error<User>(firstErrorMsg);
    final errorValidator2 = Verify.error<User>(secondErrorMsg);
    final validator = Verify.all([errorValidator, errorValidator2]);
    final result = validator.verify(tUserBad);
    final List<ValidationError> errorMessages =
        result.fold((l) => l, (_) => []);
    expect(errorMessages, [firstErrorMsg, secondErrorMsg]);
  });

  test(
      'performing a failing check on a failing validator returns a single value error list',
      () {
    final parentError = Error('some errror');
    const tUser = User('', '', -1);
    final validator = Verify.error<User>(parentError)
        .check((user) => user.age! > 0, error: Error('age must be positive'));

    final result = validator.verify(tUser);
    final errorCount = result.fold((errors) => errors.length, (_) => 0);
    assert(errorCount == 1);
  });

  test(
      'performing a succeding check on a failing validator returns a single value error list',
      () {
    final parentError = Error('some errror');
    const tUser = User('', '', 10);
    final validator = Verify.error<User>(parentError)
        .check((user) => user.age! > 0, error: Error('age must be positive'));

    final result = validator.verify(tUser);
    final errorCount = result.fold((errors) => errors.length, (_) => 0);
    assert(errorCount == 1);
  });

  test(
      'performing a failing check on a failing validator returns the calling validator error',
      () {
    final parentError = Error('some errror');
    final nestedError = Error('myst be positive');
    const tUser = User('', '', -1);
    final validator = Verify.error<User>(parentError)
        .check((user) => user.age! > 0, error: nestedError);

    final result = validator.verify(tUser);
    final errors = result.fold((errors) => errors, (_) => []);
    assert(listEquality(errors, [parentError]));
  });
  test(
      'performing a failing checkField on a failing validator returns a single value error list',
      () {
    const tUser = User('', '', -1);
    final validator = Verify.error<User>(Error('some errror')).checkField(
        (user) => user.age, Verify.error(Error('age must be positive')));

    final result = validator.verify(tUser);
    final errorCount = result.fold((errors) => errors.length, (_) => 0);
    assert(errorCount == 1);
  });
  test(
      'nesting validator checkField on a failing validator returns the calling validator error',
      () {
    final parentError = Error('some errror');
    final nestedError = Error('myst be positive');
    const tUser = User('', '', -1);
    final validator = Verify.error<User>(parentError).checkField(
        (user) => user.age!,
        Verify.that((int age) => age > 0, error: nestedError));

    final result = validator.verify(tUser);
    final errors = result.fold((errors) => errors, (_) => []);
    assert(listEquality(errors, [parentError]));
  });

  test('fails on null', () {
    final tError = Error('cant be null');
    final dateValidation = Verify.notNull<DateTime?>(tError).check(
      (DateTime? date) {
        final duration = date!.difference(DateTime.now());
        return duration.inMinutes >= 2;
      },
      error: Error('Doesnt satisfy time constraints'),
    );

    final result = dateValidation.verify(null);
    final errors = result.fold((e) => e, (_) => []);
    assert(listEquality(errors, [tError]));
  });

  test('firstError filters through errors and returns first of type', () {
    final error1 = Verify.error<int>(Field1Error());
    final error2 = Verify.error<int>(Field1Error());
    final error3 = Verify.error<int>(Field2Error());

    final validator = Verify.all([
      error1,
      error2,
      error3,
    ]);

    final result = validator.verify<Field2Error>(9).firstError;
    assert(result != null);
    assert(result?.errorDescription == Field2Error().errorDescription);
  });

  test('Can have different typed errors', () {
    final error1 = Verify.error<int>(Field1Error());
    final error2 = Verify.error<int>('this is a string error');

    final validator = Verify.all([
      error1,
      error2,
    ]);

    final errors = validator.errors(0);
    assert(errors.length == 2);
  });

  test(
      'Can select errors of specific type in a result with different typed errors',
      () {
    final error1 = Verify.error<int>(Field1Error());
    final error2 = Verify.error<int>('this is a string error');

    final validator = Verify.all([
      error1,
      error2,
    ]);

    final errors = validator.errors<ValidationError>(0);
    assert(errors.length == 1);
  });
  test('verify can filter error list when a generic parameter supplied', () {
    final error1 = Verify.error<int>(Field1Error());
    final error2 = Verify.error<int>(Field1Error());
    final error3 = Verify.error<int>(Field2Error());

    final validator = Verify.all([
      error1,
      error2,
      error3,
    ]);

    final result = validator.verify<Field1Error>(9);
    final result2 = validator.verify(9);
    final errorCount1 = result.fold((errors) => errors.length, (_) => 0);
    final errorCount2 = result2.fold((errors) => errors.length, (_) => 0);
    assert(result.isLeft());
    assert(errorCount1 == 2);
    assert(errorCount1 < errorCount2);
  });

  test(
      'bypasses validator when chaining a ignoreWhen with a succeeding predicate',
      () {
    final parentError = Error('some errror');
    final validator = Verify.error<User>(parentError)
        .ignoreWhen((subject) => (subject.age ?? 0) > 100);

    final result = validator.verify(const User('phone', 'mail', 101));
    assert(result.isRight());
  });

  test('bypasses validator when chaining a ignoreNull', () {
    final parentError = Error('some errror');
    final validator = Verify.error<User?>(parentError).ignoreNull();
    final result = validator.verify(null);
    assert(result.isRight());
  });

  test('bypasses checkField when focused subfield is null', () {
    final errorValidator = Verify.error<String?>(Error('is null'));
    const tUser = User(null, null, 23);
    final validator =
        Verify.valid(tUser).checkField((user) => user.phone, errorValidator);
    final result = validator.verify(tUser);
    assert(result.isRight());
  });

  test('inOrder returns first encountered error', () {
    final error1 = Verify.error<int>(Field1Error());
    final error2 = Verify.error<int>(Field1Error());
    final valid1 = Verify.valid<int>(1);

    final validator = Verify.inOrder([
      valid1,
      error1,
      error2,
    ]);

    final result = validator.verify(9);
    final errorCount = result.fold((errors) => errors.length, (_) => 0);
    assert(result.isLeft());
    assert(errorCount == 1);
  });

  test('inOrder works on single element list', () {
    final valid1 = Verify.valid<int>(1);

    final validator = Verify.inOrder([
      valid1,
    ]);

    final result = validator.verify(9);
    assert(result.isRight());
    expect(result, const Right(1));
  });

  group('product form error validation', () {
    test('groups errors type field type', () {
      final field1Error1 = ProductError('error1', field: ProductField.field1);
      final field1Error2 = ProductError('error2', field: ProductField.field1);
      final field2Error1 = ProductError('error1', field: ProductField.field2);

      final validator = Verify.all<int>([
        Verify.error(field1Error1),
        Verify.error(field1Error2),
        Verify.error(field2Error1),
      ]);

      final errorMap = validator
          .verify<ProductError>(9)
          .errorsGroupedBy((error) => error.field);
      assert(errorMap.keys.length == 2);
      assert(errorMap[ProductField.field1]?.length == 2);
      assert(errorMap[ProductField.field2]?.length == 1);
    });
  });
}
