class ItemReportModel {
  int? productId;
  String? productName;
  String? description;
  int? transactionId;
  String? transactionNumber;
  String? transactionDate;
  int? transactionType;
  int? personId;
  String? personName;
  String? companyName;
  double? quantity;
  double? rate;
  double? subTotal;
  double? totalTax;
  double? amount;
  double? cost;
  double? cog;

  ItemReportModel(
      {this.productId,
      this.productName,
      this.description,
      this.transactionId,
      this.transactionNumber,
      this.transactionDate,
      this.transactionType,
      this.personId,
      this.personName,
      this.companyName,
      this.quantity,
      this.rate,
      this.subTotal,
      this.totalTax,
      this.amount,
      this.cost,
      this.cog});

  ItemReportModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    description = json['description'];
    transactionId = json['transactionId'];
    transactionNumber = json['transactionNumber'];
    transactionDate = json['transactionDate'];
    transactionType = json['transactionType'];
    personId = json['personId'];
    personName = json['personName'];
    companyName = json['companyName'];
    quantity = json['quantity'];
    rate = json['rate'];
    subTotal = json['subTotal'];
    totalTax = json['totalTax'];
    amount = json['amount'];
    cost = json['cost'];
    cog = json['cog'];
  }

  ItemReportModel.fromSaleJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    description = json['description'];
    transactionId = json['orderId'];
    transactionNumber = json['orderNumber'];
    transactionDate = json['orderDate'];
    transactionType = json['orderType'];
    personName = json['customerName'];
    companyName = json['companyName'];
    quantity = json['quantity'];
    rate = json['salePrice'];
    subTotal = json['subTotal'];
    totalTax = json['totalTax'];
    amount = json['amount'];
    cost = json['cost'];
    cog = json['cog'];
  }

  ItemReportModel.fromPurchaseJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    description = json['description'];
    transactionId = json['billId'];
    transactionNumber = json['billNumber'];
    transactionDate = json['billDate'];
    transactionType = json['billType'];
    personId = json['vendorId'];
    personName = json['vendorName'];
    companyName = json['companyName'];
    quantity = json['quantity'];
    rate = json['cost'];
    subTotal = json['subTotal'];
    totalTax = json['totalTax'];
    amount = json['amount'];
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['productName'] = productName;
    data['description'] = description;
    data['transactionId'] = transactionId;
    data['transactionNumber'] = transactionNumber;
    data['transactionDate'] = transactionDate;
    data['transactionType'] = transactionType;
    data['personId'] = personId;
    data['personName'] = personName;
    data['companyName'] = companyName;
    data['quantity'] = quantity;
    data['rate'] = rate;
    data['subTotal'] = subTotal;
    data['totalTax'] = totalTax;
    data['amount'] = amount;
    data['cost'] = cost;
    data['cog'] = cog;
    return data;
  }

  static List<ItemReportModel> itemListFromJson(
      List<dynamic> jsonList, String type) {
    return (type == 'sale')
        ? jsonList.map((json) => ItemReportModel.fromSaleJson(json)).toList()
        : jsonList
            .map((json) => ItemReportModel.fromPurchaseJson(json))
            .toList();
  }
}
