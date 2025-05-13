class TransactionSummaryModel {
  late int customerId;
  String? customerName;
  String? customerCompanyName;
  int? vendorId;
  int? id;
  String? transaction;
  int? transactionType;
  String? transactionNumber;
  String? memo;
  String? date;
  String? createdDate;
  String? modifiedDate;
  double? amount;
  double? balance;
  int? paymentMethod;
  int? salesOrderStatus;
  String? deliveryMethod;
  String? createdBy;
  bool? isSynced;
  int? lastServeDays;
  String? vendorCompanyName;
  String? vendorName;

  TransactionSummaryModel(
      {required this.customerId,
      this.customerName,
      this.customerCompanyName,
      this.vendorId,
      this.vendorCompanyName,
      this.vendorName,
      this.id,
      this.transaction,
      this.transactionType,
      this.transactionNumber,
      this.memo,
      this.date,
      this.createdDate,
      this.modifiedDate,
      this.amount,
      this.balance,
      this.paymentMethod,
      this.salesOrderStatus,
      this.deliveryMethod,
      this.createdBy,
      this.isSynced,
      this.lastServeDays});

  TransactionSummaryModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    customerName = json['customerName'];
    customerCompanyName = json['customerCompanyName'];
    vendorId = json['vendorId'];
    vendorCompanyName = json['vendorCompanyName'];
    vendorId = json['vendorId'];
    id = json['id'];
    transaction = json['transaction'];
    transactionType = json['transactionType'];
    transactionNumber = json['transactionNumber'];
    memo = json['memo'];
    date = json['date'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    amount = json['amount'];
    balance = json['balance'];
    paymentMethod = json['paymentMethod'];
    salesOrderStatus = json['salesOrderStatus'];
    deliveryMethod = json['deliveryMethod'];
    createdBy = json['createdBy'];
    isSynced = json['isSynced'];
    lastServeDays = json['lastServeDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['customerName'] = customerName;
    data['customerCompanyName'] = customerCompanyName;
    data['vendorId'] = vendorId;
    data['id'] = id;
    data['transaction'] = transaction;
    data['transactionType'] = transactionType;
    data['transactionNumber'] = transactionNumber;
    data['memo'] = memo;
    data['date'] = date;
    data['createdDate'] = createdDate;
    data['modifiedDate'] = modifiedDate;
    data['amount'] = amount;
    data['balance'] = balance;
    data['paymentMethod'] = paymentMethod;
    data['salesOrderStatus'] = salesOrderStatus;
    data['deliveryMethod'] = deliveryMethod;
    data['createdBy'] = createdBy;
    data['isSynced'] = isSynced;
    data['lastServeDays'] = lastServeDays;
    return data;
  }
}
