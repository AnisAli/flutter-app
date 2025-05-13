class CustomerOpenBalanceReportModel {
  String? date;
  String? modifiedDate;
  String? transaction;
  String? transactionNumber;
  String? customerName;
  double? subTotal;
  double? totalTax;
  double? amount;
  double? invoiceBalance;
  String? companyName;
  int? customerId;
  int? id;
  int? transactionType;
  double? deliveryFee;
  double? remainingCreditAmount;
  int? paymentMethod;
  bool? isSynced;

  CustomerOpenBalanceReportModel(
      {this.date,
      this.modifiedDate,
      this.transaction,
      this.transactionNumber,
      this.customerName,
      this.subTotal,
      this.totalTax,
      this.amount,
      this.invoiceBalance,
      this.companyName,
      this.customerId,
      this.id,
      this.transactionType,
      this.deliveryFee,
      this.remainingCreditAmount,
      this.paymentMethod,
      this.isSynced});

  CustomerOpenBalanceReportModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    modifiedDate = json['modifiedDate'];
    transaction = json['transaction'];
    transactionNumber = json['transactionNumber'];
    customerName = json['customerName'];
    subTotal = json['subTotal'];
    totalTax = json['totalTax'];
    amount = json['amount'];
    invoiceBalance = json['invoiceBalance'];
    companyName = json['companyName'];
    customerId = json['customerId'];
    id = json['id'];
    transactionType = json['transactionType'];
    deliveryFee = json['deliveryFee'];
    remainingCreditAmount = json['remainingCreditAmount'];
    paymentMethod = json['paymentMethod'];
    isSynced = json['isSynced'];
  }

  static List<CustomerOpenBalanceReportModel> listFromJson(
      List<dynamic> jsonList) {
    return jsonList
        .map((json) => CustomerOpenBalanceReportModel.fromJson(json))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['modifiedDate'] = modifiedDate;
    data['transaction'] = transaction;
    data['transactionNumber'] = transactionNumber;
    data['customerName'] = customerName;
    data['subTotal'] = subTotal;
    data['totalTax'] = totalTax;
    data['amount'] = amount;
    data['invoiceBalance'] = invoiceBalance;
    data['companyName'] = companyName;
    data['customerId'] = customerId;
    data['id'] = id;
    data['transactionType'] = transactionType;
    data['deliveryFee'] = deliveryFee;
    data['remainingCreditAmount'] = remainingCreditAmount;
    data['paymentMethod'] = paymentMethod;
    data['isSynced'] = isSynced;
    return data;
  }
}
