import '../../../exports/index.dart';

class CustomerCategoryModel {
  late String categoryName;
  RxBool isExpanded = false.obs;
  RxInt selectedItemCount = 0.obs;
  late List<CategoryProductModel> products;

  CustomerCategoryModel({this.categoryName = '', required this.products});

  CustomerCategoryModel.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    if (json['products'] != null) {
      products = <CategoryProductModel>[];
      json['products'].forEach((v) {
        products.add(CategoryProductModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryName'] = categoryName;
    data['products'] = products.map((v) => v.toJson()).toList();
    return data;
  }
}
