class UserListModel {
  int? id;
  String? fullName;
  String? role;
  bool? isActive;
  String? firstName;
  String? lastName;
  String? email;
  int? roleId;

  UserListModel(
      {this.id,
      this.fullName,
      this.role,
      this.isActive,
      this.firstName,
      this.lastName,
      this.email,
      this.roleId});

  UserListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    role = json['role'];
    isActive = json['isActive'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    roleId = json['roleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['role'] = role;
    data['isActive'] = isActive;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['roleId'] = roleId;
    return data;
  }
}
