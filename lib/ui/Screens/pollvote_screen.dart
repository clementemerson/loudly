import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import 'package:loudly/common_widgets.dart';
import 'package:loudly/project_settings.dart';
import 'package:loudly/project_styles.dart';
import 'package:loudly/project_textconstants.dart';

class PollVoteScreen extends StatefulWidget {
  static const String id = 'pollvote_screen';

  final int pollId;

  PollVoteScreen({@required this.pollId});

  @override
  _PollVoteScreenState createState() => _PollVoteScreenState();
}

class _PollVoteScreenState extends State<PollVoteScreen> {
  bool secretVoting = false;
  String selectedOption = null;

  Poll pollData = Poll(
      id: 0,
      pollTitle: 'Ask Something',
      option1: '',
      option2: '',
      option3: '',
      option4: '');

  @override
  void initState() {
    getPollData();

    super.initState();
  }

  getPollData() async {
    List<String> urls = [];
    urls.add('https://my.api.mockaroo.com/polldata.json?key=17d9cc40');
    urls.add('https://my.api.mockaroo.com/polldata.json?key=3b82acd0');
    urls.add('https://my.api.mockaroo.com/polldata.json?key=873a3a70');

    http.Response response;
    for (var url in urls) {
      response = await http.get(url);
      if (response.statusCode == 200) {
        break;
      }
    }

    try {
      if (response.statusCode == 200) {
        String pollDataCollection = response.body;
        var jsonPollData = jsonDecode(pollDataCollection);
        if (this.mounted == true) {
          setState(() {
            print(jsonPollData);
            print(pollData.option1);
            pollData.pollTitle = jsonPollData['polltitle'];
            pollData.option1 = jsonPollData['option1'];
            pollData.option2 = jsonPollData['option2'];
            pollData.option3 = jsonPollData['option3'];
            pollData.option4 = jsonPollData['option4'];
          });
          print(pollData.option1);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  AppBar _getAppBar() {
    return AppBar(
      actions: <Widget>[
        FlatButton(
          textColor: Colors.blue,
          disabledTextColor: Colors.grey,
          onPressed: selectedOption == null ? null : () {},
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

  Widget _getVoteTitleTextField() {
    return Container(
      padding: EdgeInsets.only(
        left: 12.0,
        right: 12.0,
      ),
      child: Text(
        pollData.pollTitle,
        textAlign: TextAlign.justify,
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _getOptionsField({String optionText, int index, String id}) {
    return Row(
      children: <Widget>[
        kGetColorBox(index: index),
        Expanded(
          child: InkWell(
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: selectedOption == id
                    ? Border.all(color: Colors.blueAccent)
                    : Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      optionText,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  selectedOption == id
                      ? Icon(
                          Icons.done,
                          color: Colors.blueAccent,
                          size: 16.0,
                        )
                      : Container(width: 0, height: 0),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                selectedOption = id;
              });
            },
          ),
        ),
      ],
    );
  }

  Row _getSecretVoteControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Secret Voting',
          style: TextStyle(
            fontSize: 16.0,
          ),
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
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 8.0,
              ),
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  _getOptionsField(
                      optionText: pollData.option1, index: 0, id: kOption1),
                  kGetOptionsDivider(),
                  _getOptionsField(
                      optionText: pollData.option2, index: 1, id: kOption2),
                  kGetOptionsDivider(),
                  _getOptionsField(
                      optionText: pollData.option3, index: 2, id: kOption3),
                  kGetOptionsDivider(),
                  _getOptionsField(
                      optionText: pollData.option4, index: 3, id: kOption4),
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

class Poll {
  int id;
  String pollTitle;
  String option1;
  String option2;
  String option3;
  String option4;

  Poll(
      {this.id,
      this.pollTitle,
      this.option1,
      this.option2,
      this.option3,
      this.option4});
}
