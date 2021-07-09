import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/Constant/Constant.dart';
import 'package:flutter_chat_ui/Screens/SplashScreen.dart';
import 'package:flutter_chat_ui/Screens/ChatScreen.dart';

main() {
  runApp(new MaterialApp(
    title: 'Fluter',
    debugShowCheckedModeBanner: false,
    theme: new ThemeData(
      accentColor: Colors.blue,
      primaryColor: Colors.white,
      primaryColorDark: Colors.white,
    ),
    home: new MyChatScreen(),
  ));
}
