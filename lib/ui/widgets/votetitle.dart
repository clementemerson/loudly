import 'package:flutter/material.dart';

class VoteTitle extends StatelessWidget {
  const VoteTitle({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 12.0,
        right: 12.0,
      ),
      child: Text(
        title,
        textAlign: TextAlign.justify,
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: 16.0,
        ),
      ),
    );
  }
}