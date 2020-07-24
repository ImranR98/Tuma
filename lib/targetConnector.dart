import 'dart:math';

import 'package:flutter/services.dart';
import 'package:ssh/ssh.dart';
import 'package:ssh_drop/models/target.dart';

class TargetConnector {
  testConnection(Target target) async {
    var connections = new List<SSHClient>();
    target.hosts.forEach((host) {
      connections.add(new SSHClient(
        host: host.hostName,
        port: host.port,
        username: target.user,
        passwordOrKey: target.password.length > 0
            ? target.password
            : {'privateKey': target.privateKey},
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
        if (targetPath.length == 0) throw 'Path does not exist';

        String testDirPath =
            '$targetPath/SSHDrop_TestDir_${Random().nextInt(10000)}';

        String testDir = (await connections[i].execute(
                'mkdir $testDirPath && ls -d $testDirPath && rmdir $testDirPath'))
            .trim();

        if (testDir.length == 0)
          throw 'You don\'t have permission to write to this path';

        success = true;
        hostIndex = i;

        await connections[i].disconnect();
      } on PlatformException catch (err) {
        message = err.message;
      } on String catch (err) {
        message = err;
      }
    }
    if (success) {
      if (target.hosts.length == 1) return 'Connection Successful';
      return 'Connection Successful on ${target.hosts[hostIndex].hostName}';
    } else
      return message;
  }
}
