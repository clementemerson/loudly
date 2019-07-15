import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {  
  static const String id = 'settings_screen';
  static const String appBarTitle = 'Settings';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SettingsScreen.appBarTitle),
      ),
      body: Container(
        child: Center(
          child: Text(SettingsScreen.appBarTitle),
        ),
      ),
    );
  }
}