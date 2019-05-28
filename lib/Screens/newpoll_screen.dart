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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
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
                  child: TextField(
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
                  ),
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
                  TextField(
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25),
                    ],
                    decoration: kGetOptionsInputDecorator(kOption1),
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  kGetOptionsDivider(),
                  TextField(
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25),
                    ],
                    decoration: kGetOptionsInputDecorator(kOption2),
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  kGetOptionsDivider(),
                  TextField(
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25),
                    ],
                    decoration: kGetOptionsInputDecorator(kOption3),
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  kGetOptionsDivider(),
                  TextField(
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25),
                    ],
                    decoration: kGetOptionsInputDecorator(kOption4),
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text('Anyone can share this poll in their groups'),
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
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text('Everyone can see the poll results'),
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
            ),
          ],
        ),
      ),
    );
  }
}
