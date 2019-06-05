import 'package:flutter/material.dart';
import 'package:loudly/project_textconstants.dart';

const double kIcon_Big = 150;
const double kIcon_Medium = 80;
const double kIcon_Small = 50;
const double kIcon_Mini = 20;

const double kText_Big = 40.0;

const double kText_Medium = 24.0;

const SizedBox kSizedBox_Medium = SizedBox(
  height: 40.0,
);

class OptionData {
  String optionText;
  Color color;

  OptionData({@required this.optionText, @required this.color});
}

List<OptionData> optionsList = [
  OptionData(optionText: kOption1, color: Colors.redAccent),
  OptionData(optionText: kOption2, color: Colors.greenAccent),
  OptionData(optionText: kOption3, color: Colors.blueAccent),
  OptionData(optionText: kOption4, color: Colors.yellow),
];

Color kGetOptionColor(int index) {
  try {
    return optionsList[index].color;
  } catch (e) {}
  return Colors.grey;
}

String kGetOptionText(int index) {
  try {
    return optionsList[index].optionText;
  } catch (e) {}
  return kOption1;
}
