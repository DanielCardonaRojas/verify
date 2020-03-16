library flutter_verify;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ValidationError extends Equatable {
  String get errorDescription;
}

typedef Validator<S, T> = Either<List<ValidationError>, T> Function(S subject);
typedef Validator_<S> = Either<List<ValidationError>, S> Function(S subject);
typedef Predicate<S> = bool Function(S subject);
typedef Selector<S, F> = F Function(S subject);

extension Verify on Validator {
  static Validator_<S> valid<S>(S subject) {
    return (_) => Right(subject);
  }

  static Validator_<S> error<S>(ValidationError error) {
    return (_) => Left([error]);
  }

  static Validator_<S> empty<S>() {
    return (_) => Left([]);
  }

  static Validator_<S> property<S>(Predicate<S> predicate,
      {@required ValidationError error}) {
    return (s) => predicate(s) ? Right(s) : Left([error]);
  }

  static Validator<S, T> all<S, T>(List<Validator<S, T>> verifications) {
    return verifyAll<S, T>(verifications);
  }
}

extension VerifyProperties<E, S> on Validator_<S> {
  Validator_<S> checkProperty(Predicate<S> predicate,
      {@required ValidationError error}) {
    final Validator_<S> validator =
        (s) => predicate(s) ? Right(s) : Left([error]);
    return add(this, validator);
  }

  Validator_<S> validatingField<F>(
      Selector<S, F> selector, Validator_<F> verification) {
    final Validator_<S> fieldValidator = (S s) {
      final focus = selector(s);
      final result = verification(focus);
      return result.map((_) => s);
    };
    return add(this, fieldValidator);
  }
}

extension ValidatorUtils<S, T> on Validator<S, T> {
  Either<List<ValidationError>, T> verify(S subject) {
    return this(subject);
  }

  Validator<S, O> map<O>(Function1<T, O> transform) {
    return (S input) {
      final eitherErrorOrInput = this(input);
      return eitherErrorOrInput.map((value) {
        return transform(value);
      });
    };
  }
}

Validator<S, T> verifyAll<S, T>(List<Validator<S, T>> verifications) {
  return (s) {
    final list = verifications.map((v) => v(s)).toList();

    final errors = List<ValidationError>();

    for (final item in list) {
      errors.addAll(item.fold((e) => e, (_) => List<ValidationError>()));
    }

    if (errors.isEmpty) {
      return Right(s as T);
    } else {
      return Left(errors);
    }
  };
}

Validator<S, T> add<S, T>(Validator<S, T> lhs, Validator<S, T> rhs) {
  return (S s) {
    final firstResult = lhs(s);
    final secondResult = rhs(s);
    final list = [firstResult, secondResult];

    final errors = List<ValidationError>();

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
