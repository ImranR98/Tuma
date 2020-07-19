import 'package:flutter/material.dart';
import 'package:ssh_drop/screens/drop.dart';
import 'package:ssh_drop/screens/help.dart';
import 'package:ssh_drop/screens/home.dart';
import 'package:ssh_drop/screens/target.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SSH Drop',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => Home(),
        '/target': (context) => Target(),
        '/drop': (context) => Drop(),
        '/help': (context) => Help(),
      },
    );
  }
}
