class ReportModel {
  int? customerId;
  String? customerName;
  String? customerCompanyName;
  double? quantity;
  double? subTotal;
  double? totalTax;
  double? netTotal;
  double? cogs;
  double? discountValue;
  double? gain;
  String? date;
  String? item;
  String? description;
  String? orderNumber;
  double? salePrice;
  double? amount;

  ReportModel({
    this.customerId,
    this.customerName,
    this.customerCompanyName,
    this.quantity,
    this.subTotal,
    this.totalTax,
    this.netTotal,
    this.cogs,
    this.discountValue,
    this.gain,
    this.date,
    this.item,
    this.description,
    this.orderNumber,
    this.salePrice,
    this.amount,
  });

  factory ReportModel.fromSalesByCustomer(Map<String, dynamic> json) {
    return ReportModel(
      customerName: json['customerName'] ?? '',
      quantity: json['quantity'] ?? 0.0,
      subTotal: json['subTotal'] ?? 0.0,
      cogs: json['cogs'] ?? 0.0,
      netTotal: json['netTotal'] ?? 0.0,
      gain: (json['netTotal'] / json['quantity']) ?? 0.0,
    );
  }

  factory ReportModel.fromSalesByItem(Map<String, dynamic> json) {
    return ReportModel(
      item: json['productName'] ?? json['description'],
      quantity: json['quantity'] ?? 0.0,
      subTotal: json['subTotal'] ?? 0.0,
      cogs: json['cogs'] ?? 0.0,
      netTotal: (json['subTotal'] - json['cogs']) ?? 0.0,
      gain: ((json['subTotal'] - json['cogs']) / json['quantity']) ?? 0.0,
    );
  }

  factory ReportModel.fromSalesByIndividualItem(Map<String, dynamic> json) {
    return ReportModel(
      customerName: json['customerName'] ?? '',
      quantity: json['quantity'] ?? 0.0,
      date: json['orderDate'] ?? '',
      item: json['productName'] ?? '',
      description: json['description'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      salePrice: json['salePrice'] ?? 0.0,
      amount: (json['salePrice'] * json['quantity']) ?? 0.0,
    );
  }

/*ReportModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'] ?? 0;
    customerName = json['customerName'] ?? '';
    customerCompanyName = json['customerCompanyName'] ?? '';
    quantity = json['quantity'] ?? 0.0;
    subTotal = json['subTotal'] ?? 0.0;
    totalTax = json['totalTax'] ?? 0.0;
    netTotal = json['netTotal'] ?? 0.0;
    cogs = json['cogs'] ?? 0.0;
    discountValue = json['discountValue'] ?? 0.0;
    date = json['orderDate'] ?? '';
    item = json['productName'] ?? '';
    description = json['description'] ?? '';
    orderNumber = json['orderNumber'] ?? '';
    salePrice = json['salePrice'] ?? 0.0;
    amount = (json['salePrice'] * json['quantity']) ?? 0.0;
  }*/

/*Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['customerName'] = customerName;
    data['customerCompanyName'] = customerCompanyName;
    data['quantity'] = quantity;
    data['subTotal'] = subTotal;
    data['totalTax'] = totalTax;
    data['netTotal'] = netTotal;
    data['cogs'] = cogs;
    data['discountValue'] = discountValue;
    return data;
  }*/
}
