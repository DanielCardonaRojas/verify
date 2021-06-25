import 'package:dartz/dartz.dart';

/// A Validator is a function that can process input to
/// either yield a list of validation errors or act on its input.
typedef ValidatorT<S, T> = Either<List<dynamic>, T> Function(S subject);

/// A Validator that does not change its input type.
typedef Validator<S> = Either<List<dynamic>, S> Function(S subject);

/// A predicate type alias acting on the subject of a validator
typedef Predicate<S> = bool Function(S subject);

/// Selector is a function that selects a subfield of a type.
typedef Selector<S, F> = F Function(S subject);

/// Base contract which all Validation errors should conform to.
abstract class ValidationError {
  /// The error message associated with the implementing type
  String get errorDescription;
}
