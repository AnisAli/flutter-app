class OrderHistoryModel {
  int? productId;
  double? price;
  double? suggestedRetailPrice;
  String? transactionNumber;
  double? cost;
  double? quantity;
  bool? isTaxable;
  double? taxAmount;
  String? orderDate;

  OrderHistoryModel(
      {this.productId,
      this.price,
      this.suggestedRetailPrice,
      this.transactionNumber,
      this.cost,
      this.quantity,
      this.isTaxable,
      this.taxAmount,
      this.orderDate});

  OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    price = json['price'];
    suggestedRetailPrice = json['suggestedRetailPrice'];
    transactionNumber = json['transactionNumber'];
    cost = json['cost'];
    quantity = json['quantity'];
    isTaxable = json['isTaxable'];
    taxAmount = json['taxAmount'];
    orderDate = json['orderDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['price'] = price;
    data['suggestedRetailPrice'] = suggestedRetailPrice;
    data['transactionNumber'] = transactionNumber;
    data['cost'] = cost;
    data['quantity'] = quantity;
    data['isTaxable'] = isTaxable;
    data['taxAmount'] = taxAmount;
    data['orderDate'] = orderDate;
    return data;
  }
}
