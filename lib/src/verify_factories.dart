part of 'verify.dart';

/// Scope to access most validator facilities.
///
/// All the methods in this scope are static
extension Verify on ValidatorT {
  /// Creates an always succeeding validator
  ///
  /// Ignores input and always returns the provided value.
  static Validator<S> valid<S>(S subject) {
    return (_) => Right(subject);
  }

  /// Creates an always failing validator
  static Validator<S> error<S>(dynamic error) {
    return (_) => Left([error]);
  }

  /// Creates a validator that has yet to attach validation logic.
  static Validator<S> empty<S>() {
    return (S input) => Right(input);
  }

  /// Creates a validator that has yet to attach validation logic.
  static Validator<S> subject<S>() {
    return (S input) => Right(input);
  }

  /// Creates a validator that checks input is not null
  static Validator<S> notNull<S>(dynamic error) {
    return Verify.that<S>((s) => s != null, error: error);
  }

  /// Creates a validator from predicate
  static Validator<S> that<S>(Predicate<S> predicate,
      {required dynamic error}) {
    return (s) => predicate(s) ? Right(s) : Left([error]);
  }

  /// Creates a validator on S by applying a validator on a subfield of S.
  static Validator<S> at<S, T>(
    Selector<S, T> selector, {
    required Validator<T> validator,
  }) {
    return (S subject) {
      final field = selector(subject);
      return validator(field).fold((l) => Left(l), (_) => Right(subject));
    };
  }

  /// Creates a purely input mapping validator
  ///
  /// Lift a selector into the context of a Validator
  static ValidatorT<S, T> lift<S, T>(Selector<S, T> mapping) {
    return (S input) => Right(mapping(input));
  }

  /// Creates a new validator by merging a list of validators
  ///
  /// Composition is parallel (All validators are fed the same input)
  /// Returns sum of errors of all failing validator errors, or the input.
  /// Note: Transformations performed by the validators are discarded as composition is parallel.
  static Validator<S> all<S>(List<Validator<S>> verifications) {
    return _verifyAll<S>(verifications);
  }

  /// Creates a new validator by sequencing validators
  ///
  /// returns errors with first failing validator or succeeds if all validators succeed.
  static Validator<S> inOrder<S>(List<Validator<S>> validations) {
    return validations.reduce((lhs, rhs) => _join(lhs, rhs));
  }

  /// Creates a validator from a regular expression
  static Validator<String> fromRegex(RegExp regex, {required dynamic error}) {
    return Verify.empty<String>().flatMap((String input) {
      return regex.hasMatch(input)
          ? Verify.valid(input)
          : Verify.error<String>(error);
    });
  }
}
