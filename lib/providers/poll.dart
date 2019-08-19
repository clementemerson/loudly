import 'package:flutter/cupertino.dart';

class Poll with ChangeNotifier {
  int pollid;
  String title;
  bool canBeShared;
  bool resultIsPublic;
  int createdBy;
  int createdAt;
  bool voted;

  Poll(
      {@required this.pollid,
      @required this.title,
      @required this.canBeShared,
      @required this.resultIsPublic,
      @required this.createdBy,
      @required this.createdAt,
      @required this.voted});
}
