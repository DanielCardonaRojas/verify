import 'package:test/test.dart';
import 'package:verify/verify.dart';

class Error extends ValidationError {
  final String message;

  Error(this.message);

  @override
  String get errorDescription => message;

  @override
  List<Object> get props => [message];
}

void main() {
  test('Regex validator returns given error when no matches are found', () {
    final allDigits = RegExp(r"(^\d+$)");
    final error = Error('not just digits');
    final validator = allDigits.matchOr(error);
    final result = validator.verify('12g');
    assert(result.isLeft());
  });

  test('All digits Regex validator parses int correctly', () {
    final validator = RegExp(r"(^\d+$)")
        .matchOr(Error('not just digits'))
        .map((str) => int.tryParse(str));

    final result = validator.verify('123');
    assert(result.isRight());
  });

  test('Regex validator succeeds with simple regex', () {
    final oneOrMoreWords = RegExp(r"(\w+)");
    final validator =
        oneOrMoreWords.matchOr(Error('does not contain one or more words'));

    final result1 = validator.verify('one two three');
    final result2 = validator.verify('');

    assert(result1.isRight());
    assert(result2.isLeft());
  });
}
