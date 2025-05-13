class RoleModel {
  int? id;
  String? name;
  String? description;
  bool? isCoreRole;
  List<int>? permissions;

  RoleModel(
      {this.id,
      this.name,
      this.description,
      this.isCoreRole,
      this.permissions});

  static List<RoleModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => RoleModel.fromJson(e)).toList();
  }

  @override
  String toString() {
    return '$name';
  }

  RoleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isCoreRole = json['isCoreRole'];
    permissions = json['permissions'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['isCoreRole'] = isCoreRole;
    data['permissions'] = permissions;
    return data;
  }
}
