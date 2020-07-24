import 'dart:math';

import 'package:flutter/services.dart';
import 'package:ssh/ssh.dart';
import 'package:ssh_drop/models/target.dart';

class TargetConnector {
  testConnection(Target target) async {
    var connections = new List<SSHClient>();
    target.hosts.forEach((host) {
      connections.add(new SSHClient(
        host: host.hostName.trim(),
        port: host.port,
        username: target.user.trim(),
        passwordOrKey: target.password.length > 0
            ? target.password.trim()
            : {'privateKey': target.privateKey.trim()},
      ));
    });

    bool success = false;
    String message;
    int hostIndex = 0;
    for (int i = 0; i < connections.length && success == false; i++) {
      try {
        await connections[i].connect();

        String targetPath =
            (await connections[i].execute('cd / && ls -d ${target.path}'))
                .trim();
        if (targetPath.length == 0) throw 'Path does not exist.';

        String testDirPath =
            '$targetPath/SSHDrop_TestDir_${Random().nextInt(10000)}';

        String testDir = (await connections[i].execute(
                'mkdir $testDirPath && ls -d $testDirPath && rmdir $testDirPath'))
            .trim();

        if (testDir.length == 0)
          throw 'You don\'t have permission to write to this path.';

        success = true;
        hostIndex = i;

        await connections[i].disconnect();
      } on PlatformException catch (err) {
        if (err.code == 'connection_failure')
          message = 'Connection or Authentication Error.';
        else
          message = err.message;
      } on String catch (err) {
        message = err;
      }
    }
    if (success) return hostIndex;
    throw message;
  }

  Future<List<String>> uploadFiles(
      Target target, List<String> filePaths, Function callback) async {
    try {
      int hostIndex = await testConnection(target);
      var connection = new SSHClient(
          host: target.hosts[hostIndex].hostName.trim(),
          port: target.hosts[hostIndex].port,
          username: target.user.trim(),
          passwordOrKey: target.password.length > 0
              ? target.password.trim()
              : {'privateKey': target.privateKey.trim()});
      await connection.connect();
      String targetPath =
          (await connection.execute('cd / && ls -d ${target.path}')).trim();

      await connection.connectSFTP();

      List<String> results = new List<String>();

      for (int i = 0; i < filePaths.length; i++) {
        results.add(await connection.sftpUpload(
            path: filePaths[i].trim(), toPath: targetPath, callback: callback));
      }

      connection.disconnectSFTP();
      connection.disconnect();

      return results;
    } on PlatformException catch (err) {
      if (err.code == 'connection_failure')
        throw 'Connection or Authentication Error.';
      else
        throw err.message;
    }
  }
}
