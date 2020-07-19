import 'package:flutter/material.dart';

class Target extends StatefulWidget {
  Target({Key key}) : super(key: key);

  @override
  _TargetState createState() => _TargetState();
}

class _TargetState extends State<Target> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SSH Drop  |  Target'),
      ),
      body: Column(),
    );
  }
}
