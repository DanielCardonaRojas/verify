**Organize validators**

Here is one approach to organize validations for specific type

```dart
class ValidateString {
  static Validator_<String> length(int length,
      {@required ValidationError error}) {
    return Verify.property((s) => s.length == length, error: error);
  }
}
```