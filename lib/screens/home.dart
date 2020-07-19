import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ssh_drop/blocs/targetBloc.dart';
import 'package:ssh_drop/db.dart';
import 'package:ssh_drop/models/target.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SSH Drop'),
      ),
      body: Column(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add Target',
        child: Icon(Icons.add),
      ),
    );
  }
}
