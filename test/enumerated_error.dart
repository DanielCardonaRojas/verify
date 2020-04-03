import 'package:verify/verify.dart';

abstract class FormError extends ValidationError {}

class Field1Error extends FormError {
  @override
  String get errorDescription => 'Field error 1';
}

class Field2Error extends FormError {
  @override
  String get errorDescription => 'Field error 2';
}
