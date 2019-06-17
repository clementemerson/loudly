// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

List<UserInfoDB> userInfoFromJson(String str) => new List<UserInfoDB>.from(json.decode(str).map((x) => UserInfoDB.fromJson(x)));

String userInfoToJson(List<UserInfoDB> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class UserInfoDB {
    int userId;
    String name;
    String statusMsg;
    String phoneNumber;
    int createdAt;
    int updatedAt;

    UserInfoDB({
        this.userId,
        this.name,
        this.statusMsg,
        this.phoneNumber,
        this.createdAt,
        this.updatedAt,
    });

    factory UserInfoDB.fromJson(Map<String, dynamic> json) => new UserInfoDB(
        userId: json["userId"],
        name: json["name"],
        statusMsg: json["statusMsg"],
        phoneNumber: json["phoneNumber"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "statusMsg": statusMsg,
        "phoneNumber": phoneNumber,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}
