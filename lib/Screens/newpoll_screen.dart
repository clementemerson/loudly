import 'package:flutter/material.dart';

class NewPollScreen extends StatelessWidget {
  static const String id = 'newpoll_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Poll'),
      ),
      body: Container(
        child: Center(
          child: Text('New Poll'),
        ),
      ),
    );
  }
}
