// To parse this JSON data, do
//
//     final generalMessageFormat = generalMessageFormatFromJson(jsonString);

import 'dart:convert';

GeneralMessageFormat generalMessageFormatFromJson(String str) => GeneralMessageFormat.fromJson(json.decode(str));

String generalMessageFormatToJson(GeneralMessageFormat data) => json.encode(data.toJson());

class GeneralMessageFormat {
  static final String jsonStatus = 'Status';
  static final String jsonDetails = 'Details';
  static final String jsonSuccess = 'Success';

    String status;
    Message message;

    GeneralMessageFormat({
        this.status,
        this.message,
    });

    factory GeneralMessageFormat.fromJson(Map<String, dynamic> json) => new GeneralMessageFormat(
        status: json[GeneralMessageFormat.jsonStatus],
        message: Message.fromJson(json[GeneralMessageFormat.jsonDetails]),
    );

    Map<String, dynamic> toJson() => {
        GeneralMessageFormat.jsonStatus: status,
        GeneralMessageFormat.jsonDetails: message.toJson(),
    };
}

class Message {
  static final String jsonModule = 'module';
  static final String jsonEvent = 'event';
  static final String jsonMessageId = 'messageid';
  static final String jsonData = 'data';

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
        module: json[Message.jsonModule],
        event: json[Message.jsonEvent],
        messageid: json[Message.jsonMessageId],
        data: json[Message.jsonData],
    );

    Map<String, dynamic> toJson() => {
        Message.jsonModule: module,
        Message.jsonEvent: event,
        Message.jsonMessageId: messageid,
        Message.jsonData: data,
    };
}
