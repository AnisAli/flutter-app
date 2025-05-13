import '../../../services/api/api_constants.dart';
import '../../../services/api/base_client.dart';
import '../../../utils/logger.dart';
import 'category_product_model.dart';

class RootCategory {
  int? parentCategoryId;
  int? rootCategoryId;
  String? rootCategoryName;
  bool? canDelete;
  int? categoryId;
  String? name;
  String? description;
  bool? showOnWeb;
  bool? isDeleted;
  late List<CategoryProductModel> products;

  RootCategory(
      {this.parentCategoryId,
      this.rootCategoryId,
      this.rootCategoryName,
      this.canDelete,
      this.categoryId,
      this.name,
      this.description,
      this.showOnWeb,
      this.isDeleted});

  RootCategory.fromJson(Map<String, dynamic> json) {
    parentCategoryId = json['parentCategoryId'];
    rootCategoryId = json['rootCategoryId'];
    rootCategoryName = json['rootCategoryName'];
    canDelete = json['canDelete'];
    categoryId = json['categoryId'];
    name = json['name'];
    description = json['description'];
    showOnWeb = json['showOnWeb'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['parentCategoryId'] = parentCategoryId;
    data['rootCategoryId'] = rootCategoryId;
    data['rootCategoryName'] = rootCategoryName;
    data['canDelete'] = canDelete;
    data['categoryId'] = categoryId;
    data['name'] = name;
    data['description'] = description;
    data['showOnWeb'] = showOnWeb;
    data['isDeleted'] = isDeleted;
    return data;
  }


  List<RootCategory> createRootCategoriesList(List<dynamic> data) {
    List<RootCategory> result = [];
    for (var item in data) {
      result.add(RootCategory.fromJson(item));
    }
    return result;
  }
}
