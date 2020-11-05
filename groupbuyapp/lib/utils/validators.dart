bool isNonNegativeNumeric(String s) {
  if(s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

bool isNonNegativeInteger(String s) {
  if (s == null) {
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
