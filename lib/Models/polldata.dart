// To parse this JSON data, do
//
//     final pollData = pollDataFromJson(jsonString);

import 'dart:convert';

PollData pollDataFromJson(String str) => PollData.fromJson(json.decode(str));

String pollDataToJson(PollData data) => json.encode(data.toJson());

class PollData {
    int id;
    String title;
    List<Option> options;
    bool canBeShared;
    bool resultIsPublic;
    int createdBy;
    int createdAt;
    int updatedAt;

    PollData({
        this.id,
        this.title,
        this.options,
        this.canBeShared,
        this.resultIsPublic,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
    });

    factory PollData.fromJson(Map<String, dynamic> json) => new PollData(
        id: json["id"],
        title: json["title"],
        options: new List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
        canBeShared: json["canBeShared"],
        resultIsPublic: json["resultIsPublic"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "options": new List<dynamic>.from(options.map((x) => x.toJson())),
        "canBeShared": canBeShared,
        "resultIsPublic": resultIsPublic,
        "createdBy": createdBy,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}

class Option {
    int index;
    String desc;
    int openVotes;
    int secretVotes;

    Option({
        this.index,
        this.desc,
        this.openVotes,
        this.secretVotes,
    });

    factory Option.fromJson(Map<String, dynamic> json) => new Option(
        index: json["index"],
        desc: json["desc"],
        openVotes: json["openVotes"],
        secretVotes: json["secretVotes"],
    );

    Map<String, dynamic> toJson() => {
        "index": index,
        "desc": desc,
        "openVotes": openVotes,
        "secretVotes": secretVotes,
    };
}