import 'package:flutter/material.dart';

import 'package:loudly/project_styles.dart';

class ColorBoxSmall extends StatelessWidget {
  const ColorBoxSmall({
    Key key,
    @required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3.0),
      padding: EdgeInsets.all(9.0),
      decoration: BoxDecoration(
        color: kGetOptionColor(index),
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(6.0),
      ),
    );
  }
}

class ColorBox extends StatelessWidget {
  const ColorBox({
    Key key,
    @required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: kGetOptionColor(index),
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}