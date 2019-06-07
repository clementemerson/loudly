// To parse this JSON data, do
//
//     final groupInfo = groupInfoFromJson(jsonString);

import 'dart:convert';

GroupInfo groupInfoFromJson(String str) => GroupInfo.fromJson(json.decode(str));

String groupInfoToJson(GroupInfo data) => json.encode(data.toJson());

class GroupInfo {
    int id;
    String name;
    String desc;
    int createdBy;
    int createdAt;
    int updatedAt;

    GroupInfo({
        this.id,
        this.name,
        this.desc,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
    });

    factory GroupInfo.fromJson(Map<String, dynamic> json) => new GroupInfo(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
        "createdBy": createdBy,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}
