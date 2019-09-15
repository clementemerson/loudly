import 'package:flutter/material.dart';
import 'package:loudly/lifecycle_manager.dart';
import 'package:loudly/providers/group_store.dart';
import 'package:loudly/providers/poll_store.dart';
import 'package:loudly/providers/user.dart';
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

void main() async {
  UserStore.store.init();
  PollStore.store.init();
  // GroupStore.store.init();

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
          initialRoute: WelcomeScreen.route,
          routes: {
            WelcomeScreen.route: (context) => WelcomeScreen(),
            GroupPollListScreen.route: (context) => GroupPollListScreen(),
            HomeScreen.route: (context) => HomeScreen(),
            ImagesScreen.route: (context) => ImagesScreen(),
            NewGroupScreen.route: (context) => NewGroupScreen(),
            NewPollScreen.route: (context) => NewPollScreen(),
            PhoneLoginScreen.route: (context) => PhoneLoginScreen(),
            PhoneVerifyScreen.route: (context) => PhoneVerifyScreen(),
            PollResultScreen.route: (context) => PollResultScreen(),
            PollVoteScreen.route: (context) => PollVoteScreen(),
            SearchScreen.route: (context) => SearchScreen(),
            SettingsScreen.route: (context) => SettingsScreen(),
            ShareContentScreen.route: (context) => ShareContentScreen(),
            SetupScreen.route: (context) => SetupScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == GroupParticipantsScreen.route) {
              final List<User> args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return GroupParticipantsScreen(
                    selectedUsers: args,
                  );
                },
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
