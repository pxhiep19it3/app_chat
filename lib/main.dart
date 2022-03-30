import 'dart:io';

import 'package:app_chat/screen/call_screen.dart';
import 'package:app_chat/screen/chat_sceen.dart';
import 'package:app_chat/screen/people_screen.dart';
import 'package:app_chat/screen/setting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const bool USE_EMULATOR = true;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if(USE_EMULATOR){
    _connectToFirebaseEmulator();
  }
  
  runApp(const MyApp());
}

Future _connectToFirebaseEmulator() async {
  final fireStorePort = "8089";
  final authPort = "9099";
  final localHost = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  FirebaseFirestore.instance.settings = Settings(
      host: "$localHost:$fireStorePort",
      sslEnabled: false,
      persistenceEnabled: false);
  await FirebaseAuth.instance.useEmulator("http://$localHost:$authPort");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
          brightness: Brightness.light, primaryColor: Color(0xff5463FF)),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  var screen = [ChatScreen(), CallScreen(), PeopleScreen(), SettingScreen()];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoTabScaffold(
        resizeToAvoidBottomInset: true,
        tabBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
                label: "Chat", icon: Icon(CupertinoIcons.chat_bubble_2_fill)),
            BottomNavigationBarItem(
                label: "Call", icon: Icon(CupertinoIcons.phone)),
            BottomNavigationBarItem(
                label: 'People', icon: Icon(CupertinoIcons.person_alt_circle)),
            BottomNavigationBarItem(
                label: "Setting", icon: Icon(CupertinoIcons.settings_solid))
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return screen[index];
        },
      ),
    );
  }
}
