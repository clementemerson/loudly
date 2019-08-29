import 'package:flutter/material.dart';
import 'package:loudly/lifecycle_manager.dart';
import 'package:loudly/providers/group_store.dart';
import 'package:loudly/providers/poll_store.dart';
import 'package:loudly/providers/user_store.dart';
import 'package:loudly/ui/Screens/setup_screen.dart';

import 'package:loudly/ui/Screens/grouppolllist_screen.dart';
import 'package:loudly/ui/Screens/groupparticipants_screen.dart';
import 'package:loudly/ui/Screens/home_screen.dart';
import 'package:loudly/ui/Screens/images_screen.dart';
import 'package:loudly/ui/Screens/newgroup_screen.dart';
import 'package:loudly/ui/Screens/newpoll_screen.dart';
import 'package:loudly/ui/Screens/phonelogin_screen.dart';
import 'package:loudly/ui/Screens/phoneverify_screen.dart';
import 'package:loudly/ui/Screens/pollresult_screen.dart';
import 'package:loudly/ui/Screens/pollvote_screen.dart';
import 'package:loudly/ui/Screens/search_screen.dart';
import 'package:loudly/ui/Screens/settings_screen.dart';
import 'package:loudly/ui/Screens/sharecontent_screen.dart';
import 'package:loudly/ui/Screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget with WidgetsBindingObserver {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: PollStore.store),
        ChangeNotifierProvider.value(value: GroupStore.store),
        ChangeNotifierProvider.value(value: UserStore.store),
      ],
      child: LifeCycleManager(
        child: MaterialApp(
          title: 'Loudly',
          theme: ThemeData.dark(),
          initialRoute: WelcomeScreen.id,
          routes: {
            WelcomeScreen.id: (context) => WelcomeScreen(),
            GroupPollListScreen.id: (context) => GroupPollListScreen(),
            GroupParticipantsScreen.id: (context) => GroupParticipantsScreen(),
            HomeScreen.id: (context) => HomeScreen(),
            ImagesScreen.id: (context) => ImagesScreen(),
            NewGroupScreen.id: (context) => NewGroupScreen(),
            NewPollScreen.id: (context) => NewPollScreen(),
            PhoneLoginScreen.id: (context) => PhoneLoginScreen(),
            PhoneVerifyScreen.id: (context) => PhoneVerifyScreen(),
            PollResultScreen.id: (context) => PollResultScreen(),
            PollVoteScreen.id: (context) => PollVoteScreen(),
            SearchScreen.id: (context) => SearchScreen(),
            SettingsScreen.id: (context) => SettingsScreen(),
            ShareContentScreen.id: (context) => ShareContentScreen(),
            SetupScreen.id: (context) => SetupScreen(),
          },
        ),
      ),
    );
  }
}
