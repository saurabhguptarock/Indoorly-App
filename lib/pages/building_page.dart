import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:indoorly/shared/shared_ui.dart';
import 'package:toast/toast.dart';

class BuildingPage extends StatefulWidget {
  @override
  _BuildingPageState createState() => _BuildingPageState();
}

class _BuildingPageState extends State<BuildingPage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController _unityWidgetController;
  bool _locationNotFound = true;
  String _locationName;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription subscription;
  Set<ScanResult> _scanedDevices = Set();
  List<List<Map<String, String>>> _allLocation = [];

  void setLocation(String location) {
    _unityWidgetController.postMessage(
      'Cube',
      'SetRotationSpeed',
      location,
    );
  }

  void onUnityMessage(controller, message) {
    print('Received message from unity: ${message.toString()}');
  }

  void onUnityCreated(controller) {
    this._unityWidgetController = controller;
  }

  @override
  void initState() {
    subscription = flutterBlue.scan().listen((scanResult) {
      _scanedDevices.add(scanResult);
      _allLocation.forEach((location) {
        location.forEach((place) {
          if (place.containsKey(scanResult.device.id.id)) {
            setState(() {
              _locationName = place[scanResult.device.id.id];
              _locationNotFound = false;
              setLocation(_locationName);
            });
            print('Location Found $_locationName');
            stopScan();
          }
        });
      });
    }, onDone: stopScan());
    super.initState();
  }

  stopScan() {
    subscription?.cancel();
    subscription = null;
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(),
      body: Stack(
        children: <Widget>[
          // UnityWidget(
          //   onUnityViewCreated: onUnityCreated,
          //   isARScene: true,
          //   onUnityMessage: onUnityMessage,
          // ),
          if (_locationNotFound)
            Center(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: LoadingIndicator()),
            ),
        ],
      ),
    );
  }
}
