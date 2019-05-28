import 'package:flutter/material.dart';
import 'package:loudly/Screens/newcountpoll_screen.dart';
import 'package:loudly/Screens/newgroup_screen.dart';
import 'package:loudly/Screens/newpoll_screen.dart';
import 'package:loudly/Screens/search_screen.dart';
import 'package:loudly/Screens/settings_screen.dart';
import 'package:loudly/project_enums.dart';

import 'package:loudly/project_styles.dart';
import 'package:loudly/project_textconstants.dart';

TextField kUserInputNumberTextField({int maxLen, @required String helperText}) {
  return TextField(
    autofocus: true,
    maxLength: maxLen ?? null,
    style: TextStyle(
      fontSize: kText_Big,
      letterSpacing: 3.0,
    ),
    decoration: InputDecoration(
      helperText: helperText,
    ),
    keyboardType: TextInputType.phone,
    textInputAction: TextInputAction.go,
    textAlign: TextAlign.center,
  );
}

Widget kSearchWidget(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.search),
    onPressed: () {
      Navigator.pushNamed(context, SearchScreen.id);
    },
  );
}

Widget kPopupMenuItem(BuildContext context) {
  return PopupMenuButton(
    icon: Icon(Icons.more_vert),
    itemBuilder: (context) => [
          PopupMenuItem(
            child: Text(kNewPoll),
            value: PopupMenuValue.NewPoll,
          ),
          PopupMenuItem(
              child: Text(kNewCountPoll), value: PopupMenuValue.NewCountPoll),
          PopupMenuItem(
            child: Text(kCreateNewGroup),
            value: PopupMenuValue.CreateNewGroup,
          ),
          PopupMenuItem(
            child: Text(kSettings),
            value: PopupMenuValue.Settings,
          ),
        ],
    onSelected: (PopupMenuValue value) {
      switch (value) {
        case PopupMenuValue.NewPoll:
          Navigator.pushNamed(
            context,
            NewPollScreen.id,
          );
          break;
        case PopupMenuValue.NewCountPoll:
          Navigator.pushNamed(
            context,
            NewCountPollScreen.id,
          );
          break;
        case PopupMenuValue.CreateNewGroup:
          Navigator.pushNamed(
            context,
            NewGroupScreen.id,
          );
          break;
        case PopupMenuValue.Settings:
          Navigator.pushNamed(
            context,
            SettingsScreen.id,
          );
          break;
        default:
      }
    },
  );
}

InputDecoration kGetOptionsInputDecorator(String labelText) {
  return InputDecoration(
    contentPadding: EdgeInsets.all(10.0),
    hintText: labelText,
    hintStyle: TextStyle(
      color: Colors.grey,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      //borderSide: BorderSide.none,
    ),
  );
}

Divider kGetOptionsDivider() {
  return Divider(
    height: 8.0,
  );
}
