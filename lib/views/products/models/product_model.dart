import '../../../exports/index.dart';

class ProductModel {
  ProductModel({
    this.productId,
    this.productName,
    this.publicName,
    this.description,
    this.barcode,
    this.price,
    this.promotionPrice,
    this.suggestedRetailPrice,
    this.categoryId,
    this.addToInventory = false,
    this.categoryName,
    this.rootCategoryId,
    this.rootCategoryName,
    this.isTaxable,
    this.quantityInHand,
    this.productUnit,
    this.unitPerCase,
    this.purchaseCost,
    this.averageCost,
    this.isActive,
    this.notes,
    this.imageUrl,
    this.isAgeRestricted,
    this.minAge,
    this.tags,
    this.companyId,
    this.showOnWeb,
    this.showOnPos,
    this.isFeatured,
    this.isNewArrival,
    this.posSortOrder,
    this.showCostModifiedAlert,
    this.createdBy,
    this.createdDate,
    this.modifiedDate,
    this.modifiedBy,
    this.pricingTiers,
  });

  ProductModel.fromJson(dynamic json) {
    productId = json['productId'];
    productName = json['productName'];
    publicName = json['publicName'];
    description = json['description'];
    barcode = json['barcode'];
    price = json['price'];
    promotionPrice = json['promotionPrice'];
    suggestedRetailPrice = json['suggestedRetailPrice'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    rootCategoryId = json['rootCategoryId'];
    rootCategoryName = json['rootCategoryName'];
    isTaxable = json['isTaxable'];
    quantityInHand = json['quantityInHand'];
    productUnit = json['productUnit'];
    unitPerCase = json['unitPerCase'];
    purchaseCost = json['purchaseCost'];
    averageCost = json['averageCost'];
    isActive = json['isActive'];
    notes = json['notes'];
    imageUrl = json['imageUrl'];
    isAgeRestricted = json['isAgeRestricted'];
    minAge = json['minAge'];
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags?.add(v);
      });
    }
    companyId = json['companyId'];
    showOnWeb = json['showOnWeb'];
    showOnPos = json['showOnPos'];
    isFeatured = json['isFeatured'];
    isNewArrival = json['isNewArrival'];
    posSortOrder = json['posSortOrder'];
    showCostModifiedAlert = json['showCostModifiedAlert'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    modifiedBy = json['modifiedBy'];
    if (json['pricingTiers'] != null) {
      pricingTiers = [];
      json['pricingTiers'].forEach((v) {
        pricingTiers?.add(PricingTiers.fromJson(v));
      });
    }
  }

  ProductModel.fromVendorQuickInvoiceJson(dynamic json) {
    productId = json['productId'];
    productName = json['productName'];
    publicName = json['publicName'];
    description = json['description'];
    barcode = json['barcode'];
    price = json['price'];
    promotionPrice = json['promotionPrice'];
    suggestedRetailPrice = json['suggestedRetailPrice'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    rootCategoryId = json['rootCategoryId'];
    rootCategoryName = json['rootCategoryName'];
    isTaxable = json['isTaxable'];
    quantityInHand = json['quantityInHand'];
    productUnit = json['productUnit'];
    unitPerCase = json['unitPerCase'];
    purchaseCost = json['cost'];
    averageCost = json['averageCost'];
    isActive = json['isActive'];
    notes = json['notes'];
    imageUrl = json['imageUrl'];
    isAgeRestricted = json['isAgeRestricted'];
    minAge = json['minAge'];
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags?.add(v);
      });
    }
    companyId = json['companyId'];
    showOnWeb = json['showOnWeb'];
    showOnPos = json['showOnPos'];
    isFeatured = json['isFeatured'];
    isNewArrival = json['isNewArrival'];
    posSortOrder = json['posSortOrder'];
    showCostModifiedAlert = json['showCostModifiedAlert'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    modifiedBy = json['modifiedBy'];
    if (json['pricingTiers'] != null) {
      pricingTiers = [];
      json['pricingTiers'].forEach((v) {
        pricingTiers?.add(PricingTiers.fromJson(v));
      });
    }
  }

  num? productId;
  String? productName;
  dynamic publicName;
  String? description;
  String? barcode;
  num? price;
  dynamic promotionPrice;
  num? suggestedRetailPrice;
  dynamic categoryId;
  dynamic categoryName;
  num? rootCategoryId;
  String? rootCategoryName;
  bool? isTaxable;
  num? quantityInHand;
  dynamic productUnit;
  num? unitPerCase;
  num? purchaseCost;
  num? averageCost;
  bool? isActive;
  bool? addToInventory;
  String? notes;
  String? imageUrl;
  bool? isAgeRestricted;
  num? minAge;
  List<dynamic>? tags;
  num? companyId;
  bool? showOnWeb;
  bool? showOnPos;
  bool? isFeatured;
  bool? isNewArrival;
  num? posSortOrder;
  bool? showCostModifiedAlert;
  dynamic createdBy;
  String? createdDate;
  String? modifiedDate;
  dynamic modifiedBy;
  List<PricingTiers>? pricingTiers;

  ProductModel copyWith({
    num? productId,
    String? productName,
    dynamic publicName,
    String? description,
    String? barcode,
    num? price,
    dynamic promotionPrice,
    num? suggestedRetailPrice,
    dynamic categoryId,
    dynamic categoryName,
    num? rootCategoryId,
    String? rootCategoryName,
    bool? isTaxable,
    num? quantityInHand,
    dynamic productUnit,
    num? unitPerCase,
    num? purchaseCost,
    num? averageCost,
    bool? isActive,
    String? notes,
    String? imageUrl,
    bool? isAgeRestricted,
    num? minAge,
    List<dynamic>? tags,
    num? companyId,
    bool? showOnWeb,
    bool? showOnPos,
    bool? isFeatured,
    bool? isNewArrival,
    num? posSortOrder,
    bool? showCostModifiedAlert,
    dynamic createdBy,
    String? createdDate,
    String? modifiedDate,
    dynamic modifiedBy,
    List<PricingTiers>? pricingTiers,
  }) =>
      ProductModel(
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        publicName: publicName ?? this.publicName,
        description: description ?? this.description,
        barcode: barcode ?? this.barcode,
        price: price ?? this.price,
        promotionPrice: promotionPrice ?? this.promotionPrice,
        suggestedRetailPrice: suggestedRetailPrice ?? this.suggestedRetailPrice,
        categoryId: categoryId ?? this.categoryId,
        categoryName: categoryName ?? this.categoryName,
        rootCategoryId: rootCategoryId ?? this.rootCategoryId,
        rootCategoryName: rootCategoryName ?? this.rootCategoryName,
        isTaxable: isTaxable ?? this.isTaxable,
        quantityInHand: quantityInHand ?? this.quantityInHand,
        productUnit: productUnit ?? this.productUnit,
        unitPerCase: unitPerCase ?? this.unitPerCase,
        purchaseCost: purchaseCost ?? this.purchaseCost,
        averageCost: averageCost ?? this.averageCost,
        isActive: isActive ?? this.isActive,
        notes: notes ?? this.notes,
        imageUrl: imageUrl ?? this.imageUrl,
        isAgeRestricted: isAgeRestricted ?? this.isAgeRestricted,
        minAge: minAge ?? this.minAge,
        tags: tags ?? this.tags,
        companyId: companyId ?? this.companyId,
        showOnWeb: showOnWeb ?? this.showOnWeb,
        showOnPos: showOnPos ?? this.showOnPos,
        isFeatured: isFeatured ?? this.isFeatured,
        isNewArrival: isNewArrival ?? this.isNewArrival,
        posSortOrder: posSortOrder ?? this.posSortOrder,
        showCostModifiedAlert:
            showCostModifiedAlert ?? this.showCostModifiedAlert,
        createdBy: createdBy ?? this.createdBy,
        createdDate: createdDate ?? this.createdDate,
        modifiedDate: modifiedDate ?? this.modifiedDate,
        modifiedBy: modifiedBy ?? this.modifiedBy,
        pricingTiers: pricingTiers ?? this.pricingTiers,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['productId'] = productId;
    map['productName'] = productName;
    map['publicName'] = publicName;
    map['description'] = description;
    map['barcode'] = barcode;
    map['price'] = price;
    map['promotionPrice'] = promotionPrice;
    map['suggestedRetailPrice'] = suggestedRetailPrice;
    map['categoryId'] = categoryId;
    map['categoryName'] = categoryName;
    map['rootCategoryId'] = rootCategoryId;
    map['rootCategoryName'] = rootCategoryName;
    map['isTaxable'] = isTaxable;
    map['quantityInHand'] = quantityInHand;
    map['productUnit'] = productUnit;
    map['unitPerCase'] = unitPerCase;
    map['purchaseCost'] = purchaseCost;
    map['averageCost'] = averageCost;
    map['isActive'] = isActive;
    map['notes'] = notes;
    map['imageUrl'] = imageUrl;
    map['isAgeRestricted'] = isAgeRestricted;
    map['minAge'] = minAge;
    if (tags != null) {
      map['tags'] = tags?.map((v) => v.toJson()).toList();
    }
    map['companyId'] = companyId;
    map['showOnWeb'] = showOnWeb;
    map['showOnPos'] = showOnPos;
    map['isFeatured'] = isFeatured;
    map['isNewArrival'] = isNewArrival;
    map['posSortOrder'] = posSortOrder;
    map['showCostModifiedAlert'] = showCostModifiedAlert;
    map['createdBy'] = createdBy;
    map['createdDate'] = createdDate;
    map['modifiedDate'] = modifiedDate;
    map['modifiedBy'] = modifiedBy;
    if (pricingTiers != null) {
      map['pricingTiers'] = pricingTiers?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  factory ProductModel.fromProductDetailsJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'],
      productName: json['name'],
      description: json['description'],
      price: json['basePrice'],
      suggestedRetailPrice: json['suggestedRetailPrice'],
      rootCategoryId: json['parentCategoryId'],
      barcode: json['barcode'],
      unitPerCase: json['unitPerCase'],
      isTaxable: json['isTaxable'],
      purchaseCost: json['purchaseCost'],
      quantityInHand: json['quantityInHand'],
      isActive: json['isActive'],
      notes: json['notes'],
      imageUrl: json['imageUrl'],
      minAge: json['minAge'],
      isAgeRestricted: json['isAgeRestricted'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      showOnWeb: json['showOnWeb'],
      showOnPos: json['showOnPos'],
      isFeatured: json['isFeatured'],
      isNewArrival: json['isNewArrival'],
      showCostModifiedAlert: json['showCostModifiedAlert'],
    );
  }

  bool isOutOfStock() {
    if (quantityInHand == 0 || quantityInHand! < 1) {
      return true;
    } else {
      return false;
    }
  }

  bool isLossWarning() {
    if (purchaseCost! > price!) {
      return true;
    } else {
      return false;
    }
  }
}
