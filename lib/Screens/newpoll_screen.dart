import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loudly/common_widgets.dart';
import 'package:loudly/project_textconstants.dart';

class NewPollScreen extends StatefulWidget {
  static const String id = 'newpoll_screen';

  @override
  _NewPollScreenState createState() => _NewPollScreenState();
}

class _NewPollScreenState extends State<NewPollScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kNewPoll),
      ),
      body: Container(
        padding: const EdgeInsets.all(
          12.0,
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 8.0,
            ),
            TextField(
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              inputFormatters: [
                LengthLimitingTextInputFormatter(140),
              ],
              decoration: InputDecoration(
                labelText: kAskSomething,
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  //borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Divider(
              height: 12.0,
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 20.0,
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
                      fontSize: 12.0,
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
                      fontSize: 12.0,
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
                      fontSize: 12.0,
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
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              onPressed: () {},
              child: Text(
                kCreate,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              color: Colors.blue,
              padding: EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
