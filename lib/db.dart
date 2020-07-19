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
    String path = join(documentsDirectory.path, "TargetDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Target ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "user TEXT,"
          "password TEXT,"
          "privateKey TEXT,"
          "path TEXT"
          ")");
      await db.execute("CREATE TABLE Host ("
          "id INTEGER PRIMARY KEY,"
          "hostName TEXT,"
          "port INTEGER,"
          "targetId INTEGER,"
          "FOREIGN KEY (targetId) REFERENCES Target(id)"
          ")");
    });
  }

  deleteDB() async {
    deleteDatabase(
        join((await getApplicationDocumentsDirectory()).path, "TargetDB.db"));
  }

  Future<List<Target>> getAllTargets() async {
    final db = await database;
    var targetMapsRO = await db.query("Target");
    var targetMaps = targetMapsRO.map((e) => Map.from(e)).toList();
    if (targetMaps.isEmpty) return [];
    for (int i = 0; i < targetMaps.length; i++) {
      targetMaps[i]["hosts"] = await db.query("Host",
          where: "targetId = ?", whereArgs: [targetMaps[i]["id"]]);
    }
    return targetMaps.map((c) => Target.fromMap(c)).toList();
  }

  getTarget(int id) async {
    final db = await database;
    var targetMaps = await db.query("Target", where: "id = ?", whereArgs: [id]);
    if (targetMaps.isEmpty) return Null;
    var targetMap = targetMaps[0];
    var hostMaps =
        await db.query("Host", where: "targetId = ?", whereArgs: [id]);
    targetMap["hosts"] = hostMaps;
    return Target.fromMap(targetMap);
  }

  newTarget(Target newTarget) async {
    newTarget.id = new Random().nextInt(100000);
    final db = await database;
    Map<String, dynamic> newT = newTarget.toMap();
    List<dynamic> hosts = newT.remove("hosts");
    await db.insert("Target", newT);
    for (int i = 0; i < hosts.length; i++) {
      await db.insert("Host", hosts[i]);
    }
    return;
  }

  updateTarget(Target updatedTarget) async {
    final db = await database;
    Map<String, dynamic> updatedT = updatedTarget.toMap();
    List<Host> hosts = updatedT.remove("hosts");
    await db.update("Target", updatedTarget.toMap(),
        where: "id = ?", whereArgs: [updatedTarget.id]);
    await db
        .delete("Host", where: "targetId = ?", whereArgs: [updatedTarget.id]);
    for (int i = 0; i < hosts.length; i++) {
      await db.insert("Host", hosts[i].toMap());
    }
    return;
  }

  deleteTarget(int id) async {
    final db = await database;
    await db.delete("Host", where: "targetId = ?", whereArgs: [id]);
    await db.delete("Target", where: "id = ?", whereArgs: [id]);
  }

  deleteAllTargets() async {
    final db = await database;
    await db.delete("Host");
    await db.delete("Target");
  }
}
