import 'package:flutter/material.dart';

import 'package:loudly/Models/polldata.dart';

import 'package:loudly/common_widgets.dart';
import 'package:loudly/project_settings.dart';
import 'package:loudly/project_styles.dart';

class PollVoteScreen extends StatefulWidget {
  static const String id = 'pollvote_screen';

  final int pollId;

  PollVoteScreen({@required this.pollId});

  @override
  _PollVoteScreenState createState() => _PollVoteScreenState();
}

class _PollVoteScreenState extends State<PollVoteScreen> {
  bool secretVoting = false;
  String selectedOption;
  PollData pollData;

  @override
  void initState() {
    super.initState();
  }

  AppBar _getAppBar() {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.reply, textDirection: TextDirection.rtl,),
          onPressed: () {},
        )
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
        pollData.title,
        textAlign: TextAlign.justify,
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
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

  List<Widget> _getAllOptions() {
    final List<Widget> widgets = [];
    int index = 0;
    for (Option option in pollData.options) {
      widgets.add(_getOptionsField(
          optionText: option.desc, index: index, id: index.toString()));
      widgets.add(kGetOptionsDivider());
      index++;
    }
    return widgets;
  }

  Widget _getOptionsField({String optionText, int index, String id}) {
    return Row(
      children: <Widget>[
        _getColorBox(index: index),
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
                      : Container(width: 16.0, height: 16.0),
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

  Widget _getColorBox({int index}) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: kGetOptionColor(index),
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Widget _getVoteButton() {
    return RaisedButton(
      padding: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      textColor: Colors.white,
      disabledTextColor: Colors.grey,
      onPressed: selectedOption == null ? null : () {},
      child: Text(
        'Vote',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    pollData = ModalRoute.of(context).settings.arguments;
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
                children: _getAllOptions(),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            _getSecretVoteControls(),
            SizedBox(
              height: 12.0,
            ),
            _getVoteButton(),
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
