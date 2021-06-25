import 'package:dartz/dartz.dart';
import 'package:verify/verify.dart';

import 'base_types.dart';
export 'package:dartz/dartz.dart' show Either;

part 'verify_utils.dart';
part 'verify_factories.dart';

/// Extension for methods related to subfield validations.
extension VerifyProperties<S> on Validator<S> {
  /// Creates a new validator that nests checks on an object field.
  ///
  /// If both the calling validator and the additional check fail, the
  /// error produced by the calling is returned.
  Validator<S> check(Predicate<S> predicate, {required dynamic error}) {
    final Validator<S> predicateValidator =
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
  Validator<S> checkField<F>(
      Selector<S, F?> selector, Validator<F> verification) {
    final bypassingValidation = _makeOptional(verification);
    final Validator<S> fieldValidator = (S s) {
      final focus = selector(s);
      final result = bypassingValidation(focus);
      return result.map((_) => s);
    };
    return _join(this, fieldValidator);
  }

  /// Ignore calling validator when the give predicate holds.
  Validator<S> ignoreWhen(Predicate<S> condition) {
    return _ignoreWhen<S>(condition, this);
  }

  /// Ignore calling validator when input is null.
  Validator<S> ignoreNull() {
    return _ignoreNull(this);
  }
}

/// Utilities that can be called on a Validator
///
/// Scope for all instance methods
extension ValidatorUtils<S, T> on ValidatorT<S, T> {
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
  List<ErrorType> errors<ErrorType>(S subject) {
    return this(subject).leftMap((errors) {
      final Iterable<ErrorType> filtered = errors.whereType();
      return filtered.toList();
    }).fold((l) => l, (r) => const []);
  }

  /// Returns the validated and transformed subject
  /// If validation of subject fails returns null
  T? validated(S subject) {
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
  ValidatorT<S, O> map<O>(Function1<T, O> transform) {
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
  ValidatorT<S, O> join<O>(ValidatorT<T, O> validator) {
    return _join(this, validator);
  }

  /// Chains a validation to the output
  ///
  /// Equivalent to join
  ValidatorT<S, O> then<O>(ValidatorT<T, O> validator) {
    return _join(this, validator);
  }

  /// Recieves a function that generates a validator and plumbs the output of the
  /// current to validator to the function.
  ValidatorT<S, O> flatMap<O>(ValidatorT<T, O> Function(T) process) {
    return (S input) {
      final lhsOutput = this(input);

      final Either<List<dynamic>, O> result = lhsOutput.fold(
        (err) => Left(err),
        (T value) {
          final ValidatorT<T, O> producedValidator = process(value);
          final result = producedValidator(value);
          return result;
        },
      );

      return result;
    };
  }

  /// Creates a new validator from the caller that will catch an errors
  /// when evaluating the validating function.
  ValidatorT<S, T> catching([Selector<Exception, ValidationError>? handler]) {
    return (S input) {
      try {
        return this(input);
      } catch (e, _) {
        return Left([handler?.call(e as Exception) ?? e]);
      }
    };
  }
}
