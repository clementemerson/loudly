// To parse this JSON data, do
//
//     final generalMessageFormat = generalMessageFormatFromJson(jsonString);

import 'dart:convert';

GeneralMessageFormat generalMessageFormatFromJson(String str) => GeneralMessageFormat.fromJson(json.decode(str));

String generalMessageFormatToJson(GeneralMessageFormat data) => json.encode(data.toJson());

class GeneralMessageFormat {
    String status;
    Message message;

    GeneralMessageFormat({
        this.status,
        this.message,
    });

    factory GeneralMessageFormat.fromJson(Map<String, dynamic> json) => new GeneralMessageFormat(
        status: json["Status"],
        message: Message.fromJson(json["Details"]),
    );

    Map<String, dynamic> toJson() => {
        "Status": status,
        "Details": message.toJson(),
    };
}

class Message {
    String module;
    String event;
    int messageid;
    dynamic data;

    Message({
        this.module,
        this.event,
        this.messageid,
        this.data,
    });

    factory Message.fromJson(Map<String, dynamic> json) => new Message(
        module: json["module"],
        event: json["event"],
        messageid: json["messageid"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "module": module,
        "event": event,
        "messageid": messageid,
        "data": data,
    };
}
