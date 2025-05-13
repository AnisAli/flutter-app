class CompanyModel {
  int? companyId;
  String? name;
  String? phoneNo;
  String? replyToEmail;
  String? city;
  String? state;
  String? postalCode;
  String? country;
  String? address;
  double? taxPercent;
  int? taxId;
  int? trailPeriod;
  bool? isDemo;
  bool? isSetupCompleted;
  String? logoUrl;
  String? businessType;
  String? industryType;
  List<String>? deliveryMethods;
  List<String>? paymentMethods;
  String? invoiceTemplate;
  bool? showBarcodeInEmail;
  String? pricingPolicy;
  bool? usePickupSlots;
  List<String>? highlightedTags;
  String? timeZoneId;

  CompanyModel(
      {this.companyId,
      this.name,
      this.phoneNo,
      this.replyToEmail,
      this.city,
      this.state,
      this.postalCode,
      this.country,
      this.address,
      this.taxPercent,
      this.taxId,
      this.trailPeriod,
      this.isDemo,
      this.isSetupCompleted,
      this.logoUrl,
      this.businessType,
      this.industryType,
      this.deliveryMethods,
      this.paymentMethods,
      this.invoiceTemplate,
      this.showBarcodeInEmail,
      this.pricingPolicy,
      this.usePickupSlots,
      this.highlightedTags,
      this.timeZoneId});

  CompanyModel.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    name = json['name'];
    phoneNo = json['phoneNo'];
    replyToEmail = json['replyToEmail'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postalCode'];
    country = json['country'];
    address = json['address'];
    taxPercent = json['taxPercent'];
    taxId = json['taxId'];
    trailPeriod = json['trailPeriod'];
    isDemo = json['isDemo'];
    isSetupCompleted = json['isSetupCompleted'];
    logoUrl = json['logoUrl'];
    businessType = json['businessType'];
    industryType = json['industryType'];
    deliveryMethods = json['deliveryMethods'].cast<String>();
    paymentMethods = json['paymentMethods'].cast<String>();
    invoiceTemplate = json['invoiceTemplate'];
    showBarcodeInEmail = json['showBarcodeInEmail'];
    pricingPolicy = json['pricingPolicy'];
    usePickupSlots = json['usePickupSlots'];
    highlightedTags = json['highlightedTags'].cast<String>();
    timeZoneId = json['timeZoneId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['companyId'] = companyId;
    data['name'] = name;
    data['phoneNo'] = phoneNo;
    data['replyToEmail'] = replyToEmail;
    data['city'] = city;
    data['state'] = state;
    data['postalCode'] = postalCode;
    data['country'] = country;
    data['address'] = address;
    data['taxPercent'] = taxPercent;
    data['taxId'] = taxId;
    data['trailPeriod'] = trailPeriod;
    data['isDemo'] = isDemo;
    data['isSetupCompleted'] = isSetupCompleted;
    data['logoUrl'] = logoUrl;
    data['businessType'] = businessType;
    data['industryType'] = industryType;
    data['deliveryMethods'] = deliveryMethods;
    data['paymentMethods'] = paymentMethods;
    data['invoiceTemplate'] = invoiceTemplate;
    data['showBarcodeInEmail'] = showBarcodeInEmail;
    data['pricingPolicy'] = pricingPolicy;
    data['usePickupSlots'] = usePickupSlots;
    data['highlightedTags'] = highlightedTags;
    data['timeZoneId'] = timeZoneId;
    return data;
  }
}
