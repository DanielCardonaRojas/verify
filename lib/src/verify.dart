library verify;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
export 'package:equatable/equatable.dart' show Equatable;
export 'package:dartz/dartz.dart' show Either;

/// Base contract which all Validation errors should conform to.
abstract class ValidationError extends Equatable {
  String get errorDescription;

  @override
  bool get stringify => true;
}

/// A Validator is a function that can process input to
/// either yield a list of validation errors or act on its input.
typedef Validator<S, T> = Either<List<ValidationError>, T> Function(S subject);

/// A Validator that does not change its input type.
typedef Validator_<S> = Either<List<ValidationError>, S> Function(S subject);

typedef Predicate<S> = bool Function(S subject);

/// Selector is a function that selects a subfield of a type.
typedef Selector<S, F> = F Function(S subject);

/// Scope to access most validator facilities.
extension Verify on Validator {
  /// Creates an always succeding validator
  static Validator_<S> valid<S>(S subject) {
    return (_) => Right(subject);
  }

  /// Creates an always failing validator
  static Validator_<S> error<S>(ValidationError error) {
    return (_) => Left([error]);
  }

  /// Creates a validator that has yet to attach validation logic.
  static Validator_<S> empty<S>() {
    return (S input) => Right(input);
  }

  /// Creates a validator that checks input is not null
  static Validator_<S> notNull<S>(ValidationError error) {
    return Verify.property<S>((s) => s != null, error: error);
  }

  /// Creates a validator frmo predicate
  static Validator_<S> property<S>(Predicate<S> predicate,
      {@required ValidationError error}) {
    return (s) => predicate(s) ? Right(s) : Left([error]);
  }

  /// Creates a purely input mapping validator
  ///
  /// Lift a selector into the context of a Validator
  static Validator<S, T> lift<S, T>(Selector<S, T> mapping) {
    return (S input) => Right(mapping(input));
  }

  /// Creates a new validator by composing a list of validators
  ///
  /// Validation errors preserve the order of the validator list
  static Validator<S, T> all<S, T>(List<Validator<S, T>> verifications) {
    return _verifyAll<S, T>(verifications);
  }
}

/// Extension for methods related to subfield validations.
extension VerifyProperties<S> on Validator_<S> {
  Validator_<S> check(Predicate<S> predicate,
      {@required ValidationError error}) {
    return _compose(this, (S s) => predicate(s) ? Right(s) : Left([error]));
  }

  /// Creates a new validator that includes checks on an object field.
  Validator_<S> checkField<F>(
      Selector<S, F> selector, Validator_<F> verification) {
    final Validator_<S> fieldValidator = (S s) {
      final focus = selector(s);
      final result = verification(focus);
      return result.map((_) => s);
    };
    return _compose(this, fieldValidator);
  }
}

extension ValidatorUtils<S, T> on Validator<S, T> {
  /// Runs the validator and returns either a list of errors or the coerced input.
  Either<List<ValidationError>, T> verify(S subject) {
    return this(subject);
  }

  /// Transforms the input of the validator by running the provided function.
  /// Leaving the validation logic untouched.
  Validator<S, O> map<O>(Function1<T, O> transform) {
    return (S input) {
      final eitherErrorOrInput = this(input);
      return eitherErrorOrInput.map((value) {
        return transform(value);
      });
    };
  }

  /// Chains a validation to the output
  ///
  /// Equivalent to flatMap((_) => validator)
  Validator<S, O> join<O>(Validator<T, O> validator) {
    return (S input) {
      final Either<List<ValidationError>, T> lhsOutput = this(input);

      final Either<List<ValidationError>, O> result = lhsOutput.fold(
        (err) => Left(err),
        (value) => validator.verify(value),
      );

      return result;
    };
  }

  /// Recieves a function that generates a validator and plumbs the output of the
  /// current to validator to the function.
  Validator<S, O> flatMap<O>(Validator<T, O> Function(T) process) {
    return (S input) {
      final Either<List<ValidationError>, T> lhsOutput = this(input);

      final Either<List<ValidationError>, O> result = lhsOutput.fold(
        (err) => Left(err),
        (value) => process(value).verify(value),
      );

      return result;
    };
  }

  Validator<S, T> onException(Selector<Exception, ValidationError> handler) {
    return (S input) {
      try {
        return this(input);
      } catch (e, _) {
        return Left([handler(e as Exception)]);
      }
    };
  }
}

Validator<S, T> _verifyAll<S, T>(List<Validator<S, T>> verifications) {
  return (s) {
    final list = verifications.map((v) => v(s)).toList();

    final List<ValidationError> errors = [];

    for (final item in list) {
      errors.addAll(item.fold((e) => e, (_) => []));
    }

    if (errors.isEmpty) {
      return Right(s as T);
    } else {
      return Left(errors);
    }
  };
}

/// Composes to validators of matching types.
Validator<S, T> _compose<S, T>(Validator<S, T> lhs, Validator<S, T> rhs) {
  return (S s) {
    final firstResult = lhs(s);
    final secondResult = rhs(s);
    final list = [firstResult, secondResult];

    final List<ValidationError> errors = [];

    for (final item in list) {
      errors.addAll(item.fold((e) => e, (_) => []));
    }
    if (errors.isEmpty) {
      return Right(s as T);
    } else {
      return Left(errors);
    }
  };
}