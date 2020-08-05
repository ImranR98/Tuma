import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:ssh/ssh.dart';
import 'package:tuma/models/target.dart';

class TargetConnector {
  testConnection(Target target) async {
    // Generate a list of SSH connections based on the hosts
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

    // Try connecting to each host and store the index of the first one that works
    int hostIndex = 0;
    bool connected = false;
    String error;
    for (int i = 0; i < connections.length && !connected; i++) {
      try {
        await (connections[i].connect()).timeout(Duration(seconds: 5));
        connected = true;
        hostIndex = i;
      } on PlatformException catch (err) {
        if (err.code == 'connection_failure')
          error = 'Connection or Authentication Error.';
        else
          error = err.message;
      } on TimeoutException catch (err) {
        error =
            'Took too long to connect - more than ${err.duration.inSeconds} seconds.';
      }
    }
    if (!connected) throw error;

    // Make sure that the specified path exists and that you have read/write permission
    try {
      String targetPath =
          (await connections[hostIndex].execute('cd / && ls -d ${target.path}'))
              .trim();
      if (targetPath.length == 0) throw 'Path does not exist.';

      String testDirPath =
          '$targetPath/Tuma_TestDir_${Random().nextInt(10000)}';

      String testDir = (await connections[hostIndex].execute(
              'mkdir $testDirPath && ls -d $testDirPath && rmdir $testDirPath'))
          .trim();
      if (testDir.length == 0)
        throw 'You don\'t have permission to write to this path.';
      await connections[hostIndex].disconnect();
    } on String catch (err) {
      await connections[hostIndex].disconnect();
      throw err;
    }

    // If you made it this far without throwing an error, you have found and validated a host. Return it's index
    return hostIndex;
  }

  Future<List<String>> uploadFiles(
      Target target, List<String> filePaths, Function callback) async {
    try {
      // Make sure at least one of the hosts is valid, and find it's index, using the testConnection function above
      int hostIndex = await testConnection(target);
      var connection = new SSHClient(
          host: target.hosts[hostIndex].hostName.trim(),
          port: target.hosts[hostIndex].port,
          username: target.user.trim(),
          passwordOrKey: target.password.length > 0
              ? target.password.trim()
              : {'privateKey': target.privateKey.trim()});

      // Find the absolute path (in case the user provided a relative to home path)
      await connection.connect();
      String targetPath =
          (await connection.execute('cd / && ls -d ${target.path}')).trim();

      // All validation so far used SSH. Connect with SFTP to do the actual upload
      await connection.connectSFTP();

      // Upload the files and add the results to a list, (after each upload, call a callback function)
      List<String> results = new List<String>();

      for (int i = 0; i < filePaths.length; i++) {
        results.add(await connection.sftpUpload(
            path: filePaths[i].trim(), toPath: targetPath, callback: callback));
      }

      // Disconnect on SFTP and SSH
      connection.disconnectSFTP();
      connection.disconnect();

      // Return the result array
      return results;
    } on PlatformException catch (err) {
      if (err.code == 'connection_failure')
        throw 'Connection or Authentication Error.';
      else
        throw err.message;
    }
  }
}
