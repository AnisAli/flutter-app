class RolePermissionModel {
  int? id;
  String? name;
  String? shortCode;
  String? application;
  int? parentId;
  bool? isDefault;
  bool? isDeleted;

  RolePermissionModel(
      {this.id,
      this.name,
      this.shortCode,
      this.application,
      this.parentId,
      this.isDefault,
      this.isDeleted});

  RolePermissionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortCode = json['shortCode'];
    application = json['application'];
    parentId = json['parentId'];
    isDefault = json['isDefault'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['shortCode'] = shortCode;
    data['application'] = application;
    data['parentId'] = parentId;
    data['isDefault'] = isDefault;
    data['isDeleted'] = isDeleted;
    return data;
  }
}
