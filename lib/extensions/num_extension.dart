part of extensions;

extension NumExtension on num {
  String get formatComma => NumberFormat().format(this);

  String formatPrice() {
    String priceUnit = '\$';
    return '$priceUnit${toStringAsFixed(2)}';
  }
}
