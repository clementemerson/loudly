import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  static final String id = 'search_screen';
  static final String appBarTitle = 'Search';

  AppBar _getAppBar() {
    return AppBar(
      title: Text(SearchScreen.appBarTitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: Container(
        child: Center(
          child: Text(SearchScreen.appBarTitle),
        ),
      ),
    );
  }
}
