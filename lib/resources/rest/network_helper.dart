import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class RestAPIHelper {
  static Future getData({@required String url}) async {
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
      throw Exception('Failed to get data');
    }
  }

  static Future postData({@required String url, @required dynamic body}) async {
    final headers = {
      "accept": "application/json",
      "content-type": "application/json"
    };
    final encoding = Encoding.getByName("utf-8");

    http.Response response = await http.post(url,
        headers: headers,
        encoding: encoding,
        body: json.encode(body));

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
      throw Exception('Failed to post data');
    }
  }
}
