import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:qr_flutter/qr_flutter.dart';

part 'firebase.dart';

final version = '0.2';

// Creates a single, global instance
final FirebaseDatabase database = FirebaseDatabase.instance;

Future<void> main() async {
  final FirebaseApp app = await configureDatabase();
  // This creates the database instance using the configuration.
  // The database variable is not declared here because it would be local and
  // it should be a global database instance.
  new FirebaseDatabase(app: app);
  // Forces orientation to portraitUp
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,]);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
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
          child: new QrDisplay(),
        ),
        // Create new class for scan action button to allow snackbars
        floatingActionButton: new QrScanner(database: database),
      ),
    );
  }
}

class QrDisplay extends StatefulWidget {
  _QrDisplayState createState() => new _QrDisplayState();
}

class _QrDisplayState extends State<QrDisplay> {
  bool _isOutdatedVersion = false;

  @override
  void initState() {
    super.initState();
    widget.database.reference().child('appVersions/scoutQR').onValue.listen((Event event) {
      setState(() {{
        // Checks if the latest version is the same version of the app
        if (event.snapshot.value == version) {
          _isOutdatedVersion = false;
        } else {
          _isOutdatedVersion = true;
        }
        }});
    });
  }

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
          'Version: $version',
          style: _isOutdatedVersion
              // If the app is outdated, the version text becomes red + bold.
              ? Theme.of(context).textTheme.caption.apply(fontSizeFactor: 2.5, color: Colors.red, fontWeightDelta: 2)
              : Theme.of(context).textTheme.caption.apply(fontSizeFactor: 2.5),
        )
      ],
    );
  }
}

class QrScanner extends StatefulWidget {
  final FirebaseDatabase database;
  QrScanner({this.database});
  _QrScannerState createState() => new _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  @override
  Widget build(BuildContext context) {
    return new FloatingActionButton(
      tooltip: 'Scan',
      child: new Icon(Icons.camera_alt),
      onPressed: _scan,
    );
  }

  // Used if camera access cannot be requested again and
  // requires toggle to be changed manually in settings
  void _showManualCameraToggleDialog () {
    showDialog(context: context, builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text('Unable to scan'),
        content: new Text('Please enable camera access for 1678 QR in settings!'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {Navigator.pop(context);},
            child: new Text('Close')),
        ],
      );
    });
  }

  Future _scan() async {
    try {
      String qrcode = await BarcodeScanner.scan();
      // Check to make sure QR code is a tempTIMD
      if (qrcode.contains('Q') &&
          qrcode.contains('-') &&
          qrcode.contains('|') &&
          int.tryParse(qrcode.split('Q')[0]) != null &&
          int.tryParse(qrcode.split('-')[0].split('Q')[1]) != null &&
          int.tryParse(qrcode.split('|')[0].split('-')[1]) != null
      ) {
        // Send to firebase
        widget.database.reference().child('TempQRTeamInMatchDatas').child(
            qrcode.split('|')[0]).set(qrcode);
      }
      else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: new Text('Scan Failed'),
              content: new Text('Invalid QR code data. Please scan again!'),
              actions: <Widget>[
                new FlatButton(onPressed: () {
                  Navigator.pop(context);
                },
                    child: new Text('Close')),
                new FlatButton(onPressed: () {
                  Navigator.pop(context);
                  _scan();
                },
                    child: new Text('Rescan')),
              ],
            );
          }
        );
      }
    } on PlatformException catch (e) {
      // Android only - if "Don't ask again" is unchecked
      // Able to ask again when scan is pressed again
      if (e.code == BarcodeScanner.CameraAccessDeniedOnce) {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text('Camera access required to scan QR codes!'),
          action: new SnackBarAction(label: 'RETRY', onPressed: _scan),
        ));
      // iOS deny or Android deny with "Don't ask again" checked
      // Handled the same, needs user to manually go into settings
      // Dialog shown with help since camera access cannot be asked for again
      } else if (e.code == BarcodeScanner.CameraAccessDenied) {
        _showManualCameraToggleDialog();
      } else {
        print('Unknown error: $e');
      }
    } on FormatException {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text('Scan cancelled'),
        action: new SnackBarAction(label: 'GO BACK', onPressed: _scan),
      ));
    } catch (e) {
      print('Unknown error: $e');
    }
  }
}
