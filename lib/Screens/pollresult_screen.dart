import 'package:flutter/material.dart';

class PollResultScreen extends StatefulWidget {
  static const String id = 'pollresult_screen';

  @override
  _PollResultScreenState createState() => _PollResultScreenState();
}

class _PollResultScreenState extends State<PollResultScreen> {
  AppBar _getAppBar() {
    return AppBar(
      title: Text('Poll Result'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: Container(
        padding: const EdgeInsets.all(
          12.0,
        ),
        child: Text('sdafaf'),
      ),
    );
  }
}
