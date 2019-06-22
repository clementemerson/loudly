// To parse this JSON data, do
//
//     final generalMessageFormat = generalMessageFormatFromJson(jsonString);

import 'dart:convert';

GeneralMessageFormat generalMessageFormatFromJson(String str) => GeneralMessageFormat.fromJson(json.decode(str));

String generalMessageFormatToJson(GeneralMessageFormat data) => json.encode(data.toJson());

class GeneralMessageFormat {
    String status;
    Details details;

    GeneralMessageFormat({
        this.status,
        this.details,
    });

    factory GeneralMessageFormat.fromJson(Map<String, dynamic> json) => new GeneralMessageFormat(
        status: json["Status"],
        details: Details.fromJson(json["Details"]),
    );

    Map<String, dynamic> toJson() => {
        "Status": status,
        "Details": details.toJson(),
    };
}

class Details {
    String module;
    String event;
    int messageid;
    dynamic data;

    Details({
        this.module,
        this.event,
        this.messageid,
        this.data,
    });

    factory Details.fromJson(Map<String, dynamic> json) => new Details(
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
