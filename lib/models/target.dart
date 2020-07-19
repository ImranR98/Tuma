// Partially generated using https://app.quicktype.io/#l=dart//

import 'dart:convert';

Target targetFromJson(String str) => Target.fromMap(json.decode(str));

String targetToJson(Target data) => json.encode(data.toMap());

class Target {
  Target({
    this.id,
    this.name,
    this.hosts,
    this.user,
    this.password,
    this.privateKey,
    this.path,
  });

  int id;
  String name;
  List<Host> hosts;
  String user;
  String password;
  String privateKey;
  String path;

  factory Target.fromMap(Map<String, dynamic> json) => Target(
        id: json["id"],
        name: json["name"],
        hosts: List<Host>.from(json["hosts"].map((x) => Host.fromMap(x))),
        user: json["user"],
        password: json["password"],
        privateKey: json["privateKey"],
        path: json["path"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "hosts": List<dynamic>.from(hosts.map((x) => x.toMap())),
        "user": user,
        "password": password,
        "privateKey": privateKey,
        "path": path,
      };
}

class Host {
  Host({
    this.hostName,
    this.port,
  });

  String hostName;
  int port;

  factory Host.fromMap(Map<String, dynamic> json) => Host(
        hostName: json["hostName"],
        port: json["port"],
      );

  Map<String, dynamic> toMap() => {
        "hostName": hostName,
        "port": port,
      };
}
