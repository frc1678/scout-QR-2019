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
      home: new MyHomePage(database: database),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final FirebaseDatabase database;
  MyHomePage({this.database});

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("App title"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Cycle Number',
            ),
            new QrImage(
              data: 'test data',
              size: 200.0,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
