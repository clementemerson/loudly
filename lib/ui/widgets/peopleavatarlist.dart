import 'package:flutter/material.dart';
import 'package:loudly/providers/user.dart';

class PeopleAvatarList extends StatelessWidget {
  const PeopleAvatarList({
    Key key,
    @required List<User> selectedUsers,
  })  : _selectedUsers = selectedUsers,
        super(key: key);

  final List<User> _selectedUsers;

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
          itemCount: _selectedUsers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: CircleAvatar(
                backgroundColor: Colors.brown.shade200,
                child: Text(_selectedUsers[index].displayName[0]),
              ),
            );
          }),
    );
  }
}
