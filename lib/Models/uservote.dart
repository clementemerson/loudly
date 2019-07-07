// To parse this JSON data, do
//
//     final userVote = userVoteFromJson(jsonString);

import 'dart:convert';

UserVote userVoteFromJson(String str) => UserVote.fromJson(json.decode(str));

String userVoteToJson(UserVote data) => json.encode(data.toJson());

class UserVote {
  static final String tablename = 'pollvotedata';

    int pollid;
    int userId;
    String votetype;
    int option;
    int votedAt;
    int createdAt;
    int updatedAt;

    UserVote({
        this.pollid,
        this.userId,
        this.votetype,
        this.option,
        this.votedAt,
        this.createdAt,
        this.updatedAt,
    });

    factory UserVote.fromJson(Map<String, dynamic> json) => new UserVote(
        pollid: json["pollid"],
        userId: json["user_id"],
        votetype: json["votetype"],
        option: json["option"],
        votedAt: json["votedAt"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "pollid": pollid,
        "user_id": userId,
        "votetype": votetype,
        "option": option,
        "votedAt": votedAt,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}
