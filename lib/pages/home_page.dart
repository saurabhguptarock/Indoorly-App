import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indoorly/model/model.dart';
import 'package:indoorly/pages/cart.dart';
import 'package:indoorly/services/firebase_service.dart' as firebaseService;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController _unityWidgetController;
  bool _productFound = false;
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

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

  void onUnityCreated(controller) {
    this._unityWidgetController = controller;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1, 0),
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceOut,
        reverseCurve: Curves.easeInExpo));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<List<Product>>(context);
    User user = Provider.of<User>(context);
    return Scaffold(
      drawer: Drawer(),
      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            // UnityWidget(
            // onUnityViewCreated: onUnityCreated,
            // isARScene: true,
            // onUnityMessage: onUnityMessage,
            // ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              right: -60,
              child: SlideTransition(
                position: _offsetAnimation,
                child: Container(
                  width: 60,
                  height: 45,
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
                        left: 10,
                        child: IconButton(
                          icon: Icon(
                            Icons.shopping_cart,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    StreamProvider<List<Product>>.value(
                                  value:
                                      firebaseService.streamProducts(user.uid),
                                  initialData: [
                                    Product(
                                        name: '',
                                        price: 0,
                                        quantity: 0,
                                        amount: 0)
                                  ],
                                  child: CartPage(
                                    uid: user.uid,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        left: 32,
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
            ),
            if (!_productFound)
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Text('BUY NOW',
                          style: GoogleFonts.lato(
                              fontSize: 30,
                              textStyle: TextStyle(color: Colors.white))),
                      onPressed: () {
                        switch (_controller.status) {
                          case AnimationStatus.completed:
                            _controller.reverse();
                            break;
                          case AnimationStatus.dismissed:
                            _controller.forward();
                            break;
                          default:
                        }
                      }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
