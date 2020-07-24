import 'package:flutter/material.dart';
import 'package:tuma/models/target.dart';
import 'package:tuma/blocs/targetBloc.dart';
import 'package:tuma/targetConnector.dart';

class TargetPage extends StatefulWidget {
  final Target existingTarget;
  TargetPage({Key key, this.existingTarget}) : super(key: key);

  @override
  _TargetPageState createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  Target target;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final privatekeyController = TextEditingController();
  final pathController = TextEditingController();
  List<Map<String, TextEditingController>> hostAndPortControllers =
      new List<Map<String, TextEditingController>>();

  bool disabled = false;

  getTargetFromForm() {
    return new Target(
        id: this.target.id,
        name: nameController.text.trim(),
        user: usernameController.text.trim(),
        password: passwordController.text.trim(),
        privateKey: privatekeyController.text.trim(),
        path: pathController.text.trim(),
        hosts: hostAndPortControllers
            .map((e) => new Host(
                hostName: e['host'].text.trim(),
                port: int.parse(e['port'].text.trim())))
            .toList());
  }

  isFormValid() {
    if (_formKey.currentState == null) return false;
    return _formKey.currentState.validate() &&
        this.hostAndPortControllers.length > 0;
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    privatekeyController.dispose();
    pathController.dispose();
    hostAndPortControllers.forEach((hostAndPortController) {
      hostAndPortController['host'].dispose();
      hostAndPortController['port'].dispose();
    });
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.existingTarget != null)
      this.target = widget.existingTarget;
    else
      this.target = new Target();

    this.nameController.text = this.target.name != null ? this.target.name : '';
    this.usernameController.text =
        this.target.user != null ? this.target.user : '';
    this.passwordController.text =
        this.target.password != null ? this.target.password : '';
    this.privatekeyController.text =
        this.target.privateKey != null ? this.target.privateKey : '';
    this.pathController.text = this.target.path != null ? this.target.path : '';
    if (this.target.hosts == null) this.target.hosts = new List<Host>();
    this.target.hosts.forEach((host) {
      this.hostAndPortControllers.add({
        'host': new TextEditingController(text: host.hostName),
        'port': new TextEditingController(text: host.port.toString())
      });
    });
    if (this.hostAndPortControllers.length == 0)
      this.hostAndPortControllers.add({
        'host': new TextEditingController(text: ''),
        'port': new TextEditingController(text: '')
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tuma  |  ${target.id != null ? "Edit" : "Add"} Target'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            enabled: !this.disabled,
                            decoration:
                                InputDecoration(labelText: 'Target Name'),
                            controller: nameController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a Name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            enabled: !this.disabled,
                            decoration: InputDecoration(labelText: 'Username'),
                            controller: usernameController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a Username';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            enabled: !this.disabled,
                            obscureText: true,
                            decoration: InputDecoration(labelText: 'Password'),
                            controller: passwordController,
                            autocorrect: false,
                            validator: (value) {
                              if (value.isEmpty &&
                                  privatekeyController.text.isEmpty) {
                                return 'Please enter a Password or Private Key';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            enabled: !this.disabled,
                            decoration: InputDecoration(
                                labelText:
                                    'Private Key ${privatekeyController.text.isEmpty && passwordController.text.isNotEmpty ? " - Not Used" : ""}'),
                            controller: privatekeyController,
                            validator: (value) {
                              if (value.isEmpty &&
                                  passwordController.text.isEmpty) {
                                return 'Please enter a Private Key or Password';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            enabled: !this.disabled,
                            decoration: InputDecoration(labelText: 'Path'),
                            controller: pathController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a Path';
                              }
                              return null;
                            },
                          ),
                          Column(
                              children: this.hostAndPortControllers.map((e) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    enabled: !this.disabled,
                                    decoration:
                                        InputDecoration(labelText: 'Host'),
                                    controller: e['host'],
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter a Host URL or IP';
                                      }
                                      if (!value.contains('.')) {
                                        return 'Please enter a valid URL or IP';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    enabled: !this.disabled,
                                    decoration:
                                        InputDecoration(labelText: 'Port'),
                                    controller: e['port'],
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter a Port';
                                      }
                                      try {
                                        var number = num.parse(value);
                                        if (number is double)
                                          return 'Please enter a whole number';
                                      } catch (err) {
                                        return 'Please enter a number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              Row(
                                children: [
                                  Visibility(
                                      visible:
                                          this.hostAndPortControllers.length >
                                              1,
                                      child: FlatButton(
                                        onPressed: this.disabled
                                            ? null
                                            : () {
                                                setState(() {
                                                  this
                                                      .hostAndPortControllers
                                                      .removeLast();
                                                });
                                              },
                                        child: Text('Remove Alternative Host'),
                                      )),
                                  Visibility(
                                    visible:
                                        this.hostAndPortControllers.length <= 1,
                                    child: FlatButton(
                                      onPressed: this.disabled
                                          ? null
                                          : () {
                                              setState(() {
                                                this
                                                    .hostAndPortControllers
                                                    .add({
                                                  'host':
                                                      new TextEditingController(),
                                                  'port':
                                                      new TextEditingController()
                                                });
                                              });
                                            },
                                      child: Text('Add Alternative Host'),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          onPressed: this.disabled
                              ? null
                              : () {
                                  Navigator.pop(context);
                                },
                          child: Text('Cancel'),
                        ),
                        Visibility(
                          visible: widget.existingTarget != null,
                          child: FlatButton(
                            onPressed: this.disabled
                                ? null
                                : () async {
                                    var res = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Delete'),
                                            content:
                                                Text('Delete this Target?'),
                                            actions: [
                                              FlatButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('Delete'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                    if (res && widget.existingTarget != null) {
                                      await targetBloc
                                          .delete(widget.existingTarget.id);
                                      Navigator.pop(context);
                                    }
                                  },
                            child: Text(
                              'Delete',
                            ),
                          ),
                        ),
                        FlatButton(
                          textColor: Theme.of(context).accentColor,
                          onPressed: this.disabled
                              ? null
                              : () async {
                                  if (isFormValid()) {
                                    setState(() {
                                      this.disabled = true;
                                    });
                                    try {
                                      int hostIndex =
                                          await new TargetConnector()
                                              .testConnection(
                                                  getTargetFromForm());
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                          content: Text(target.hosts.length > 1
                                              ? 'Connection Successful on ${target.hosts[hostIndex].hostName}.'
                                              : 'Connection Successful.')));
                                    } catch (err) {
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(content: Text(err)));
                                    }
                                    setState(() {
                                      this.disabled = false;
                                    });
                                  }
                                },
                          child: Text('Test'),
                        ),
                        FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          onPressed: this.disabled
                              ? null
                              : () async {
                                  if (isFormValid()) {
                                    setState(() {
                                      this.disabled = true;
                                    });
                                    if (this.target.id != null) {
                                      await targetBloc
                                          .edit(getTargetFromForm());
                                    } else {
                                      await targetBloc.add(getTargetFromForm());
                                    }
                                    setState(() {
                                      this.disabled = false;
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                          child: Text('Save'),
                        ),
                      ],
                    )
                  ]),
                )));
      }),
    );
  }
}
