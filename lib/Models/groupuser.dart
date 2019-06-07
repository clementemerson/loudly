// To parse this JSON data, do
//
//     final groupUser = groupUserFromJson(jsonString);

import 'dart:convert';

GroupUser groupUserFromJson(String str) => GroupUser.fromJson(json.decode(str));

String groupUserToJson(GroupUser data) => json.encode(data.toJson());

class GroupUser {
    int groupid;
    int userId;
    int addedBy;
    String permission;
    int createdAt;
    int updatedAt;

    GroupUser({
        this.groupid,
        this.userId,
        this.addedBy,
        this.permission,
        this.createdAt,
        this.updatedAt,
    });

    factory GroupUser.fromJson(Map<String, dynamic> json) => new GroupUser(
        groupid: json["groupid"],
        userId: json["user_id"],
        addedBy: json["addedBy"],
        permission: json["permission"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "groupid": groupid,
        "user_id": userId,
        "addedBy": addedBy,
        "permission": permission,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}
