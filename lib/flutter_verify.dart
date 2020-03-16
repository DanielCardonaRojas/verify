library flutter_verify;

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

typedef Validator<E, S, T> = Either<List<E>, T> Function(S subject);
typedef Validator_<E, S> = Either<List<E>, S> Function(S subject);
typedef Predicate<S> = bool Function(S subject);
typedef Selector<S, F> = F Function(S subject);

extension Verify on Validator {
  static Validator_<E, S> valid<E, S>(S subject) {
    return (_) => Right(subject);
  }

  static Validator_<E, S> error<E, S>(E error) {
    return (_) => Left([error]);
  }

  static Validator_<E, S> empty<E, S>() {
    return (_) => Left([]);
  }

  static Validator_<E, S> property<E, S>(Predicate<S> predicate,
      {@required E otherwise}) {
    return (s) => predicate(s) ? Right(s) : Left([otherwise]);
  }

  static Validator<E, S, T> all<E, S, T>(
      List<Validator<E, S, T>> verifications) {
    return verifyAll<E, S, T>(verifications);
  }
}

extension VerifyProperties<E, S> on Validator_<E, S> {
  Validator_<E, S> checkProperty(Predicate<S> predicate, {@required E error}) {
    final Validator_<E, S> validator =
        (s) => predicate(s) ? Right(s) : Left([error]);
    return add(this, validator);
  }

  Validator_<E, S> validatingField<F>(
      Selector<S, F> selector, Validator_<E, F> verification) {
    final Validator_<E, S> fieldValidator = (S s) {
      final focus = selector(s);
      final result = verification(focus);
      return result.map((_) => s);
    };
    return add(this, fieldValidator);
  }
}

extension ValidatorUtils<E, S, T> on Validator<E, S, T> {
  Either<List<E>, T> verify(S subject) {
    return this(subject);
  }

  Validator<E, S, O> map<O>(Function1<T, O> transform) {
    return (S input) {
      final eitherErrorOrInput = this(input);
      return eitherErrorOrInput.map((value) {
        return transform(value);
      });
    };
  }
}

Validator<E, S, T> verifyAll<E, S, T>(List<Validator<E, S, T>> verifications) {
  return (s) {
    final list = verifications.map((v) => v(s)).toList();

    final errors = List<E>();

    for (final item in list) {
      errors.addAll(item.fold((List<E> e) => e, (_) => List<E>()));
    }

    if (errors.isEmpty) {
      return Right(s as T);
    } else {
      return Left(errors);
    }
  };
}

Validator<E, S, T> add<E, S, T>(
    Validator<E, S, T> lhs, Validator<E, S, T> rhs) {
  return (S s) {
    final firstResult = lhs(s);
    final secondResult = rhs(s);
    final list = [firstResult, secondResult];

    final errors = List<E>();

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
