import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:loudly/common_widgets.dart';
import 'package:loudly/project_settings.dart';
import 'package:loudly/project_styles.dart';
import 'package:loudly/project_textconstants.dart';

class PollVoteScreen extends StatefulWidget {
  static const String id = 'poll_screen';

  final int pollId;

  PollVoteScreen({@required this.pollId});

  @override
  _PollVoteScreenState createState() => _PollVoteScreenState();
}

class _PollVoteScreenState extends State<PollVoteScreen> {
  bool secretVoting = false;
  String selectedOption = null;

  AppBar _getAppBar() {
    return AppBar(
      actions: <Widget>[
        FlatButton(
          textColor: Colors.blue,
          disabledTextColor: Colors.grey,
          onPressed: null,
          child: Text(
            'Vote',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  TextField _getVoteTitleTextField() {
    return TextField(
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: [
        LengthLimitingTextInputFormatter(140),
      ],
      decoration: InputDecoration(
        hintText: kAskSomething,
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 20.0,
      ),
    );
  }

  Widget _getOptionsField({String hintText, String id, Color color}) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: selectedOption == id ? color : null,
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          hintText,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
      onTap: () {
        setState(() {
          selectedOption = id;
        });
      },
    );
  }

  Row _getSecretVoteControls() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('My vote is secret'),
        ),
        Switch(
          value: secretVoting,
          onChanged: (value) {
            setState(() {
              secretVoting = value;
            });
          },
          activeTrackColor: Colors.lightBlueAccent,
          activeColor: Colors.blue,
        ),
      ],
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
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  kProjectIcon,
                  size: kIcon_Small,
                  color: Colors.blue,
                ),
                Expanded(
                  child: _getVoteTitleTextField(),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 40.0,
                right: 10.0,
              ),
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  _getOptionsField(hintText: kOption1, id: kOption1, color: kGetColor(0)),
                  kGetOptionsDivider(),
                  _getOptionsField(hintText: kOption2, id: kOption2, color: kGetColor(1)),
                  kGetOptionsDivider(),
                  _getOptionsField(hintText: kOption3, id: kOption3, color: kGetColor(2)),
                  kGetOptionsDivider(),
                  _getOptionsField(hintText: kOption4, id: kOption4, color: kGetColor(3)),
                ],
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            _getSecretVoteControls(),
          ],
        ),
      ),
    );
  }
}
