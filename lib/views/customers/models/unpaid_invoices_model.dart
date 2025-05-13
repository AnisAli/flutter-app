class UnpaidInvoicesModel {
  int? customerId;
  String? address1;
  String? city;
  String? state;
  String? postalCode;
  bool? isTaxableCustomer;
  String? customerName;
  String? companyName;
  double? openBalance;
  double? availableCreditAmount;
  String? lastPaymentDate;
  List? unpaidInvoices;

  UnpaidInvoicesModel({
    this.customerId,
    this.address1,
    this.city,
    this.state,
    this.postalCode,
    this.isTaxableCustomer,
    this.customerName,
    this.companyName,
    this.openBalance,
    this.availableCreditAmount,
    this.lastPaymentDate,
    this.unpaidInvoices,
  });

  UnpaidInvoicesModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    address1 = json['address1'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postalCode'];
    isTaxableCustomer = json['isTaxableCustomer'];
    customerName = json['customerName'];
    companyName = json['companyName'];
    openBalance = json['openBalance'];
    availableCreditAmount = json['availableCreditAmount'];
    lastPaymentDate = json['lastPaymentDate'];
    unpaidInvoices = json['unpaidInvoices'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['customerId'] = customerId;
    json['address1'] = address1;
    json['city'] = city;
    json['state'] = state;
    json['postalCode'] = postalCode;
    json['isTaxableCustomer'] = isTaxableCustomer;
    json['customerName'] = customerName;
    json['companyName'] = companyName;
    json['openBalance'] = openBalance;
    json['availableCreditAmount'] = availableCreditAmount;
    json['lastPaymentDate'] = lastPaymentDate;
    json['unpaidInvoices'] = unpaidInvoices;

    return json;
  }
}
