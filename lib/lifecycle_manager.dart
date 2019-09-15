import 'package:flutter/material.dart';
import 'package:loudly/project_textconstants.dart';
import 'package:loudly/resources/phone_services/secure_storage.dart';
import 'package:loudly/resources/ws/websocket.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  LifeCycleManager({Key key, this.child}) : super(key: key);
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('state = $state');
    if (state == AppLifecycleState.resumed &&
        WebSocketHelper().connectionEstablished == false) {
      final String token = await SecureStorage().read(key: jwtToken);
      WebSocketHelper().initConnection(token: token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}
