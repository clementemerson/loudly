// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));

String userInfoToJson(UserInfo data) => json.encode(data.toJson());

class UserInfo {
    int userId;
    String name;
    String statusMsg;
    String phoneNumber;
    int createdAt;
    int updatedAt;

    UserInfo({
        this.userId,
        this.name,
        this.statusMsg,
        this.phoneNumber,
        this.createdAt,
        this.updatedAt,
    });

    factory UserInfo.fromJson(Map<String, dynamic> json) => new UserInfo(
        userId: json["user_id"],
        name: json["name"],
        statusMsg: json["statusMsg"],
        phoneNumber: json["phoneNumber"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "statusMsg": statusMsg,
        "phoneNumber": phoneNumber,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}