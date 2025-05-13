part of extensions;

extension StringConversions on String {
  int toInt() => int.parse(this);
  double toDouble() => double.parse(this);

  bool isNewLine() => '\n' == substring(length - 1);
  bool get isUrl => RegExp(r'https?://[a-zA-Z0-9\-%_/=&?.]+').hasMatch(this);
  bool get isId => RegExp(r'[a-zA-Z0-9\-%_/=&?.]+').hasMatch(this);

  String get capitalizeFirstLetter =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';

  String get capitalizeFirstOfEach => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.capitalizeFirstLetter)
      .join(" ");

  String removeMaskFromPhoneNumber() {
    return length > 10
        ? substring(2, length).replaceAll(RegExp(r'[^0-9]'), '')
        : this;
  }

  String formatPhoneNumber({bool addCountryCode = false}) {
    return "${addCountryCode ? "+1" : ""} ${replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'), (Match m) => "(${m[1]}) ${m[2]}-${m[3]}")}";
  }

  T stringToEnum<T>({required Iterable<T> values, T Function()? orElse}) {
    return values.firstWhere(
      (element) =>
          element != null &&
          toLowerCase() == describeEnum(element).toLowerCase(),
      orElse: orElse,
    );
  }
}
