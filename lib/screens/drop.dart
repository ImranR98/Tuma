import 'package:flutter/material.dart';

class Drop extends StatefulWidget {
  Drop({Key key}) : super(key: key);

  @override
  _DropState createState() => _DropState();
}

class _DropState extends State<Drop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SSH Drop  |  Drop'),
      ),
      body: Column(),
    );
  }
}
