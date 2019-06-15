import 'package:flutter/material.dart';

import 'package:loudly/Models/polldata.dart';
import 'package:loudly/project_styles.dart';

class VoteShare extends StatefulWidget {
  final List<Option> pollResultOptions;

  VoteShare({
    Key key,
    @required this.pollResultOptions,
  }) : super(key: key);

  @override
  _VoteShareState createState() => _VoteShareState();
}

class _VoteShareState extends State<VoteShare> {
  bool _isMaxInAllOptions(Option option) {
    for (Option itrOption in widget.pollResultOptions) {
      if ((option.openVotes + option.secretVotes) <
          (itrOption.openVotes + itrOption.secretVotes)) return false;
    }
    return true;
  }

  Widget _getTotalVoteShareForOption({Option option, int index, bool isMax}) {
    return Row(
      children: <Widget>[
        _getColorBox(index: index),
        Text(
          (option.secretVotes + option.openVotes).toString(),
          style: isMax == true
              ? TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                )
              : TextStyle(),
        ),
        SizedBox(
          width: 8.0,
        ),
        isMax == true
            ? Icon(
                Icons.thumb_up,
                color: Colors.yellow,
                size: 20.0,
              )
            : Container(
                height: 0.0,
                width: 0.0,
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

  List<Widget> _getTotalVoteShare() {
    final List<Widget> widgets = [];
    int index = 0;
    for (Option option in widget.pollResultOptions) {
      final bool isMax = _isMaxInAllOptions(option);
      widgets.add(_getTotalVoteShareForOption(
          option: option, index: index, isMax: isMax));
      index++;
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _getTotalVoteShare(),
    );
  }
}
