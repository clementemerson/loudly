import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  
  static const String id = 'search_screen';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Container(
        child: Center(
          child: Text('Search'),
        ),
      ),
    );
  }
}