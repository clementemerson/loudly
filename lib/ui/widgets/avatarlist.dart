import 'package:flutter/material.dart';

class AvatarList extends StatelessWidget {
  const AvatarList({
    Key key,
    @required List<String> texts,
  })  : _texts = texts,
        super(key: key);

  final List<String> _texts;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => Divider(
                height: 4.0,
                color: Colors.grey,
              ),
          itemCount: _texts.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: CircleAvatar(
                backgroundColor: Colors.brown.shade200,
                child: Text(_texts[index][0]),
              ),
            );
          }),
    );
  }
}
