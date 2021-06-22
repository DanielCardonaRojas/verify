import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_event.freezed.dart';

@freezed
class SignUpEvent with _$SignUpEvent {
  const factory SignUpEvent.setEmail(String email) = SignUpSetEmail;
  const factory SignUpEvent.setPassword(String password) = SignUpSetPassword;
  const factory SignUpEvent.setPasswordConfirmation(String password) =
      SignUpSetPasswordConfirmation;
}
