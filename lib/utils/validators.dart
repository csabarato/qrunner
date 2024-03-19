
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
