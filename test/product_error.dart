import 'package:meta/meta.dart';
import 'package:verify/verify.dart';

enum ProductField {
  field1,
  field2,
  field3,
}

class ProductError extends ValidationError {
  final String message;
  final ProductField field;

  ProductError(this.message, {@required this.field});

  @override
  String get errorDescription => message;
}
