import 'package:flutter/material.dart';
import 'package:path/path.dart';

class HelpPage extends StatefulWidget {
  HelpPage({Key key}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SSH Drop  |  Help'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload files to SFTP servers.',
              textScaleFactor: 1.5,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Saved Targets are listed on the Main screen. Click the + button at the bottom of the Main screen to add a Target.',
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Targets must define a Title, Username, Password or Private Key, and at least one Host with its Port. If a Password is provided, the Private Key won\'t be used.',
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'An alternate Host can be added in case connection to the first one fails.',
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'To Edit a saved Target or Upload files to it, swipe it to the left or right to access the relevant option.',
            )
          ],
        ),
      ),
    );
  }
}
