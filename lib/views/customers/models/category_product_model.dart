import '../../../exports/index.dart';

class CategoryProductModel {
  int? productId;
  String? productName;
  String? description;
  String? barCode;
  late double quantity;
  double? cost;
  bool? isTaxable;
  bool? isDamaged;
  String? rootCategoryName;
  String? categoryName;
  double? price;
  double? customPrice;
  double? basePrice;
  double? lastPrice;
  double? tierPrice;
  double? suggestedRetailPrice;
  String? pricingPolicyApplied;
  late RxList lastOrders = [].obs;

  CategoryProductModel(
      {this.productId,
      this.productName,
      this.description,
      this.quantity = 0,
      this.cost,
      this.isTaxable,
      this.barCode = '',
      this.isDamaged = false,
      this.rootCategoryName,
      this.categoryName,
      this.price,
      this.customPrice,
      this.basePrice,
      this.suggestedRetailPrice = 0.0,
      this.lastPrice,
      this.tierPrice,
      this.pricingPolicyApplied});

  CategoryProductModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    description = (json['description'] == null) ? " " : json['description'];
    quantity = (json['quantity'] == null)
        ? json['quantityInHand'].toDouble()
        : json['quantity'].toDouble();
    cost = json['cost'].toDouble() ?? 0.0;
    suggestedRetailPrice = json['suggestedRetailPrice'] ?? 0.0;
    isTaxable = json['isTaxable'];
    rootCategoryName = json['rootCategoryName'];
    categoryName = json['categoryName'];
    price = json['price'];
    customPrice = json['customPrice'];
    basePrice = json['basePrice'];
    lastPrice = json['lastPrice'];
    tierPrice = json['tierPrice'];
    pricingPolicyApplied = json['pricingPolicyApplied'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['productName'] = productName;
    data['quantity'] = quantity;
    data['cost'] = cost;
    data['isTaxable'] = isTaxable;
    data['rootCategoryName'] = rootCategoryName;
    data['categoryName'] = categoryName;
    data['price'] = price;
    data['customPrice'] = customPrice;
    data['basePrice'] = basePrice;
    data['lastPrice'] = lastPrice;
    data['tierPrice'] = tierPrice;
    data['pricingPolicyApplied'] = pricingPolicyApplied;
    return data;
  }

  factory CategoryProductModel.fromProductModel(ProductModel productModel) {
    return CategoryProductModel(
      productId: productModel.productId?.toInt(),
      productName: productModel.productName,
      description: productModel.description,
      quantity: productModel.quantityInHand?.toDouble() ?? 0.0,
      cost: productModel.purchaseCost?.toDouble() ?? 0.0,
      isTaxable: productModel.isTaxable,
      barCode: productModel.barcode ?? '',
      rootCategoryName: productModel.rootCategoryName,
      categoryName: productModel.categoryName,
      price: productModel.price?.toDouble(),
      suggestedRetailPrice: productModel.suggestedRetailPrice?.toDouble(),
    );
  }

  factory CategoryProductModel.fromEditOrderJson(Map<String, dynamic> json) {
    return CategoryProductModel(
      productId: json['productId'],
      productName: json['productName'],
      description: json['description'],
      quantity: json['quantity'],
      cost: json['cost'].toDouble() ?? 0.0,
      isTaxable: json['isTaxable'],
      isDamaged: json['isDamaged'] ?? false,
      rootCategoryName: json['rootCategoryName'],
      price: json['price'].toDouble(),
      suggestedRetailPrice: json['suggestedRetailPrice'] ?? 0.0,
      barCode: json['barcode'],
    );
  }

  factory CategoryProductModel.fromMainProductJson(Map<String, dynamic> json) {
    return CategoryProductModel(
      productId: json['productId'],
      productName: json['productName'],
      description: json['description'],
      barCode: json['barcode'],
      price: (json['price'] ?? 0.0).toDouble(),
      cost: json['cost'].toDouble() ?? 0.0,
      suggestedRetailPrice: (json['suggestedRetailPrice'] ?? 0.0).toDouble(),
      rootCategoryName: json['rootCategoryName'],
      categoryName: json['categoryName'],
      isTaxable: json['isTaxable'] ?? false,
    );
  }
}
