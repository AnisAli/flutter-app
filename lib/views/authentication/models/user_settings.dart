class UserSettings {
  UserSettings({
    this.autoAddProduct,
  });

  UserSettings.fromJson(dynamic json) {
    autoAddProduct = json['autoAddProduct'];
  }

  bool? autoAddProduct;

  UserSettings copyWith({
    bool? autoAddProduct,
  }) =>
      UserSettings(
        autoAddProduct: autoAddProduct ?? this.autoAddProduct,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['autoAddProduct'] = autoAddProduct;
    return map;
  }
}
