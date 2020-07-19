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
    stuff();
    super.initState();
  }

  void stuff() async {
    await DBProvider.db.newTarget(new Target(
        id: null,
        name: 'NUCDesktop',
        hosts: [
          new Host(hostName: '192.168.0.18', port: 22),
          new Host(hostName: 'home.imranr.dev', port: 9999)
        ],
        user: 'imranr',
        password: 'zoom4321',
        privateKey: '',
        path: '/home/imranr'));
    var targets = await DBProvider.db.getAllTargets();
    print('START');
    targets.forEach((element) {
      print(element.id);
    });
    print('END');
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
