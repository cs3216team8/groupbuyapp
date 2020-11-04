String getTimeDifString(Duration timeDiff) {
  String time;
  if (timeDiff.inDays == 0) {
    if (timeDiff.isNegative) {
      time = (-1 * timeDiff.inHours).toString() + " hour(s) ago";
    }

    else {
      time = timeDiff.inHours.toString() + " hour(s) left";
    }
  } else {
    if (timeDiff.isNegative) {
      time = (-1 * timeDiff.inDays).toString() + " day(s) ago";
    }
    else {
      time = timeDiff.inDays.toString() + " day(s) left";
    }
  }

  return time;
}
