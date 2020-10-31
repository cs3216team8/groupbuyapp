String getTimeDifString(Duration timeDiff) {
  String time;
  if (timeDiff.inDays == 0) {
    time = timeDiff.inHours.toString() + " hours";
  } else {
    time = timeDiff.inDays.toString() + " days";
  }
  return time;
}
