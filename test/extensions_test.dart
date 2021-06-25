import 'package:test/test.dart';
import 'package:verify/verify.dart';
import './data/error.dart';
import './data/product_error.dart';

void main() {
  test('pairedErrorsBy returns empty Map when validation result is Right', () {
    final errorMap =
        Verify.valid(0).verify<Error>(1).singleErrorsBy((subject) => null);
    assert(errorMap.isEmpty);
  });
  test(
      'pairedErrorsBy returns non empty Map when validation result is a Left with non empty list of errors',
      () {
    final errorMap =
        Verify.error(ProductError('failed', field: ProductField.field1))
            .verify<ProductError>(1)
            .singleErrorsBy((error) => error.field);

    assert(errorMap.isNotEmpty);
    assert(errorMap[ProductField.field1] != null);
  });
}
