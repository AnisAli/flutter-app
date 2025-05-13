import '../../../exports/index.dart';

class ApplicationPermissionsModel {
  String? application;
  List<RolePermissionModel>? permissions;
  List<int> bannedPermissions = [
    153,
    154,
    155,
    156,
    304,
    305,
    306,
    307,
    308,
    309,
    312,
    1005,
    1008,
    1018
  ];

  ApplicationPermissionsModel({this.application, this.permissions});

  ApplicationPermissionsModel.fromJson(Map<String, dynamic> json) {
    application = json['application'];
    if (json['permissions'] != null) {
      permissions = <RolePermissionModel>[];
      json['permissions'].forEach((v) {
        RolePermissionModel permission = RolePermissionModel.fromJson(v);
        if (!bannedPermissions.contains(permission.id)) {
          permissions!.add(permission);
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['application'] = application;
    if (permissions != null) {
      data['permissions'] = permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
