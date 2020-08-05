import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tuma/models/target.dart';
import 'package:tuma/targetConnector.dart';

class UploadPage extends StatefulWidget {
  final Target target;
  final GlobalKey<ScaffoldState> scaffoldKey;
  UploadPage({Key key, this.target, this.scaffoldKey}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  int filesUploaded = 0;
  List<File> files;

  @override
  void initState() {
    super.initState();
    pickAndUpload();
  }

  pickAndUpload() async {
    var tempFiles = await FilePicker.getMultiFile();
    setState(() {
      files = tempFiles;
    });
    if (files == null)
      Navigator.pop(context);
    else if (files.length == 0)
      Navigator.pop(context);
    else {
      try {
        await new TargetConnector().uploadFiles(
            widget.target, files.map((file) => file.path).toList(), (progress) {
          setState(() {
            if (progress == 100) filesUploaded += 1;
          });
        });
        widget.scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Uploaded.'),
        ));
      } on String catch (err) {
        widget.scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(err),
        ));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tuma  |  Upload'),
      ),
      body: Container(
        margin: EdgeInsets.all(12.0),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Visibility(
              visible: files != null,
              child: Text(
                'Uploading File ${files != null ? filesUploaded + 1 < files.length ? filesUploaded + 1 : files.length : 0} of ${files != null ? files.length : 0}...',
                style: TextStyle(color: Colors.grey[700]),
                textScaleFactor: 1.5,
              ),
            ),
            Visibility(
              visible: files == null,
              child: Text(
                'Upload Files',
                style: TextStyle(color: Colors.grey[700]),
                textScaleFactor: 1.5,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Visibility(
              visible: files != null,
              child: Text(
                '${files != null ? files[filesUploaded].path : 0}',
                style: TextStyle(color: Colors.grey[700]),
                textScaleFactor: 1,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
