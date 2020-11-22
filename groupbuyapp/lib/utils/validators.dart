bool isNonNegativeNumeric(String s) {
  if(s == null || s.isEmpty) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
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