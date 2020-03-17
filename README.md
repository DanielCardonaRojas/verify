<p align="center">
<img src="verify_logo.png" height="250px">
</p>

<p align="center">
<a href="https://travis-ci.com/DanielCardonaRojas/flutter_verify">
<img alt="Build Status" src="https://travis-ci.org/DanielCardonaRojas/flutter_verify.svg?branch=master">
</a>
</p>

A fp inspired validation DSL. For dart and flutter projects.

# Requirements

The implementation of Verify relies on heavily on dart extension methods, which are available
for Dart versions >= 2.6

## Features

- Completely extensible (create your own combinators, validator primatives, etc)
- Flexible Verify is an extension based API (There is not single class created its all pure functions)
- Customizable (Define you own error types) organize validators how ever you want
- Plays well with bloc

## Examples

**Create simple validators from predicates**

```dart
    final contains@ = Verify.property(
      (String email) => email.contains('@'),
        error: Error('email has to contain @')
        );

    final notEmpty = Verify.propery<String>((str) => !str.isEmpty, error: Error('field required'));
```

**Reuse validators**

```dart
final Validator_<String> emailValidator = Verify.all([ contains@, notEmpty ])

```

**Validate a model correctness**

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

Create some validations on its fields

```dart
final userValidator = Verify.empty<User>()
    .checkProperty((user) => !user.phone.isEmpty, error: Error('phone empty'))
    .validatingField((user) => user.mail, emailValidator);

final someUser = User('','', 25);
final Either<List<Error>, User> validationResult = userValidator.verify(someUser);
```

**Organize validators**

Here is one approach to organize validations for specific type

```dart
class ValidateString {
  static Validator_<String> length(int length,
      {@required ValidationError error}) {
    return Verify.property((s) => s.length == length, error: error);
  }
}
```
