import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
        title: Text('Tuma  |  Help'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload files to SFTP servers.',
                  textScaleFactor: 2,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'The data required to upload files to a specific path on an SFTP server is called a Target.',
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Saved Targets are listed on the Main screen. Click the + button at the bottom of the Main screen to add a Target.',
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Targets must define a Title, Username, Password or Private Key, and at least one Host with its Port. If a Password is provided, the Private Key won\'t be used.',
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'An alternate Host can be added in case connection to the first one fails.',
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'To Edit a saved Target or Upload files to it, swipe it to the left or right to access the relevant option.',
                )
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              InkWell(
                onTap: () {
                  launch('https://imranr.dev/home');
                },
                child: Text(
                  'Imran Remtulla',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              InkWell(
                onTap: () {
                  launch('https://github.com/ImranR98/Tuma');
                },
                child: Text(
                  'Source',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
