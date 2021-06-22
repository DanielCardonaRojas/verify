<p align="center">
<img src="https://github.com/DanielCardonaRojas/verify/raw/master/verify_logo.png" height="250px">
</p>

<h2 align="center">
  Validations made simple
</h2>

<p align="center">
<a href="https://travis-ci.org/github/DanielCardonaRojas/verify">
<img alt="Build Status" src="https://travis-ci.org/DanielCardonaRojas/verify.svg?branch=master">
</a>
 <a href="https://pub.dartlang.org/packages/verify">
    <img alt="Pub Package" src="https://img.shields.io/pub/v/verify.svg">
  </a>

  <a href="https://codecov.io/gh/DanielCardonaRojas/verify">
    <img alt="Codecov" src="https://codecov.io/gh/DanielCardonaRojas/verify/branch/master/graph/badge.svg">
  </a>

<a href="https://opensource.org/licenses/MIT">
<img alt="MIT License" src="https://img.shields.io/badge/License-MIT-blue.svg">
</a>

</p>

A fp inspired validation DSL. For Dart and Flutter projects.

## Requirements

The implementation of Verify relies heavily on dart extension methods, which are available
for Dart versions >= 2.6

## Features

- Completely extensible (create your own combinators, validator primitives, etc)
- Flexible Verify is an extension based API (There is not single class created its all pure functions)
- Customizable (Define you own error types) organize validators how ever you want
- Bloc friendly (See [examples](https://github.com/DanielCardonaRojas/verify/tree/master/example) for a concrete implementation)

## Usage

### Creating validators

A Validator is just a simple function alias:

```dart
// S is the input type and T the output type
typedef Validator<S, T> = Either<List<ValidationError>, T> Function(S subject);
```

So you can create your own validator by just specifying a function for example:

```dart
final Validator_<String> emailValidator = (String email) {
  return email.contains('@') ? Right(email) : Left(Error('must contain @'))
};
```

**Create simple validators from predicates**

A simpler way is to use some of the built in helpers.

```dart
final contains@ = Verify.property(
  (String email) => email.contains('@'),
    error: Error('email has to contain @')
    );

final notEmpty = Verify.property<String>((str) => !str.isEmpty, error: Error('field required'));
```

### Reuse validators

Use composition to build up more complex validators.

```dart
final Validator_<String> emailValidator = Verify.all([ contains@, notEmpty ])
```

### Validate and transform

Validators are also capable of transforming their input, so for instance we can do
parsing and validation in one go.

```dart
final Validator<String, int> intParsingValidator = (String str) => Right(int.parse(str));

final validator = intParsingValidator.onException((_) => Error('not an integer'));
```

### Field validations

Given a model, for instance a user:

```dart
class User extends Equatable {
  final String? phone;
  final String? mail;
  final int? age;

  const User(this.phone, this.mail, this.age);

  @override
  List<Object> get props => [phone ?? '', mail ?? '', age ?? ''];
}
```

Additional checks can be performed on the object and its fields by chaining a series of `check` 
and `checkField` methods.

```dart
final userValidator = Verify.empty<User>()
    .check((user) => !user.phone!.isEmpty, error: Error('phone empty'))
    .checkField((user) => user.mail!, emailValidator);

final someUser = User('','', 25);
final Either<List<Error>, User> validationResult = userValidator.verify(someUser);
```

> Note: The difference between check and checkField is that the later ignore the verification when the value is null,
> this will likely change in next version supporting null safety.


### Run a validator

Running a validator is a simple as passing in a parameter since its just a function.
To be a bit more eloquent a `verify` method is provided, this method is special because besides 
forwarding the argument to the calling validator it can also be used to filter the error list and 
have it cast to a specific error type. Just supply a specific type parameter.


```dart
final signUpValidation = Verify.subject<SignUpState>();
final errors = signUpValidation
    .verify<SignUpError>(newState); // Either<List<SignUpError>, SignUpState>
```
### Built in validators

Verify doesn't come with many built in validators, because they are so simple to create.

It does come with some regex shorthands.

```dart
    final validator = RegExp(r"(^\d+$)") // Validator<String, int>
        .matchOr(Error('not just digits'))
        .map((str) => int.tryParse(str));
```

### Form validation

Often times you will have modeled your error type similar to: 

```dart
enum FormField {
  email,
  password,
  passwordConfirmation,
}

class SignUpError extends ValidationError {
  final String message;
  final FormField field;

  SignUpError(this.message, {required this.field});

  @override
  String get errorDescription => message;
}
```

In these scenarios its convenient to be able to group errors by field.

The solution verify provides for this is: 

```dart
final validator = Verify.inOrder<SignUpFormState>([
  validateMail,
  validatePassword,
  validateConfirmation,
]);

final Map<FormField, SignUpError> errorMap = validator
    .verify<SignUpError>(someState)
    .groupedErrorsBy((error) => error.field);
```

## Sequencing

A slightly different API can be used to achieve the same results as the `inOrder` composition function.

```dart
final numberValidator = Verify.subject<int>()
  .then(Verify.property(
    (subject) => subject % 2 == 0,
    error: Error('not even'),
  ))
  .then(Verify.property(
    (subject) => subject >= 10,
    error: Error('single digit'),
  ));

final errors2 = numberValidator.errors(3); // yields 1 error
final errors = numberValidator.errors(4); // yields 1 error
```

This way you have quick access to errors segmented by field.


