import 'package:flutter/material.dart';

class DropPage extends StatefulWidget {
  DropPage({Key key}) : super(key: key);

  @override
  _DropPageState createState() => _DropPageState();
}

class _DropPageState extends State<DropPage> {
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
