// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

List<UserInfoDB> userInfoFromJson(String str) => new List<UserInfoDB>.from(json.decode(str).map((x) => UserInfoDB.fromJson(x)));

List<UserInfoDB> userInfoFromList(List<dynamic> list) => new List<UserInfoDB>.from(list.map((x) => UserInfoDB.fromJson(x)));

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
        userId: json["user_id"],
        name: json["name"],
        statusMsg: json["statusmsg"],
        phoneNumber: json["phonenumber"],
        createdAt: DateTime.parse(json["createdAt"]).millisecondsSinceEpoch,
        updatedAt: DateTime.parse(json["updatedAt"]).millisecondsSinceEpoch,
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "statusmsg": statusMsg,
        "phonenumber": phoneNumber,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}
