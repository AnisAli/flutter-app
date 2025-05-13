part of extensions;

extension DateExtension on DateTime {
  static DateTime nowStartAt({int addDay = 0}) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + addDay);
  }

  String format({
    String pattern = 'yyyy/MM/dd HH:mm:ss',
    String locale = 'ja_JP',
  }) =>
      DateFormat(pattern, locale).format(this);

  String toDateFormat() => DateFormat.yMd().format(this);

  String toTimeFormat() => DateFormat.jm().format(this);

  DateTime toJst() => toUtc().add(const Duration(hours: 9));

  DateTime toYearMonthDay() {
    final date = DateTime(year, month, day);
    return date.add(date.timeZoneOffset).toUtc();
  }

  String get timelineLabel {
    final now = DateTime.now().toUtc();
    final self = toUtc();
    final difference = now.difference(self);
    final sec = difference.inSeconds;
    if (sec < 0) {
      return format(pattern: 'yyyy.M.d');
    }

    if (sec >= 60 * 60 * 24 * 30) {
      return format(pattern: 'yyyy.M.d');
    } else if (sec >= 60 * 60 * 24) {
      return '${difference.inDays.toString()} Recently';
    } else if (sec >= 60 * 60) {
      return '${difference.inHours.toString()} by the time';
    } else if (sec >= 60) {
      return '${difference.inMinutes.toString()} minute';
    } else {
      return '$sec Seconds Ago';
    }
  }

  // d1 > d2 => true
  // d1 <= d2 => false
  bool isGreater(DateTime d2) {
    final d1 = this;
    return d1.toUtc().isAfter(d2.toUtc());
  }

  DateTime setHour(
    int hour, [
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  ]) =>
      DateTime(
        year,
        month,
        day,
        hour,
        minute ?? this.minute,
        second ?? this.second,
        millisecond ?? this.millisecond,
        microsecond ?? this.microsecond,
      );

  DateTime get clone => DateTime.fromMicrosecondsSinceEpoch(
        microsecondsSinceEpoch,
        isUtc: isUtc,
      );

  DateTime get startOfDay => clone.setHour(0, 0, 0, 0, 0);

  DateTime get endOfDay => clone.setHour(23, 59, 59, 59, 59);

  /// https://stackoverflow.com/questions/62872349/dart-flutter-get-first-datetime-of-this-week
  DateTime get startOfWeek => subtract(Duration(days: weekday - 1)).startOfDay;

  DateTime get endOfWeek =>
      add(Duration(days: DateTime.daysPerWeek - weekday)).startOfDay;

  DateTime get startOfMonth => DateTime(year, month).startOfDay;

  DateTime get endOfMonth => DateTime(year, month + 1, 0).startOfDay;

  DateTime get nextMonth => DateTime(year, month + 1);

  DateTime get beforeDay => DateTime(year, month, day - 1).startOfDay;

  DateTime get nextDay => DateTime(year, month, day + 1).startOfDay;

  DateTime startAt({int addDay = 0}) => DateTime(year, month, day + addDay);

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameLocalDate(DateTime other) {
    final a = toLocal();
    final b = other.toLocal();
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool isSameMonthLocal(DateTime other) {
    final a = toLocal();
    final b = other.toLocal();
    return a.year == b.year && a.month == b.month;
  }

  int calculateAge() {
    return ((DateTime.now().difference(this).inDays) ~/ 365);
  }
}

extension DateTimeCompare on DateTime? {
  bool? isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isAfter(dateTime);
    }
    return null;
  }

  bool? isBeforeOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isBefore(dateTime);
    }
    return null;
  }

  bool? isBetween(
    DateTime fromDateTime,
    DateTime toDateTime,
  ) {
    final date = this;
    if (date != null) {
      final isAfter = date.isAfterOrEqualTo(fromDateTime) ?? false;
      final isBefore = date.isBeforeOrEqualTo(toDateTime) ?? false;
      return isAfter && isBefore;
    }
    return null;
  }
}

extension StringToDate on String {
  DateTime toDate() => DateTime.parse(this);

  DateTime toDateTime({String? format}) {
    DateFormat dateFormat = DateFormat(format ?? "yyyy-MM-dd HH:mm:ss");
    return dateFormat.parse(this);
  }
}
