class PermissionsModel {
  PermissionsModel({
    this.data,
  });

  PermissionsModel.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Data? data;

  PermissionsModel copyWith({
    Data? data,
  }) =>
      PermissionsModel(
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    this.userId,
    this.role,
    this.permissions,
  });

  Data.fromJson(dynamic json) {
    userId = json['userId'];
    role = json['role'];
    permissions =
        json['permissions'] != null ? json['permissions'].cast<String>() : [];
  }

  num? userId;
  String? role;
  List<String>? permissions;

  Data copyWith({
    num? userId,
    String? role,
    List<String>? permissions,
  }) =>
      Data(
        userId: userId ?? this.userId,
        role: role ?? this.role,
        permissions: permissions ?? this.permissions,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['role'] = role;
    map['permissions'] = permissions;
    return map;
  }
}
