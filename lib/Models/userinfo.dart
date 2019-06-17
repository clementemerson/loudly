// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

List<UserInfo> userInfoFromJson(String str) => new List<UserInfo>.from(json.decode(str).map((x) => UserInfo.fromJson(x)));

String userInfoToJson(List<UserInfo> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class UserInfo {
    int userId;
    String name;
    String statusMsg;
    String phoneNumber;
    String displayNameAsInPhone;
    String phoneNumberAsInPhone;

    UserInfo({
        this.userId,
        this.name,
        this.statusMsg,
        this.phoneNumber,
        this.displayNameAsInPhone,
        this.phoneNumberAsInPhone,
    });

    factory UserInfo.fromJson(Map<String, dynamic> json) => new UserInfo(
        userId: json["userId"],
        name: json["name"],
        statusMsg: json["statusMsg"],
        phoneNumber: json["phoneNumber"],
        displayNameAsInPhone: json["displayNameAsInPhone"],
        phoneNumberAsInPhone: json["phoneNumberAsInPhone"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "statusMsg": statusMsg,
        "phoneNumber": phoneNumber,
        "displayNameAsInPhone": displayNameAsInPhone,
        "phoneNumberAsInPhone": phoneNumberAsInPhone,
    };
}
