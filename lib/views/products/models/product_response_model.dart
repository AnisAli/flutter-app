import '../../../exports/index.dart';

class ProductResponseModel {
  ProductResponseModel({
    this.odatacontext,
    this.odatacount,
    this.products,
  });

  ProductResponseModel.fromJson(dynamic json) {
    odatacontext = json['@odata.context'];
    odatacount = json['@odata.count'];
    if (json['value'] != null) {
      products = [];
      json['value'].forEach((v) {
        products?.add(ProductModel.fromJson(v));
      });
    }
  }

  ProductResponseModel.fromVendorJson(dynamic json) {
    odatacontext = json['@odata.context'];
    odatacount = json['@odata.count'];
    if (json['value'] != null) {
      products = [];
      json['value'].forEach((v) {
        products?.add(ProductModel.fromVendorQuickInvoiceJson(v));
      });
    }
  }

  String? odatacontext;
  num? odatacount;
  List<ProductModel>? products;

  ProductResponseModel copyWith({
    String? odatacontext,
    num? odatacount,
    List<ProductModel>? products,
  }) =>
      ProductResponseModel(
        odatacontext: odatacontext ?? this.odatacontext,
        odatacount: odatacount ?? this.odatacount,
        products: products ?? this.products,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['@odata.context'] = odatacontext;
    map['@odata.count'] = odatacount;
    if (products != null) {
      map['value'] = products?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
