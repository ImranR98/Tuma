import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ssh_drop/models/target.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'SSHDropDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Target ('
          'id INTEGER PRIMARY KEY,'
          'name TEXT,'
          'user TEXT,'
          'password TEXT,'
          'privateKey TEXT,'
          'path TEXT'
          ')');
      await db.execute('CREATE TABLE Host ('
          'hostName TEXT,'
          'port INTEGER,'
          'targetId INTEGER,'
          'FOREIGN KEY (targetId) REFERENCES Target(id)'
          ')');
    });
  }

  Future<List<Target>> getAllTargets() async {
    print('Getting all Targets');
    final db = await database;
    List<Map<String, dynamic>> targetMapsRO = await db.query('Target');
    List<Map<String, dynamic>> targetMaps = targetMapsRO
        .map((e) => e.map((key, value) => MapEntry(key, value as dynamic)))
        .toList();
    if (targetMaps.isEmpty) return [];
    for (int i = 0; i < targetMaps.length; i++) {
      targetMaps[i]['hosts'] = await db.query('Host',
          where: 'targetId = ?', whereArgs: [targetMaps[i]['id']]);
    }
    return targetMaps.map((c) => Target.fromMap(c)).toList();
  }

  getTarget(int id) async {
    print('Getting Target $id');
    final db = await database;
    var targetMaps = await db.query('Target', where: 'id = ?', whereArgs: [id]);
    if (targetMaps.isEmpty) return Null;
    var targetMap =
        targetMaps[0].map((key, value) => MapEntry(key, value as dynamic));
    var hostMaps =
        await db.query('Host', where: 'targetId = ?', whereArgs: [id]);
    targetMap['hosts'] = hostMaps;

    var allHosts = await db.query('Host');
    allHosts.forEach((element) {
      print(element);
    });

    return Target.fromMap(targetMap);
  }

  Future<int> newTarget(Target newTarget) async {
    newTarget.id = new Random().nextInt(100000);
    print('Creating Target ${newTarget.id}');
    final db = await database;
    Map<String, dynamic> newT = newTarget.toMap();
    List<dynamic> hosts = newT.remove('hosts');
    await db.insert('Target', newT);
    hosts = hosts.map((e) {
      e['targetId'] = newTarget.id;
      return e;
    }).toList();
    for (int i = 0; i < hosts.length; i++) {
      await db.insert('Host', hosts[i]);
    }
    return newTarget.id;
  }

  updateTarget(Target updatedTarget) async {
    print('Updating Target ${updatedTarget.id}');
    final db = await database;
    Map<String, dynamic> updatedT = updatedTarget.toMap();
    List<dynamic> hosts = updatedT.remove('hosts');
    await db.update('Target', updatedT,
        where: 'id = ?', whereArgs: [updatedTarget.id]);
    await db
        .delete('Host', where: 'targetId = ?', whereArgs: [updatedTarget.id]);
    hosts = hosts.map((e) {
      e['targetId'] = updatedTarget.id;
      return e;
    }).toList();
    for (int i = 0; i < hosts.length; i++) {
      await db.insert('Host', hosts[i]);
    }
    return;
  }

  deleteTarget(int id) async {
    print('Deleting Target $id');
    final db = await database;
    await db.delete('Host', where: 'targetId = ?', whereArgs: [id]);
    await db.delete('Target', where: 'id = ?', whereArgs: [id]);
  }

  deleteAllTargets() async {
    print('Deleting all Targets');
    final db = await database;
    await db.delete('Host');
    await db.delete('Target');
  }

  deleteDB() async {
    print('Deleting Database');
    deleteDatabase(
        join((await getApplicationDocumentsDirectory()).path, 'SSHDropDB.db'));
  }
}
