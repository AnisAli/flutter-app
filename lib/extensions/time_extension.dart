part of extensions;

extension StringToTime on String {
  TimeOfDay stringToTimeOfDay() {
    final format = DateFormat.jm();
    return TimeOfDay.fromDateTime(format.parse(this));
  }
}

extension TimeConversions on TimeOfDay {
  DateTime timeToDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  String timeToString() {
    final timeFormat = DateFormat.jm();
    return timeFormat.format(timeToDateTime());
  }
}
