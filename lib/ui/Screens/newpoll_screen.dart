import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:loudly/common_widgets.dart';
import 'package:loudly/project_settings.dart';
import 'package:loudly/project_styles.dart';
import 'package:loudly/project_textconstants.dart';

class NewPollScreen extends StatefulWidget {
  static const String id = 'newpoll_screen';

  @override
  _NewPollScreenState createState() => _NewPollScreenState();
}

class _NewPollScreenState extends State<NewPollScreen> {
  bool canBeShared = true;
  bool resultIsPublic = true;

  AppBar _getAppBar() {
    return AppBar(
      actions: <Widget>[
        FlatButton(
          textColor: Colors.white,
          onPressed: () {},
          child: Text(
            kCreate,
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

  TextField _getOptionsTextField({int index}) {
    return TextField(
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
            'Anyone can share this poll in their groups',
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
            'Everyone can see the poll results',
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
                        child: _getOptionsTextField(index: 0),
                      ),
                    ],
                  ),
                  kGetOptionsDivider(),
                  Row(
                    children: <Widget>[
                      kGetColorBox(index: 1),
                      Flexible(
                        child: _getOptionsTextField(index: 1),
                      ),
                    ],
                  ),
                  kGetOptionsDivider(),
                  Row(
                    children: <Widget>[
                      kGetColorBox(index: 2),
                      Flexible(
                        child: _getOptionsTextField(index: 2),
                      ),
                    ],
                  ),
                  kGetOptionsDivider(),
                  Row(
                    children: <Widget>[
                      kGetColorBox(index: 3),
                      Flexible(
                        child: _getOptionsTextField(index: 3),
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
