import 'package:email_validator/email_validator.dart';

String? validateEmail(String? value) {
  if (!EmailValidator.validate(value!)) {
    return 'Please enter a valid email!';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.length < 8) {
    return 'Password must contain at least 8 characters!';
  }
  return null;
}

String? validateTextField(String? value) {
  if (value == null || value.isEmpty) {
    return 'Field must not be empty';
  }
  return null;
}
