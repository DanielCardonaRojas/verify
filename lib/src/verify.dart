import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:verify/verify.dart';
export 'package:dartz/dartz.dart' show Either;

/// Base contract which all Validation errors should conform to.
abstract class ValidationError {
  String get errorDescription;
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
///
/// All the methods in this scope are static
extension Verify on Validator {
  /// Creates an always succeding validator
  ///
  /// Ignores input and always returns the provided value.
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

  /// Creates a validator that has yet to attach validation logic.
  static Validator_<S> subject<S>() {
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

  /// Creates a new validator by merging a list of validators
  ///
  /// Composition is parallel (All validators are fed the same input)
  /// Returns sum of errors of all failing validator errors, or the input.
  /// Note: Transformations performed by the validators are discarded as composition is parallel.
  static Validator_<S> all<S>(List<Validator_<S>> verifications) {
    return _verifyAll<S>(verifications);
  }

  /// Creates a new validator by sequencing validators
  ///
  /// returns errors with first failing validator or succeeds if all validators succeed.
  static Validator_<S> inOrder<S>(List<Validator_<S>> validations) {
    return validations.reduce((lhs, rhs) => _join(lhs, rhs));
  }
}

/// Extension for methods related to subfield validations.
extension VerifyProperties<S> on Validator_<S> {
  /// Creates a new validator that nests checks on an object field.
  ///
  /// If both the calling validator and the additional check fail, the
  /// error produced by the calling is returned.
  Validator_<S> check(Predicate<S> predicate,
      {@required ValidationError error}) {
    final Validator_<S> predicateValidator =
        (S s) => predicate(s) ? Right(s) : Left([error]);
    return _join(this, predicateValidator);
  }

  /// Creates a new validator by nesting the provided one.
  ///
  /// If both the calling validator and the additional check fail,
  /// the error produced by the calling is returned.
  /// Note: checkField is different from check in that it ignore the verification if
  /// the focused field is null. This is common when validating forms in which null represents
  /// a field which has not being visited.
  Validator_<S> checkField<F>(
      Selector<S, F> selector, Validator_<F> verification) {
    final bypassingValidation = _ignoreNull(verification);
    final Validator_<S> fieldValidator = (S s) {
      final focus = selector(s);
      final result = bypassingValidation(focus);
      return result.map((_) => s);
    };
    return _join(this, fieldValidator);
  }

  /// Ignore calling validator when the give predicate holds.
  Validator_<S> ignoreWhen(Predicate<S> condition) {
    return _ignoreWhen<S>(condition, this);
  }

  /// Ignore calling validator when input is null.
  Validator_<S> ignoreNull() {
    return _ignoreWhen((S s) => s == null, this);
  }
}

/// Utilities that can be called on a Validator
///
/// Scope for all instance methods
extension ValidatorUtils<S, T> on Validator<S, T> {
  /// Runs the validator on the supplied subject.
  ///
  /// When supplied a type parameter the error list will be filtered
  /// to all errors that have the given type.
  Either<List<ErrorType>, T> verify<ErrorType extends ValidationError>(
      S subject) {
    return this(subject).leftMap((errors) {
      final Iterable<ErrorType> filtered = errors.whereType();
      return filtered.toList();
    });
  }

  /// Runs the validator and returns a list of errors
  ///
  /// When supplied a type parameter the error list will be filtered
  /// to all errors that have the given type.
  /// This is handy when just error information is required.
  List<ErrorType> errors<ErrorType extends ValidationError>(S subject) {
    return this(subject).leftMap((errors) {
      final Iterable<ErrorType> filtered = errors.whereType();
      return filtered.toList();
    }).fold((l) => l, (r) => const []);
  }

  /// Returns the validated and transformed subject
  /// If validation of subject fails returns null
  T validated(S subject) {
    return this(subject).fold(
      (errors) {
        return null;
      },
      (s) => s,
    );
  }

  /// Transforms the ouput of the validator by running the provided function.
  /// Leaving the validation logic untouched.
  /// returns validator with coerced output.
  Validator<S, O> map<O>(Function1<T, O> transform) {
    return (S input) {
      final eitherErrorOrResult = this(input);
      return eitherErrorOrResult.map((value) {
        return transform(value);
      });
    };
  }

  /// Chains a validation to the output
  ///
  /// Equivalent to flatMap((_) => validator)
  Validator<S, O> join<O>(Validator<T, O> validator) {
    return _join(this, validator);
  }

  /// Chains a validation to the output
  ///
  /// Equivalent to join
  Validator<S, O> then<O>(Validator<T, O> validator) {
    return _join(this, validator);
  }

  /// Recieves a function that generates a validator and plumbs the output of the
  /// current to validator to the function.
  Validator<S, O> flatMap<O>(Validator<T, O> Function(T) process) {
    return (S input) {
      final Either<List<ValidationError>, T> lhsOutput = this(input);

      final Either<List<ValidationError>, O> result = lhsOutput.fold(
        (err) => Left(err),
        (T value) {
          final Validator<T, O> producedValidator = process(value);
          final result = producedValidator(value);
          return result;
        },
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

Validator_<S> _verifyAll<S>(List<Validator_<S>> verifications) {
  return (S s) {
    final list = verifications.map((v) => v(s)).toList();

    final List<ValidationError> errors = [];

    for (final item in list) {
      errors.addAll(item.fold((e) => e, (_) => []));
    }

    if (errors.isEmpty) {
      return Right(s);
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

Validator<S, O> _join<S, T, O>(Validator<S, T> lhs, Validator<T, O> rhs) {
  return (S input) {
    final Either<List<ValidationError>, T> lhsOutput = lhs(input);

    final Either<List<ValidationError>, O> result = lhsOutput.fold(
      (err) => Left(err),
      (value) => rhs(value),
    );

    return result;
  };
}

Validator_<S> _ignoreWhen<S>(Predicate<S> condition, Validator_<S> validator) {
  return (S input) => condition(input) ? Right(input) : validator(input);
}

Validator_<S> _ignoreNull<S>(Validator_<S> validator) {
  return _ignoreWhen((S input) => input == null, validator);
}

/// Extensions to facilitate manipulating validation results.
extension ValidationResult<T, E extends ValidationError> on Either<List<E>, T> {
  E get firstError {
    return fold((errors) => errors.first, (_) => null);
  }

  /// Returns a map of grouped validatiton error.
  ///
  /// The provided selector must be a the field in the provided error that uniquely
  /// identifies the corresponding form field.
  Map<K, List<E>> groupedErrorsBy<K>(Selector<E, K> tagSelector) {
    return fold((errors) {
      final Map<K, List<E>> map = {};

      for (final err in errors) {
        final tag = tagSelector(err);
        final list = map[tag];
        list?.add(err);
        map[tag] = list ?? [err];
      }
      return map;
    }, (_) => {});
  }
}

extension MapErrorsToString<K, E extends ValidationError> on Map<K, List<E>> {
  Map<K, List<String>> get messages {
    return map((key, errorsList) {
      final errorMessages =
          errorsList.map((error) => error.errorDescription).toList();
      return MapEntry(key, errorMessages);
    });
  }
}
