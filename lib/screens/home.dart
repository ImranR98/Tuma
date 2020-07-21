import 'package:flutter/material.dart';
import 'package:ssh_drop/blocs/targetBloc.dart';
import 'package:ssh_drop/models/target.dart';
import 'package:ssh_drop/screens/target.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    targetBloc.updateTargets();
  }

  @override
  void dispose() {
    targetBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SSH Drop'),
      ),
      body: StreamBuilder<List<Target>>(
        stream: targetBloc.getTargets,
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return Center(
              child: Text(
                'Loading',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
                textScaleFactor: 1.5,
              ),
            );
          else if (snapshot.data.length == 0)
            return Center(
              child: Text(
                'No Targets',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
                textScaleFactor: 1.5,
              ),
            );
          else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_left,
                        color: Colors.grey[700],
                      ),
                      Text(
                        'Swipe',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Icon(
                        Icons.arrow_right,
                        color: Colors.grey[700],
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: new Key(UniqueKey().toString()),
                        confirmDismiss: (DismissDirection dir) async {
                          if (dir == DismissDirection.startToEnd) {
                            var res = await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Delete Target'),
                                    content:
                                        Text('${snapshot.data[index].name}'),
                                    actions: [
                                      FlatButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('Delete'),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                    ],
                                  );
                                });
                            return res;
                          } else {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TargetPage(
                                      existingTarget: snapshot.data[index]),
                                ));
                            targetBloc.updateTargets();
                            return false;
                          }
                        },
                        onDismissed: (dir) async {
                          await targetBloc.delete(snapshot.data[index].id);
                          setState(() {
                            snapshot.data.removeAt(index);
                          });
                        },
                        child: ListTile(
                            title: Text('${snapshot.data[index].name}')),
                        background: Container(
                          color: Colors.red,
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        secondaryBackground: Container(
                          color: Colors.blue,
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Edit',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TargetPage(existingTarget: null),
              ));
          targetBloc.updateTargets();
        },
        tooltip: 'Add Target',
        child: Icon(Icons.add),
      ),
    );
  }
}
