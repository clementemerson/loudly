// To parse this JSON data, do
//
//     final generalMessageFormat = generalMessageFormatFromJson(jsonString);

import 'dart:convert';

GeneralMessageFormat generalMessageFormatFromJson(String str) => GeneralMessageFormat.fromJson(json.decode(str));

String generalMessageFormatToJson(GeneralMessageFormat data) => json.encode(data.toJson());

class GeneralMessageFormat {
    String module;
    String event;
    String status;
    dynamic data;

    GeneralMessageFormat({
        this.module,
        this.event,
        this.status,
        this.data,
    });

    factory GeneralMessageFormat.fromJson(Map<String, dynamic> json) => new GeneralMessageFormat(
        module: json["module"],
        event: json["event"],
        status: json["status"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "module": module,
        "event": event,
        "status": status,
        "data": data,
    };
}
