import 'package:dartz/dartz.dart';

import 'base_types.dart';

/// Extensions to facilitate manipulating validation results.
extension ValidationResult<T, E extends ValidationError> on Either<List<E>, T> {
  /// Gets the first error according to the composition sequence used
  /// creating of calling validation result
  E? get firstError {
    return fold((errors) => errors.first, (_) => null);
  }

  /// Returns a map of grouped validatiton errors keyed by a formfield type.
  ///
  /// The provided selector must be a the field in the provided error that uniquely
  /// identifies the corresponding form field.
  Map<K, List<E>> errorsGroupedBy<K>(Selector<E, K> tagSelector) {
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

  /// Returns a map of formfield, error key value pairs.
  ///
  /// The provided selector must be a the field in the provided error type that uniquely
  /// identifies the corresponding form field.
  Map<K, String> singleErrorsBy<K>(Selector<E, K> tagSelector) {
    return fold((errors) {
      final Map<K, String> map = {};

      for (final err in errors) {
        final tag = tagSelector(err);
        if (map[tag] == null) {
          map[tag] = err.errorDescription;
        } else {
          continue;
        }
      }
      return map;
    }, (_) => {});
  }
}
