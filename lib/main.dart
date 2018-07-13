import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:qr_flutter/qr_flutter.dart';

part 'firebase.dart';


Future<void> main() async {
  final FirebaseApp app = await configureDatabase();
  final FirebaseDatabase database = new FirebaseDatabase(app: app);
  // Forces orientation to portraitUp
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,]);
  runApp(new MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final FirebaseDatabase database;
  MyApp({this.database});
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(title: new Text('Scout QR Code App')),
        body: new Center(
          child: new QrDisplay(database: database),
        ),
        // Create new class for scan action button to allow snackbars
        floatingActionButton: new FloatingActionButton(
          tooltip: 'Increment',
          child: new Icon(Icons.add),
        ),
      ),
    );
  }
}

class QrDisplay extends StatefulWidget {
  final FirebaseDatabase database;
  QrDisplay({this.database});
  _QrDisplayState createState() => new _QrDisplayState();
}

class _QrDisplayState extends State<QrDisplay> {
  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Text(
          'Cycle: -',
          style: Theme.of(context).textTheme.display3.apply(fontWeightDelta: 3, color: Colors.indigo, fontSizeFactor: 1.25),
        ),
        new QrImage(
          data: 'test data',
          size: MediaQuery.of(context).size.width*0.95,
        ),
        new Text(
          'Version: 0.1',
          style: Theme.of(context).textTheme.caption.apply(fontSizeFactor: 2.5),
        )
      ],
    );
  }
}
