class PricingTiers {
  PricingTiers({
    this.tierId,
    this.price,
  });

  PricingTiers.fromJson(dynamic json) {
    tierId = json['tierId'];
    price = json['price'];
  }

  num? tierId;
  num? price;

  PricingTiers copyWith({
    num? tierId,
    num? price,
  }) =>
      PricingTiers(
        tierId: tierId ?? this.tierId,
        price: price ?? this.price,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tierId'] = tierId;
    map['price'] = price;
    return map;
  }
}
