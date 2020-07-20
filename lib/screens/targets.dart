import 'package:flutter/material.dart';

class TargetsPage extends StatefulWidget {
  TargetsPage({Key key}) : super(key: key);

  @override
  _TargetsPageState createState() => _TargetsPageState();
}

class _TargetsPageState extends State<TargetsPage> {
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
