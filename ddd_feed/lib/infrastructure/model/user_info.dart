// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

class UserInfo {
  String? id;
  String? email;
  String? name;
  String? type;
  String? profile;

  UserInfo({this.id, this.name, this.type, this.email, this.profile});

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"].toString(),
        email: json["email"],
        name: json["name"],
        type: json["type"],
        profile: json["profile"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "email": email,
        "profile": profile,
        "id": id,
      };
}
