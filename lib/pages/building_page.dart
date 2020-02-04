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

class _BuildingPageState extends State<BuildingPage>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController _unityWidgetController;
  bool _locationNotFound = true;
  String _locationName;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription subscription;
  Set<ScanResult> _scanedDevices = Set();
  Map<String, String> demo;
  List<Map<String, String>> _allLocation = [
    Map.fromEntries([
      MapEntry('5D:72:BB:35:21:D5', 'D1 Building'),
      MapEntry('64:76:19:6A:23:E0', 'D2 Building'),
      MapEntry('42:09:D3:05:00:4E', 'D3 Building'),
      MapEntry('5D:72:BB:35:21:D5', 'D4 Building'),
    ]),
  ];
  double _scale = 1;
  AnimationController _animationController;
  Animation<double> _animation;

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
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _locationNotFound = false;
      });
      zoomImage();
    });
    // subscription = flutterBlue.scan().listen((scanResult) {
    //   print(scanResult.device.id.id);
    //   _scanedDevices.add(scanResult);
    //   _allLocation.forEach((location) {
    //     location.forEach((key, val) {
    //       if (key == scanResult.device.id.id) {
    //         setState(() {
    //           _locationName = val;
    //           _locationNotFound = false;
    //           Toast.show('Location Found $_locationName', context,
    //               duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    //           zoomImage();
    //           // setLocation(_locationName);
    //         });
    //         print('Location Found $_locationName');
    //         stopScan();
    //       }
    //     });
    //   });
    // }, onDone: stopScan());
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween(begin: 1.0, end: 0.0).animate(_animationController);
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

  void zoomImage() {
    Timer.periodic(Duration(milliseconds: 16), (t) {
      setState(() {
        _scale += 0.01;
      });
    });
    Future.delayed(Duration(seconds: 3), () {
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(),
      body: Stack(
        children: <Widget>[
          Stack(
            children: <Widget>[
              UnityWidget(
                onUnityViewCreated: onUnityCreated,
                isARScene: true,
                onUnityMessage: onUnityMessage,
              ),
              FadeTransition(
                opacity: _animation,
                child: Transform.scale(
                  scale: _scale,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/maps/Building.webp'),
                      ),
                    ),
                  ),
                ),
              ),
              if (_locationNotFound)
                Center(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: LoadingIndicator()),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
