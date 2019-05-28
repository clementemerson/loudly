import 'package:flutter/material.dart';

const double kIcon_Big = 150;
const double kIcon_Medium = 80;
const double kIcon_Small = 50;
const double kIcon_Mini = 20;

const double kText_Big = 40.0;

const double kText_Medium = 24.0;

const SizedBox kSizedBox_Medium = SizedBox(
  height: 40.0,
);

  Color kGetColor(int index) {
    switch (index) {
      case 0:
        return Colors.redAccent;
        break;
      case 1:
        return Colors.greenAccent;
        break;
      case 2:
        return Colors.blueAccent;
        break;
      default:
        return Colors.yellow;
        break;
    }
  }
