import '../../../exports/index.dart';

class UserData {
  UserData({
    this.userId,
    this.customerId,
    this.userName,
    this.email,
    this.displayName,
    this.firstName,
    this.lastName,
    this.signInProvider,
    this.canLogin,
    this.company,
    this.userSettings,
  });

  UserData.fromJson(dynamic json) {
    userId = json['userId'];
    customerId = json['customerId'];
    userName = json['userName'];
    email = json['email'];
    displayName = json['displayName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    signInProvider = json['signInProvider'];
    canLogin = json['canLogin'];
    company =
        json['company'] != null ? Company.fromJson(json['company']) : null;
    userSettings = json['userSettings'] != null
        ? UserSettings.fromJson(json['userSettings'])
        : null;
  }

  String? userId;
  num? customerId;
  String? userName;
  String? email;
  String? displayName;
  String? firstName;
  String? lastName;
  String? signInProvider;
  bool? canLogin;
  Company? company;
  UserSettings? userSettings;

  UserData copyWith({
    String? userId,
    num? customerId,
    String? userName,
    String? email,
    String? displayName,
    String? firstName,
    String? lastName,
    String? signInProvider,
    bool? canLogin,
    Company? company,
    UserSettings? userSettings,
  }) =>
      UserData(
        userId: userId ?? this.userId,
        customerId: customerId ?? this.customerId,
        userName: userName ?? this.userName,
        email: email ?? this.email,
        displayName: displayName ?? this.displayName,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        signInProvider: signInProvider ?? this.signInProvider,
        canLogin: canLogin ?? this.canLogin,
        company: company ?? this.company,
        userSettings: userSettings ?? this.userSettings,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['customerId'] = customerId;
    map['userName'] = userName;
    map['email'] = email;
    map['displayName'] = displayName;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['signInProvider'] = signInProvider;
    map['canLogin'] = canLogin;
    if (company != null) {
      map['company'] = company?.toJson();
    }
    if (userSettings != null) {
      map['userSettings'] = userSettings?.toJson();
    }
    return map;
  }
}
