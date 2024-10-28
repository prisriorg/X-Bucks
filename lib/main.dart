import 'package:flutter/material.dart';
import 'package:xbucks/pages/ball_page.dart';
import 'package:xbucks/pages/login_page.dart';
import 'package:xbucks/theme/dark_mode.dart';
import 'package:xbucks/theme/light_mode.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Xbucks',
      theme: lightMode,
      darkTheme: darkMode,
      home: const LoginPage(),
      // home: const BallPage(
      //     time: 30,
      //     speed: 200,
      //     ball: 9,
      //     shake: 5) // LoginPage(), //BallPage(time: 33, speed: 200, ball: 9),
    );
  }
}
