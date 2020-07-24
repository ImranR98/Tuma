import 'package:flutter/material.dart';
import 'package:ssh_drop/screens/upload.dart';
import 'package:ssh_drop/screens/help.dart';
import 'package:ssh_drop/screens/home.dart';
import 'package:ssh_drop/screens/target.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final primaryColor = Colors.red;
  final accentColor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SSH Drop',
      theme: ThemeData(primaryColor: primaryColor, accentColor: accentColor),
      darkTheme: ThemeData(
          primaryColor: primaryColor,
          accentColor: accentColor,
          brightness: Brightness.dark),
      routes: {
        '/': (context) => HomePage(),
        '/target': (context) => TargetPage(),
        '/upload': (context) => UploadPage(),
        '/help': (context) => HelpPage(),
      },
    );
  }
}

/* TODO:
 - App icon
*/
