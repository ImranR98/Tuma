import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuma/screens/upload.dart';
import 'package:tuma/screens/help.dart';
import 'package:tuma/screens/home.dart';
import 'package:tuma/screens/target.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {
  final primaryColor = Colors.red;
  final accentColor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tuma',
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
 - Add screenshots to README
 - Publish to Play store
*/
