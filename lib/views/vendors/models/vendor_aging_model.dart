class VendorAgingModel {
  int? billId;
  String? billDate;
  String? billNumber;
  String? agingGroup;
  String? orderType;
  double? totalAmount;
  int? aging;
  double? amountDue;

  VendorAgingModel(
      {this.billId,
      this.billDate,
      this.billNumber,
      this.agingGroup,
      this.orderType,
      this.totalAmount,
      this.aging,
      this.amountDue});

  VendorAgingModel.fromJson(Map<String, dynamic> json) {
    billId = json['billId'];
    billDate = json['billDate'];
    billNumber = json['billNumber'];
    agingGroup = json['agingGroup'];
    orderType = json['orderType'];
    totalAmount = json['totalAmount'];
    aging = json['aging'];
    amountDue = json['amountDue'];
  }

  static List<VendorAgingModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => VendorAgingModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billId'] = billId;
    data['billDate'] = billDate;
    data['billNumber'] = billNumber;
    data['agingGroup'] = agingGroup;
    data['orderType'] = orderType;
    data['totalAmount'] = totalAmount;
    data['aging'] = aging;
    data['amountDue'] = amountDue;
    return data;
  }
}
