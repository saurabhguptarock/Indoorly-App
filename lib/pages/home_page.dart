import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indoorly/pages/cart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController _unityWidgetController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            // UnityWidget(
            //   onUnityViewCreated: onUnityCreated,
            //   isARScene: false,
            //   onUnityMessage: onUnityMessage,
            // ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              right: 0,
              child: Container(
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 20,
                      child: IconButton(
                          icon: Icon(
                            Icons.shopping_cart,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => CartPage()));
                          }),
                    ),
                    Positioned(
                      left: 42,
                      top: 3,
                      child: CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        radius: 8,
                        child: Text(
                          '${products.length}',
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.white),
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 50,
              right: 20,
              left: 20,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: MaterialButton(
                    child: Text('BUY NOW',
                        style: GoogleFonts.lato(
                            fontSize: 30,
                            textStyle: TextStyle(color: Colors.white))),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => CartPage()));
                    }),
              ),
            ),

            // Positioned(

            // )
          ],
        ),
      ),
    );
  }

  void setRotationSpeed(String speed) {
    _unityWidgetController.postMessage(
      'Cube',
      'SetRotationSpeed',
      speed,
    );
  }

  void onUnityMessage(controller, message) {
    print('Received message from unity: ${message.toString()}');
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    this._unityWidgetController = controller;
  }
}
