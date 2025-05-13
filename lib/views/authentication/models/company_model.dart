import '../../../exports/index.dart';

class Company {
  Company({
    this.companyId,
    this.shortId,
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
    this.isDemo,
    this.isSetupCompleted,
    this.disclaimer,
    this.logoUrl,
    this.businessType,
    this.industryType,
    this.deliveryMethods,
    this.paymentMethods,
    this.invoiceTemplate,
    this.showBarcodeInEmail,
    this.permissions,
    this.pricingPolicy,
    this.usePickupSlots,
    this.baseDomain,
    this.highlightedTags,
    this.timeZoneId,
    this.tobaccoPermitId,
    this.salesTaxId,
  });

  Company.fromJson(dynamic json) {
    companyId = json['companyId'];
    shortId = json['shortId'];
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
    isDemo = json['isDemo'];
    isSetupCompleted = json['isSetupCompleted'];
    disclaimer = json['disclaimer'];
    logoUrl = json['logoUrl'];
    businessType = json['businessType'];
    industryType = json['industryType'];
    if (json['deliveryMethods'] != null) {
      deliveryMethods = [];
      json['deliveryMethods'].forEach((v) {
        deliveryMethods?.add(v);
      });
    }
    if (json['paymentMethods'] != null) {
      paymentMethods = [];
      json['paymentMethods'].forEach((v) {
        paymentMethods?.add(v);
      });
    }
    invoiceTemplate = json['invoiceTemplate'];
    showBarcodeInEmail = json['showBarcodeInEmail'];
    permissions =
        json['permissions'] != null ? json['permissions'].cast<String>() : [];
    pricingPolicy = json['pricingPolicy'];
    usePickupSlots = json['usePickupSlots'];
    baseDomain = json['baseDomain'];
    if (json['highlightedTags'] != null) {
      highlightedTags = [];
      json['highlightedTags'].forEach((v) {
        highlightedTags?.add(HighlightedTags.fromJson(v));
      });
    }
    timeZoneId = json['timeZoneId'];
    tobaccoPermitId = json['tobaccoPermitId'];
    salesTaxId = json['salesTaxId'];
  }

  num? companyId;
  String? shortId;
  String? name;
  String? phoneNo;
  String? replyToEmail;
  String? city;
  String? state;
  String? postalCode;
  String? country;
  String? address;
  num? taxPercent;
  num? taxId;
  bool? isDemo;
  bool? isSetupCompleted;
  String? disclaimer;
  String? logoUrl;
  String? businessType;
  String? industryType;
  List<dynamic>? deliveryMethods;
  List<dynamic>? paymentMethods;
  String? invoiceTemplate;
  bool? showBarcodeInEmail;
  List<String>? permissions;
  String? pricingPolicy;
  bool? usePickupSlots;
  String? baseDomain;
  List<HighlightedTags>? highlightedTags;
  String? timeZoneId;
  String? tobaccoPermitId;
  String? salesTaxId;

  Company copyWith({
    num? companyId,
    String? shortId,
    String? name,
    String? phoneNo,
    String? replyToEmail,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? address,
    num? taxPercent,
    num? taxId,
    bool? isDemo,
    bool? isSetupCompleted,
    String? disclaimer,
    String? logoUrl,
    String? businessType,
    String? industryType,
    List<dynamic>? deliveryMethods,
    List<dynamic>? paymentMethods,
    String? invoiceTemplate,
    bool? showBarcodeInEmail,
    List<String>? permissions,
    String? pricingPolicy,
    bool? usePickupSlots,
    String? baseDomain,
    List<HighlightedTags>? highlightedTags,
    String? timeZoneId,
    String? tobaccoPermitId,
    String? salesTaxId,
  }) =>
      Company(
        companyId: companyId ?? this.companyId,
        shortId: shortId ?? this.shortId,
        name: name ?? this.name,
        phoneNo: phoneNo ?? this.phoneNo,
        replyToEmail: replyToEmail ?? this.replyToEmail,
        city: city ?? this.city,
        state: state ?? this.state,
        postalCode: postalCode ?? this.postalCode,
        country: country ?? this.country,
        address: address ?? this.address,
        taxPercent: taxPercent ?? this.taxPercent,
        taxId: taxId ?? this.taxId,
        isDemo: isDemo ?? this.isDemo,
        isSetupCompleted: isSetupCompleted ?? this.isSetupCompleted,
        disclaimer: disclaimer ?? this.disclaimer,
        logoUrl: logoUrl ?? this.logoUrl,
        businessType: businessType ?? this.businessType,
        industryType: industryType ?? this.industryType,
        deliveryMethods: deliveryMethods ?? this.deliveryMethods,
        paymentMethods: paymentMethods ?? this.paymentMethods,
        invoiceTemplate: invoiceTemplate ?? this.invoiceTemplate,
        showBarcodeInEmail: showBarcodeInEmail ?? this.showBarcodeInEmail,
        permissions: permissions ?? this.permissions,
        pricingPolicy: pricingPolicy ?? this.pricingPolicy,
        usePickupSlots: usePickupSlots ?? this.usePickupSlots,
        baseDomain: baseDomain ?? this.baseDomain,
        highlightedTags: highlightedTags ?? this.highlightedTags,
        timeZoneId: timeZoneId ?? this.timeZoneId,
        tobaccoPermitId: tobaccoPermitId ?? this.tobaccoPermitId,
        salesTaxId: salesTaxId ?? this.salesTaxId,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['companyId'] = companyId;
    map['shortId'] = shortId;
    map['name'] = name;
    map['phoneNo'] = phoneNo;
    map['replyToEmail'] = replyToEmail;
    map['city'] = city;
    map['state'] = state;
    map['postalCode'] = postalCode;
    map['country'] = country;
    map['address'] = address;
    map['taxPercent'] = taxPercent;
    map['taxId'] = taxId;
    map['isDemo'] = isDemo;
    map['isSetupCompleted'] = isSetupCompleted;
    map['disclaimer'] = disclaimer;
    map['logoUrl'] = logoUrl;
    map['businessType'] = businessType;
    map['industryType'] = industryType;
    if (deliveryMethods != null) {
      map['deliveryMethods'] = deliveryMethods?.map((v) => v.toJson()).toList();
    }
    if (paymentMethods != null) {
      map['paymentMethods'] = paymentMethods?.map((v) => v.toJson()).toList();
    }
    map['invoiceTemplate'] = invoiceTemplate;
    map['showBarcodeInEmail'] = showBarcodeInEmail;
    map['permissions'] = permissions;
    map['pricingPolicy'] = pricingPolicy;
    map['usePickupSlots'] = usePickupSlots;
    map['baseDomain'] = baseDomain;
    if (highlightedTags != null) {
      map['highlightedTags'] = highlightedTags?.map((v) => v.toJson()).toList();
    }
    map['timeZoneId'] = timeZoneId;
    map['tobaccoPermitId'] = tobaccoPermitId;
    map['salesTaxId'] = salesTaxId;
    return map;
  }
}
