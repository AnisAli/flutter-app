class CustomerModel {
  int? customerId;
  int? externalId;
  double? openBalance;
  String? quickBookId;
  String? editSequence;
  bool? isQBSynced;
  int? priceTierId;
  String? priceTierName;
  String? saleOrderStatus;
  double? taxPercent;
  bool? isTaxableCustomer;
  String? onlineAccess;
  String? firstName;
  String? lastName;
  String? customerName;
  String? companyName;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? postalCode;
  String? country;
  String? phoneNo;
  String? faxNo;
  String? email;
  String? notes;
  bool? isQBCustomer;
  bool? isActive;
  bool? isTaxable;
  List<String>? tagList;
  String? salesTaxId;
  String? salesTaxIdExpiryDate;
  String? tobaccoPermitId;
  String? tobaccoPermitIdExpiryDate;
  String? deliveryCertificateNumber;
  String? deliveryCertificateNumberExpiryDate;
  String? tabcId;
  String? tabcIdExpiryDate;

  CustomerModel(
      {this.customerId,
      this.externalId,
      this.openBalance,
      this.quickBookId,
      this.editSequence,
      this.isQBSynced,
      this.priceTierId,
      this.priceTierName,
      this.saleOrderStatus,
      this.taxPercent,
      this.isTaxableCustomer,
      this.onlineAccess,
      this.firstName,
      this.lastName,
      this.customerName,
      this.companyName,
      this.address1,
      this.address2,
      this.city,
      this.state,
      this.postalCode,
      this.country,
      this.phoneNo,
      this.faxNo,
      this.email,
      this.notes,
      this.isQBCustomer,
      this.isActive,
      this.isTaxable,
      this.tagList,
      this.salesTaxId,
      this.salesTaxIdExpiryDate,
      this.tobaccoPermitId,
      this.tobaccoPermitIdExpiryDate,
      this.deliveryCertificateNumber,
      this.deliveryCertificateNumberExpiryDate,
      this.tabcId,
      this.tabcIdExpiryDate});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    externalId = json['externalId'];
    openBalance = json['openBalance'];
    quickBookId = json['quickBookId'];
    editSequence = json['editSequence'];
    isQBSynced = json['isQBSynced'];
    priceTierId = json['priceTierId'];
    priceTierName = json['priceTierName'];
    saleOrderStatus = json['saleOrderStatus'];
    taxPercent = json['taxPercent'];
    isTaxableCustomer = json['isTaxableCustomer'];
    onlineAccess = json['onlineAccess'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    customerName = json['customerName'];
    companyName = json['companyName'];
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postalCode'];
    country = json['country'];
    phoneNo = json['phoneNo'];
    faxNo = json['faxNo'];
    email = json['email'];
    notes = json['notes'];
    isQBCustomer = json['isQBCustomer'];
    isActive = json['isActive'];
    isTaxable = json['isTaxable'];
    tagList = json['tagList'].cast<String>();
    salesTaxId = json['salesTaxId'];
    salesTaxIdExpiryDate = json['salesTaxIdExpiryDate'];
    tobaccoPermitId = json['tobaccoPermitId'];
    tobaccoPermitIdExpiryDate = json['tobaccoPermitIdExpiryDate'];
    deliveryCertificateNumber = json['deliveryCertificateNumber'];
    deliveryCertificateNumberExpiryDate =
        json['deliveryCertificateNumberExpiryDate'];
    tabcId = json['tabcId'];
    tabcIdExpiryDate = json['tabcIdExpiryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['externalId'] = externalId;
    data['openBalance'] = openBalance;
    data['quickBookId'] = quickBookId;
    data['editSequence'] = editSequence;
    data['isQBSynced'] = isQBSynced;
    data['priceTierId'] = priceTierId;
    data['priceTierName'] = priceTierName;
    data['saleOrderStatus'] = saleOrderStatus;
    data['taxPercent'] = taxPercent;
    data['isTaxableCustomer'] = isTaxableCustomer;
    data['onlineAccess'] = onlineAccess;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['customerName'] = customerName;
    data['companyName'] = companyName;
    data['address1'] = address1;
    data['address2'] = address2;
    data['city'] = city;
    data['state'] = state;
    data['postalCode'] = postalCode;
    data['country'] = country;
    data['phoneNo'] = phoneNo;
    data['faxNo'] = faxNo;
    data['email'] = email;
    data['notes'] = notes;
    data['isQBCustomer'] = isQBCustomer;
    data['isActive'] = isActive;
    data['isTaxable'] = isTaxable;
    data['tagList'] = tagList;
    data['salesTaxId'] = salesTaxId;
    data['salesTaxIdExpiryDate'] = salesTaxIdExpiryDate;
    data['tobaccoPermitId'] = tobaccoPermitId;
    data['tobaccoPermitIdExpiryDate'] = tobaccoPermitIdExpiryDate;
    data['deliveryCertificateNumber'] = deliveryCertificateNumber;
    data['deliveryCertificateNumberExpiryDate'] =
        deliveryCertificateNumberExpiryDate;
    data['tabcId'] = tabcId;
    data['tabcIdExpiryDate'] = tabcIdExpiryDate;
    return data;
  }
}
