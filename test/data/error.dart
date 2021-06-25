import 'package:equatable/equatable.dart';
import 'package:verify/verify.dart';

enum ErrorCode {
  userMailEmpty,
  userMailFormat,
  userPhoneEmpty,
  userPhoneFormat,
}

class Error extends ValidationError with EquatableMixin {
  final String message;

  Error(this.message);

  factory Error.fromCode(ErrorCode code) {
    return Error(_mapCodeToString(code));
  }

  @override
  String get errorDescription => message;

  static String _mapCodeToString(ErrorCode code) {
    switch (code) {
      case ErrorCode.userMailEmpty:
        return 'mail cant be empty';
      case ErrorCode.userMailFormat:
        return 'bad mail format';
      case ErrorCode.userPhoneEmpty:
        return 'phone cant be empty';
      case ErrorCode.userPhoneFormat:
        return 'bad phone format';
      default:
        return '';
    }
  }

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}
