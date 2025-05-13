class CategoryModel {
  num? parentCategoryId;
  num? rootCategoryId;
  String? rootCategoryName;
  bool? canDelete;
  num? categoryId;
  String? name;
  String? description;
  bool? showOnWeb;
  bool? isDeleted;

  CategoryModel({
    this.parentCategoryId,
    this.rootCategoryId,
    this.rootCategoryName,
    this.canDelete,
    this.categoryId,
    this.name,
    this.description,
    this.showOnWeb,
    this.isDeleted,
  });

  static List<CategoryModel> listFromJson(List jsonList) {
    return jsonList.map((e) => CategoryModel.fromJson(e)).toList();
  }

  CategoryModel.fromJson(dynamic json) {
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

  CategoryModel copyWith({
    num? parentCategoryId,
    num? rootCategoryId,
    String? rootCategoryName,
    bool? canDelete,
    num? categoryId,
    String? name,
    String? description,
    bool? showOnWeb,
    bool? isDeleted,
  }) =>
      CategoryModel(
        parentCategoryId: parentCategoryId ?? this.parentCategoryId,
        rootCategoryId: rootCategoryId ?? this.rootCategoryId,
        rootCategoryName: rootCategoryName ?? this.rootCategoryName,
        canDelete: canDelete ?? this.canDelete,
        categoryId: categoryId ?? this.categoryId,
        name: name ?? this.name,
        description: description ?? this.description,
        showOnWeb: showOnWeb ?? this.showOnWeb,
        isDeleted: isDeleted ?? this.isDeleted,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['parentCategoryId'] = parentCategoryId;
    map['rootCategoryId'] = rootCategoryId;
    map['rootCategoryName'] = rootCategoryName;
    map['canDelete'] = canDelete;
    map['categoryId'] = categoryId;
    map['name'] = name;
    map['description'] = description;
    map['showOnWeb'] = showOnWeb;
    map['isDeleted'] = isDeleted;
    return map;
  }

  @override
  String toString() {
    return '$name';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          parentCategoryId == other.parentCategoryId &&
          rootCategoryId == other.rootCategoryId &&
          rootCategoryName == other.rootCategoryName &&
          categoryId == other.categoryId &&
          name == other.name;

  @override
  int get hashCode =>
      parentCategoryId.hashCode ^
      rootCategoryId.hashCode ^
      rootCategoryName.hashCode ^
      categoryId.hashCode ^
      name.hashCode;
}
