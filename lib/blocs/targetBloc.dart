import 'dart:async';
import 'package:ssh_drop/db.dart';
import 'package:ssh_drop/models/target.dart';

class TargetBloc {
  TargetBloc() {
    getTargets();
  }
  final _targetController = StreamController<List<Target>>.broadcast();
  get targets => _targetController.stream;

  dispose() {
    _targetController.close();
  }

  getTargets() async {
    _targetController.sink.add(await DBProvider.db.getAllTargets());
  }

  add(Target target) {
    DBProvider.db.newTarget(target);
    getTargets();
  }

  edit(Target target) {
    DBProvider.db.updateTarget(target);
    getTargets();
  }

  delete(int id) {
    DBProvider.db.deleteTarget(id);
    getTargets();
  }

  deleteAll() {
    DBProvider.db.deleteAllTargets();
    getTargets();
  }
}
