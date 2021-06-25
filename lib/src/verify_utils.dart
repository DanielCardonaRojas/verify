part of 'verify.dart';

Validator<S> _verifyAll<S>(List<Validator<S>> verifications) {
  return (S s) {
    final list = verifications.map((v) => v(s)).toList();

    final List<dynamic> errors = [];

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
// ignore: unused_element
ValidatorT<S, T> _compose<S, T>(ValidatorT<S, T> lhs, ValidatorT<S, T> rhs) {
  return (S s) {
    final firstResult = lhs(s);
    final secondResult = rhs(s);
    final list = [firstResult, secondResult];

    final List<dynamic> errors = [];

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

ValidatorT<S, O> _join<S, T, O>(ValidatorT<S, T> lhs, ValidatorT<T, O> rhs) {
  return (S input) {
    final lhsOutput = lhs(input);

    final Either<List<dynamic>, O> result = lhsOutput.fold(
      (err) => Left(err),
      (value) => rhs(value),
    );

    return result;
  };
}

Validator<S> _ignoreWhen<S>(Predicate<S> condition, Validator<S> validator) {
  return (S input) => condition(input) ? Right(input) : validator(input);
}

Validator<S> _ignoreNull<S>(Validator<S> validator) {
  return _ignoreWhen((S input) => input == null, validator);
}

Validator<S?> _makeOptional<S>(Validator<S> validator) {
  return (S? subject) {
    if (subject == null) {
      return const Right(null);
    } else {
      return validator(subject);
    }
  };
}
