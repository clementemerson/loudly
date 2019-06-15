// To parse this JSON data, do
//
//     final groupPollResult = groupPollResultFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/Models/polldata.dart';

GroupPollResult groupPollResultFromJson(Map<String, dynamic> json) => GroupPollResult.fromJson(json);

String groupPollResultToJson(GroupPollResult data) => json.encode(data.toJson());

class GroupPollResult {
    int pollId;
    int groupId;
    String groupName;
    List<Option> options;

    GroupPollResult({
        this.pollId,
        this.groupId,
        this.groupName,
        this.options,
    });

    factory GroupPollResult.fromJson(Map<String, dynamic> json) => new GroupPollResult(
        pollId: json["pollId"],
        groupId: json["groupId"],
        groupName: json["groupName"],
        options: new List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "pollId": pollId,
        "groupId": groupId,
        "groupName": groupName,
        "options": new List<dynamic>.from(options.map((x) => x.toJson())),
    };
}