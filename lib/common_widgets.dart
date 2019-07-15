import 'package:flutter/material.dart';

import 'package:loudly/ui/Screens/newgroup_screen.dart';
import 'package:loudly/ui/Screens/newpoll_screen.dart';
import 'package:loudly/ui/Screens/search_screen.dart';
import 'package:loudly/ui/Screens/settings_screen.dart';
import 'package:loudly/project_enums.dart';

import 'package:loudly/project_styles.dart';
import 'package:loudly/project_textconstants.dart';

TextField kUserInputTextField(
    {int maxLen,
    @required String helperText,
    double fontSize,
    TextInputType keyboardType,
    ValueChanged<String> onChanged,
    TextEditingController controller}) {
  return TextField(
    controller: controller,
    autofocus: true,
    maxLength: maxLen ?? null,
    style: TextStyle(
      fontSize: fontSize ?? kText_Big,
      letterSpacing: 3.0,
    ),
    decoration: InputDecoration(
      helperText: helperText,
    ),
    keyboardType: keyboardType ?? TextInputType.phone,
    textInputAction: TextInputAction.go,
    textAlign: TextAlign.center,
    onChanged: onChanged,
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

Widget kMainScreenPopupMenu(BuildContext context) {
  return PopupMenuButton(
    icon: Icon(Icons.more_vert),
    itemBuilder: (context) => [
          PopupMenuItem(
            child: Text(newPoll),
            value: PopupMenuValue.NewPoll,
          ),
          // PopupMenuItem(
          //     child: Text(kNewCountPoll), value: PopupMenuValue.NewCountPoll),
          PopupMenuItem(
            child: Text(createNewGroup),
            value: PopupMenuValue.CreateNewGroup,
          ),
          PopupMenuItem(
            child: Text(settings),
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
        // case PopupMenuValue.NewCountPoll:
        //   Navigator.pushNamed(
        //     context,
        //     NewCountPollScreen.id,
        //   );
        //   break;
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

Widget kGroupScreenPopupMenu(BuildContext context) {
  return PopupMenuButton(
    icon: Icon(Icons.more_vert),
    itemBuilder: (context) => [
          PopupMenuItem(
            child: Text(newPoll),
            value: PopupMenuValue.NewPoll,
          ),
          // PopupMenuItem(
          //     child: Text(kNewCountPoll), value: PopupMenuValue.NewCountPoll),
          PopupMenuItem(
            child: Text(editGroup),
            value: PopupMenuValue.EditGroup,
          ),
          PopupMenuItem(
            child: Text(settings),
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
        // case PopupMenuValue.NewCountPoll:
        //   Navigator.pushNamed(
        //     context,
        //     NewCountPollScreen.id,
        //   );
        //   break;
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

InputDecoration kGetOptionsInputDecorator(String hintText) {
  return InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: Colors.blue,
      ),
    ),
    contentPadding: EdgeInsets.all(12.0),
    hintText: hintText,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );
}

Divider kGetOptionsDivider() {
  return Divider(
    height: 8.0,
  );
}

Widget kGetColorBox({int index}) {
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
