import 'package:verify/verify.dart';

extension VerifyRegExp on RegExp {
  Validator_<String> matchOr(ValidationError error) {
    return Verify.empty<String>().flatMap((String input) {
      return hasMatch(input)
          ? Verify.valid(input)
          : Verify.error<String>(error);
    });
  }
}
