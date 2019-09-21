import 'package:flutter/material.dart';
import 'package:loudly/project_enums.dart';
import 'package:loudly/providers/user.dart';
import 'package:loudly/resources/phone_services/contacts_helper.dart';
import 'package:provider/provider.dart';

class ContactTile extends StatelessWidget {
  final ListAction actionRequired;
  final bool isSelected;
  final String searchText;
  final Function onTap;

  ContactTile({
    @required this.actionRequired,
    @required this.isSelected,
    @required this.searchText,
    this.onTap,
  });

  Widget _myWidget(BuildContext context, String myString, String wordToStyle) {
    if (wordToStyle.isNotEmpty) {
      final style = TextStyle(color: Colors.blue);
      final spans = _getSpans(myString, wordToStyle, style);

      return RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16),
          children: spans,
        ),
      );
    } else {
      return Text(
        myString,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16),
      );
    }
  }

  List<TextSpan> _getSpans(String text, String matchWord, TextStyle style) {
    List<TextSpan> spans = [];
    int spanBoundary = 0;

    do {
      // look for the next match
      final startIndex = text.indexOf(matchWord, spanBoundary);

      // if no more matches then add the rest of the string without style
      if (startIndex == -1) {
        spans.add(TextSpan(text: text.substring(spanBoundary)));
        return spans;
      }

      // add any unstyled text before the next match
      if (startIndex > spanBoundary) {
        spans.add(TextSpan(text: text.substring(spanBoundary, startIndex)));
      }

      // style the matched text
      final endIndex = startIndex + matchWord.length;
      final spanText = text.substring(startIndex, endIndex);
      spans.add(TextSpan(text: spanText, style: style));

      // mark the boundary to start the next search from
      spanBoundary = endIndex;

      // continue until there are no more matches
    } while (spanBoundary < text.length);

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    String userName = ContactsHelper.getUserNameInPhone(user.phoneNumber);
    if (userName == null) userName = user.displayName;

    return ListTile(
      title: _myWidget(context, userName, searchText),
      subtitle: Text(
        '${user.statusMsg}',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: actionRequired == ListAction.Select
          ? Checkbox(
              value: isSelected,
              onChanged: (value) {},
            )
          : Container(
              width: 0,
              height: 0,
            ),
      onTap: actionRequired == ListAction.Select
          ? () {
              if (onTap != null) onTap();
            }
          : null,
    );
  }
}
