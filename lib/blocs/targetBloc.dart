import 'dart:async';
import 'package:tuma/db.dart';
import 'package:tuma/models/target.dart';

class TargetBloc {
  final targetController = StreamController<List<Target>>();
  Stream get getTargets => targetController.stream;

  void updateTargets() async {
    targetController.sink.add(await DBProvider.db.getAllTargets());
  }

  add(Target target) async {
    var res = await DBProvider.db.newTarget(target);
    updateTargets();
    return res;
  }

  edit(Target target) async {
    var res = await DBProvider.db.updateTarget(target);
    updateTargets();
    return res;
  }

  delete(int id) async {
    var res = await DBProvider.db.deleteTarget(id);
    updateTargets();
    return res;
  }

  deleteAll() async {
    var res = await DBProvider.db.deleteAllTargets();
    updateTargets();
    return res;
  }

  void dispose() {
    targetController.close();
  }
}

final targetBloc = TargetBloc(); // create an instance of the counter bloc
