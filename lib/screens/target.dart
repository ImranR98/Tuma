import 'package:flutter/material.dart';
import 'package:ssh_drop/models/target.dart';
import 'package:ssh_drop/blocs/targetBloc.dart';

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

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    privatekeyController.dispose();
    pathController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.existingTarget != null)
      this.target = widget.existingTarget;
    else
      this.target = new Target();

    this.nameController.text = this.target.name != null ? this.target.name : "";
    this.usernameController.text =
        this.target.user != null ? this.target.user : "";
    this.passwordController.text =
        this.target.password != null ? this.target.password : "";
    this.privatekeyController.text =
        this.target.privateKey != null ? this.target.privateKey : "";
    this.pathController.text = this.target.path != null ? this.target.path : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SSH Drop  |  Target'),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Target Name"),
                  controller: nameController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a Name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Username"),
                  controller: usernameController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a Username';
                    }
                    return null;
                  },
                ),
                SizedBox(width: 8),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password"),
                  controller: passwordController,
                  validator: (value) {
                    if (value.isEmpty && privatekeyController.text.isEmpty) {
                      return 'Please enter a Password or Private Key';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Private Key"),
                  controller: privatekeyController,
                  validator: (value) {
                    if (value.isEmpty && passwordController.text.isEmpty) {
                      return 'Please enter a Private Key or Password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Path"),
                  controller: pathController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a Path';
                    }
                    return null;
                  },
                ),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      if (this.target.id != null) {
                        await targetBloc.edit(new Target(
                            id: this.target.id,
                            name: nameController.text,
                            user: usernameController.text,
                            password: passwordController.text,
                            privateKey: privatekeyController.text,
                            path: pathController.text));
                      } else {
                        await targetBloc.add(new Target(
                            name: nameController.text,
                            user: usernameController.text,
                            password: passwordController.text,
                            privateKey: privatekeyController.text,
                            path: pathController.text));
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
