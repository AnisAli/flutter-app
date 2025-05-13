class VendorModel {
  int? vendorId;
  String? vendorName;
  bool? isQbVendor;
  bool? isQBCustomer;
  int? externalId;
  double? openBalance;
  String? quickBookId;
  String? firstName;
  String? lastName;
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
  bool? isActive;
  bool? isTaxable;

  VendorModel(
      {this.vendorId,
      this.vendorName,
      this.isQbVendor,
      this.isQBCustomer,
      this.externalId,
      this.openBalance,
      this.quickBookId,
      this.firstName,
      this.lastName,
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
      this.isActive,
      this.isTaxable});

  VendorModel.fromJson(Map<String, dynamic> json) {
    vendorId = json['vendorId'];
    vendorName = json['vendorName'];
    isQbVendor = json['isQbVendor'];
    isQBCustomer = json['isQBCustomer'];
    externalId = json['externalId'];
    openBalance = json['openBalance'];
    quickBookId = json['quickBookId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
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
    isActive = json['isActive'];
    isTaxable = json['isTaxable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vendorId'] = vendorId;
    data['vendorName'] = vendorName;
    data['isQbVendor'] = isQbVendor;
    data['isQBCustomer'] = isQBCustomer;
    data['externalId'] = externalId;
    data['openBalance'] = openBalance;
    data['quickBookId'] = quickBookId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
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
    data['isActive'] = isActive;
    data['isTaxable'] = isTaxable;
    return data;
  }
}
