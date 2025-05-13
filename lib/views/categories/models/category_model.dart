class ParentCategoryModel {
  List<SubCategories>? subCategories;
  int? parentCategoryId;
  int? rootCategoryId;
  String? rootCategoryName;
  bool? canDelete;
  int? categoryId;
  String? name;
  String? description;
  bool? showOnWeb;
  bool? isDeleted;

  ParentCategoryModel(
      {this.subCategories,
      this.parentCategoryId,
      this.rootCategoryId,
      this.rootCategoryName,
      this.canDelete,
      this.categoryId,
      this.name,
      this.description,
      this.showOnWeb,
      this.isDeleted});

  ParentCategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      subCategories = <SubCategories>[];
      json['categories'].forEach((v) {
        subCategories!.add(SubCategories.fromJson(v));
      });
    }
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
    if (subCategories != null) {
      data['subCategories'] = subCategories!.map((v) => v.toJson()).toList();
    }
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

}

class SubCategories {
  int? parentCategoryId;
  String? parentCategoryName;
  int? rootCategoryId;
  String? rootCategoryName;
  bool? canDelete;
  int? categoryId;
  String? name;
  String? description;
  bool? showOnWeb;
  bool? isDeleted;

  SubCategories(
      {this.parentCategoryId,
      this.parentCategoryName,
      this.rootCategoryId,
      this.rootCategoryName,
      this.canDelete,
      this.categoryId,
      this.name,
      this.description,
      this.showOnWeb,
      this.isDeleted});

  SubCategories.fromJson(Map<String, dynamic> json) {
    parentCategoryId = json['parentCategoryId'];
    parentCategoryName = json['parentCategoryName'];
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
    data['parentCategoryName'] = parentCategoryName;
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
}
