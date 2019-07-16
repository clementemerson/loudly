import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static final String id = 'settings_screen';
  static final String appBarTitle = 'Settings';

  AppBar _getAppBar() {
    return AppBar(
      title: Text(SettingsScreen.appBarTitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: Container(
        child: Center(
          child: Text(SettingsScreen.appBarTitle),
        ),
      ),
    );
  }
}
