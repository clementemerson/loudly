import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

Widget kGetActivityIndicator() {
  return Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator();
}