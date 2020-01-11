import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indoorly/model/model.dart';
import 'package:indoorly/pages/cart.dart';
import 'package:indoorly/services/firebase_service.dart' as firebaseService;
import 'package:indoorly/shared/shared_ui.dart';
import 'package:provider/provider.dart';
import 'package:rubber/rubber.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with TickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController _unityWidgetController;
  bool _productFound = false;
  AnimationController _controller;
  RubberAnimationController _bottomController;
  bool _shouldShow = false;
  Animation<Offset> _offsetAnimation;
  Product _selectedProduct;
  int _selectedProductQuantity = 1;

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

    _bottomController = RubberAnimationController(
      vsync: this,
      dismissable: true,
      duration: Duration(milliseconds: 200),
      lowerBoundValue: AnimationControllerValue(pixel: 200),
      upperBoundValue: AnimationControllerValue(pixel: 450),
    );
    super.initState();
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
      body: RubberBottomSheet(
        lowerLayer: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              // UnityWidget(
              //   onUnityViewCreated: onUnityCreated,
              //   isARScene: true,
              //   onUnityMessage: onUnityMessage,
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
                                    value: firebaseService
                                        .streamProducts(user.uid),
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
                          Product prod;
                          int no = Random().nextInt(5);
                          switch (no) {
                            case 0:
                              prod = Product(
                                  name: 'Lays',
                                  id: '',
                                  amount: 20,
                                  price: 20,
                                  quantity: 1);
                              break;
                            case 1:
                              prod = Product(
                                  name: 'Biscuits',
                                  id: '',
                                  amount: 10,
                                  price: 10,
                                  quantity: 1);
                              break;
                            case 2:
                              prod = Product(
                                  name: 'Flour',
                                  id: '',
                                  amount: 500,
                                  price: 500,
                                  quantity: 1);
                              break;
                            case 3:
                              prod = Product(
                                  name: 'Juice',
                                  id: '',
                                  amount: 100,
                                  price: 100,
                                  quantity: 1);
                              break;
                            case 4:
                              prod = Product(
                                  name: 'Maggi',
                                  id: '',
                                  amount: 10,
                                  price: 10,
                                  quantity: 1);
                              break;
                            default:
                          }
                          setState(() {
                            _selectedProduct = prod;
                            _shouldShow = true;
                          });
                        }),
                  ),
                ),
            ],
          ),
        ),
        upperLayer: _shouldShow
            ? Container(
                height: MediaQuery.of(context).size.height * 1.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 2 - 18),
                        child: Icon(
                          FontAwesomeIcons.gripLines,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          height: 85,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Image.asset(
                                      'assets/images/${_selectedProduct.name.toLowerCase()}.webp'),
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Column(
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.only(top: 3)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          _selectedProduct.name,
                                          style: GoogleFonts.lato(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            radius: 8,
                                            child: InkWell(
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 13,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  _shouldShow = false;
                                                });
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 12)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: CircleAvatar(
                                                backgroundColor: Colors.grey,
                                                radius: 10,
                                                child: InkWell(
                                                  child: Icon(
                                                    Icons.remove,
                                                    color: Colors.white,
                                                    size: 15,
                                                  ),
                                                  onTap: () {
                                                    if (_selectedProductQuantity >
                                                        0)
                                                      setState(() {
                                                        _selectedProductQuantity--;
                                                      });
                                                  },
                                                ),
                                              ),
                                            ),
                                            Text(
                                              _selectedProductQuantity
                                                  .toString(),
                                              style: GoogleFonts.lato(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15),
                                              child: CircleAvatar(
                                                backgroundColor: Colors.grey,
                                                radius: 10,
                                                child: InkWell(
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 15,
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedProductQuantity++;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: SizedBox(
                                            width: 70,
                                            height: 25,
                                            child: MaterialButton(
                                              color: Colors.amber,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              onPressed: () {
                                                if (_selectedProductQuantity >
                                                    0) {
                                                  setState(() {
                                                    _shouldShow = false;
                                                  });
                                                  int _amount =
                                                      _selectedProductQuantity *
                                                          _selectedProduct
                                                              .price;
                                                  firebaseService.addProduct(
                                                      user.uid,
                                                      Product(
                                                          amount: _amount,
                                                          quantity:
                                                              _selectedProductQuantity,
                                                          name: _selectedProduct
                                                              .name,
                                                          id: '',
                                                          price:
                                                              _selectedProduct
                                                                  .price));
                                                  _controller.forward();
                                                }
                                              },
                                              child: Text(
                                                'Done',
                                                style: GoogleFonts.lato(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 10, left: 15),
                        child: Text(
                          'Recommended for you',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://firebasestorage.googleapis.com/v0/b/indoorly-2fc40.appspot.com/o/WhatsApp%20Image%202020-01-07%20at%2023.11.04.jpeg?alt=media&token=fc066638-dbba-44ab-b02f-2885819f313b'),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://firebasestorage.googleapis.com/v0/b/indoorly-2fc40.appspot.com/o/WhatsApp%20Image%202020-01-07%20at%2022.52.34.jpeg?alt=media&token=29fd1527-64e8-446a-b160-df1662d54c63'),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://firebasestorage.googleapis.com/v0/b/indoorly-2fc40.appspot.com/o/WhatsApp%20Image%202020-01-07%20at%2022.59.18.jpeg?alt=media&token=c5f54f92-6469-4f3f-b609-69ca10de07d4'),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://firebasestorage.googleapis.com/v0/b/indoorly-2fc40.appspot.com/o/WhatsApp%20Image%202020-01-07%20at%2022.59.19%20(1).jpeg?alt=media&token=d2adba9f-fa12-4eb1-8f91-906aaa74a6c3'),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://firebasestorage.googleapis.com/v0/b/indoorly-2fc40.appspot.com/o/WhatsApp%20Image%202020-01-07%20at%2022.59.19.jpeg?alt=media&token=af18affe-5829-49e7-a9df-156fe046a7ab'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 10, left: 15),
                        child: Text(
                          'People also buy',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://firebasestorage.googleapis.com/v0/b/indoorly-2fc40.appspot.com/o/WhatsApp%20Image%202020-01-07%20at%2022.59.20.jpeg?alt=media&token=8ceb7a6e-c9a7-404a-8c20-ea644a3acb17'),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://firebasestorage.googleapis.com/v0/b/indoorly-2fc40.appspot.com/o/WhatsApp%20Image%202020-01-07%20at%2023.11.03%20(1).jpeg?alt=media&token=99248afc-cd65-403b-9a47-39c0108a24cf'),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://firebasestorage.googleapis.com/v0/b/indoorly-2fc40.appspot.com/o/WhatsApp%20Image%202020-01-07%20at%2023.11.03.jpeg?alt=media&token=319dae9a-a655-411f-851c-1e86867895e3'),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://firebasestorage.googleapis.com/v0/b/indoorly-2fc40.appspot.com/o/WhatsApp%20Image%202020-01-07%20at%2023.11.04%20(1).jpeg?alt=media&token=45d6c425-0649-413a-bcd2-20e1a5e4835c'),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://firebasestorage.googleapis.com/v0/b/indoorly-2fc40.appspot.com/o/WhatsApp%20Image%202020-01-07%20at%2022.59.18.jpeg?alt=media&token=c5f54f92-6469-4f3f-b609-69ca10de07d4'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
        animationController: _bottomController,
      ),
    );
  }
}
