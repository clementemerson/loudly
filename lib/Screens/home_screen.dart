import 'package:flutter/material.dart';
import 'package:loudly/common_widgets.dart';
import 'package:loudly/project_settings.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kProjectName),
        actions: <Widget>[
          kSearchWidget(context),
          kPopupMenuItem(context),
        ],
      ),
      body: Container(),
    );
  }
}
