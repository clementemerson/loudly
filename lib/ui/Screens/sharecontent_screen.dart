import 'package:flutter/material.dart';
import 'package:loudly/common_widgets.dart';
import 'package:loudly/providers/poll.dart';
import 'package:loudly/providers/poll_store.dart';
import 'package:provider/provider.dart';

class ShareContentScreen extends StatelessWidget {
  static final String route = 'sharecontent_screen';

  @override
  Widget build(BuildContext context) {
    final int pollid = ModalRoute.of(context).settings.arguments as int;
    final Poll poll = Provider.of<PollStore>(context).findById(pollid: pollid);

    return Scaffold(
      appBar: AppBar(
        title: Text('Share Poll'),
      ),
      body: Column(
        children: <Widget>[
          kUserInputTextField(
            helperText: 'Search',
            maxLen: null,
            fontSize: 16.0,                                                                                                       
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}
