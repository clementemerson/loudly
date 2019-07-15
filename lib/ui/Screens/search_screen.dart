import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {  
  static const String id = 'search_screen';
  static const String appBarTitle = 'Search';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SearchScreen.appBarTitle),
      ),
      body: Container(
        child: Center(
          child: Text(SearchScreen.appBarTitle),
        ),
      ),
    );
  }
}