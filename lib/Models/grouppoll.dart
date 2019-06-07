// To parse this JSON data, do
//
//     final groupPoll = groupPollFromJson(jsonString);

import 'dart:convert';

GroupPoll groupPollFromJson(String str) => GroupPoll.fromJson(json.decode(str));

String groupPollToJson(GroupPoll data) => json.encode(data.toJson());

class GroupPoll {
    int pollid;
    int groupid;
    int sharedBy;
    int createdAt;
    int updatedAt;

    GroupPoll({
        this.pollid,
        this.groupid,
        this.sharedBy,
        this.createdAt,
        this.updatedAt,
    });

    factory GroupPoll.fromJson(Map<String, dynamic> json) => new GroupPoll(
        pollid: json["pollid"],
        groupid: json["groupid"],
        sharedBy: json["sharedBy"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "pollid": pollid,
        "groupid": groupid,
        "sharedBy": sharedBy,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}