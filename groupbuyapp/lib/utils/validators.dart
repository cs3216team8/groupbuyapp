bool isNonNegativeNumeric(String s) {
  if(s == null || s.isEmpty) {
    return false;
  }

  double v = double.parse(s, (e) => null);
  return v != null && v >= 0;
}

bool isNonNegativeInteger(String s) {
  if (s == null || s.isEmpty) {
    return false;
  }
  return int.parse(s) != null;
}

bool isCurrencyNumberFormat(String s) {
  if (!isNonNegativeNumeric(s)) {
    return false;
  }
  double val = double.parse(s) * 100;
  if (val < 0) {
    return false;
  }
  return val.truncateToDouble() == val;
}

String phoneNumberValidator(String value) {
  Pattern pattern = r'^[0-9+\s]*$';
  RegExp regex = new RegExp(pattern);
  if (value == "") {
    return 'Please enter a phone number';
  } else if (!regex.hasMatch(value)) {
    return 'Please enter a valid phone number';
  } else {
    return null;
  }
}

String usernameValidator(String value) {
  if (value.isEmpty) {
    return 'Please enter your username';
  }
  if (value.length > 12) {
    return 'Username can not be longer than 12 characters';
  }
  return null;
}

String emailValidator(String value) {
  if (value.isEmpty) {
    return 'Please enter your email';
  }
  if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  return null;
}

String fullnameValidator(String value) {
  if (value.isEmpty) {
    return 'Please enter your full name';
  }
  return null;
}

String passwordValidator(String value) {
    if (value.isEmpty) {
      return '\n\nPlease enter password';
    }
    return null;
}