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

   <a href="https://opensource.org/licenses/MIT">
    <img alt="MIT License" src="https://img.shields.io/badge/License-MIT-blue.svg">
  </a>
</p>

A fp inspired validation DSL. For Dart and Flutter projects.

## Requirements

The implementation of Verify relies heavily on dart extension methods, which are available
for Dart versions >= 2.6

## Features

- Completely extensible (create your own combinators, validator primatives, etc)
- Flexible Verify is an extension based API (There is not single class created its all pure functions)
- Customizable (Define you own error types) organize validators how ever you want
- Plays well with bloc

## Usage

### Creating validators

A Validator is just a simple function alias: 

```dart
typedef Validator<S, T> = Either<List<ValidationError>, T> Function(S subject);
```

So you can create your own validator by just specifying a function for exmple: 

```dart
final Validator_<String> emailValidator = (String email) {
  return email.contains('@') ? Right(email) : Left(Error('must contain @'))
}; 
```

**Create simple validators from predicates**

A simpler way is to use some of the built it helpers.

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
  final String phone;
  final String mail;
  final int age;

  User(this.phone, this.mail, this.age);

  @override
  List<Object> get props => [phone, mail, age];
}
```

Additional checks can be performed on the object and its fields using `check` and `checkField`

```dart
final userValidator = Verify.empty<User>()
    .check((user) => !user.phone.isEmpty, error: Error('phone empty'))
    .checkField((user) => user.mail, emailValidator);

final someUser = User('','', 25);
final Either<List<Error>, User> validationResult = userValidator.verify(someUser);
```
