import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:loudly/common_widgets.dart';
import 'package:loudly/models/polldata.dart';
import 'package:loudly/project_settings.dart';
import 'package:loudly/project_styles.dart';
import 'package:loudly/project_textconstants.dart';
import 'package:loudly/resources/ws/event_handlers/pollmodule.dart';

class NewPollScreen extends StatefulWidget {
  static const String id = 'newpoll_screen';
  static const String canShareThisPoll = 'Anyone can share this poll in their groups';
  static const String pollResultIsPublic = 'Everyone can see the poll results';

  @override
  _NewPollScreenState createState() => _NewPollScreenState();
}

class _NewPollScreenState extends State<NewPollScreen> {
  bool canBeShared = true;
  bool resultIsPublic = true;

  final pollTitleController = TextEditingController();
  final pollOption1Controller = TextEditingController();
  final pollOption2Controller = TextEditingController();
  final pollOption3Controller = TextEditingController();
  final pollOption4Controller = TextEditingController();

  AppBar _getAppBar() {
    return AppBar(
      actions: <Widget>[
        FlatButton(
          textColor: Colors.white,
          onPressed: () {
            List<PollOption> pollOptions = [
              PollOption(optionindex: 0, desc: pollOption1Controller.text),
              PollOption(optionindex: 1, desc: pollOption2Controller.text),
              PollOption(optionindex: 2, desc: pollOption3Controller.text),
              PollOption(optionindex: 3, desc: pollOption4Controller.text)
            ];
            PollData pollData = PollData(
                title: pollTitleController.text,
                canBeShared: this.canBeShared,
                resultIsPublic: this.resultIsPublic,
                options: pollOptions);

            WSPollsModule.create(pollData, callback: () {
              print('poll was created');
              Navigator.pop(context);
            });
          },
          child: Text(
            createPoll,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  TextField _getVoteTitleTextField({TextEditingController controller}) {
    return TextField(
      controller: controller,
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: [
        LengthLimitingTextInputFormatter(140),
      ],
      decoration: InputDecoration(
        hintText: askSomething,
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

  TextField _getOptionsTextField(
      {int index, TextEditingController controller}) {
    return TextField(
      controller: controller,
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: [
        LengthLimitingTextInputFormatter(25),
      ],
      decoration: kGetOptionsInputDecorator(kGetOptionText(index)),
      style: TextStyle(
        fontSize: 16.0,
      ),
    );
  }

  Row _getShareControls() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            NewPollScreen.canShareThisPoll,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        Switch(
          value: canBeShared,
          onChanged: (value) {
            setState(() {
              canBeShared = value;
            });
          },
          activeTrackColor: Colors.lightBlueAccent,
          activeColor: Colors.blue,
        ),
      ],
    );
  }

  Row _getPublicResultControls() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            NewPollScreen.pollResultIsPublic,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        Switch(
          value: resultIsPublic,
          onChanged: (value) {
            setState(() {
              resultIsPublic = value;
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
                  projectIcon,
                  size: kIcon_Small,
                  color: Colors.blue,
                ),
                Expanded(
                  child:
                      _getVoteTitleTextField(controller: pollTitleController),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 8.0,
              ),
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      kGetColorBox(index: 0),
                      Flexible(
                        child: _getOptionsTextField(
                            index: 0, controller: pollOption1Controller),
                      ),
                    ],
                  ),
                  kGetOptionsDivider(),
                  Row(
                    children: <Widget>[
                      kGetColorBox(index: 1),
                      Flexible(
                        child: _getOptionsTextField(
                            index: 1, controller: pollOption2Controller),
                      ),
                    ],
                  ),
                  kGetOptionsDivider(),
                  Row(
                    children: <Widget>[
                      kGetColorBox(index: 2),
                      Flexible(
                        child: _getOptionsTextField(
                            index: 2, controller: pollOption3Controller),
                      ),
                    ],
                  ),
                  kGetOptionsDivider(),
                  Row(
                    children: <Widget>[
                      kGetColorBox(index: 3),
                      Flexible(
                        child: _getOptionsTextField(
                            index: 3, controller: pollOption4Controller),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            _getShareControls(),
            _getPublicResultControls(),
          ],
        ),
      ),
    );
  }
}
