import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indoorly/model/model.dart';
import 'package:indoorly/shared/shared_ui.dart';
import 'package:provider/provider.dart';
import 'package:indoorly/services/firebase_service.dart' as firebaseService;
import 'package:flare_flutter/flare_actor.dart';

class CartPage extends StatefulWidget {
  final String uid;

  const CartPage({Key key, this.uid}) : super(key: key);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _totalAmountPayble;
  bool _isPaused = true;
  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<List<Product>>(context);
    if (products.length > 0) {
      int tAmount = 0;
      products.forEach((product) {
        tAmount += product.amount;
      });
      setState(() {
        _totalAmountPayble = tAmount;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: GoogleFonts.lato(fontSize: 25)),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: products.length > 0
              ? Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height - 165,
                      child: ListView.builder(
                          itemCount: products.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (ctx, i) {
                            return Column(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(top: 3)),
                                cartItemTiles(widget.uid, products[i]),
                                if (i == products.length - 1)
                                  Padding(padding: EdgeInsets.only(bottom: 10)),
                              ],
                            );
                          }),
                    ),
                    Positioned(
                      child: Container(
                        height: 80,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Amount payable now',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 5)),
                                  Text('Rs. $_totalAmountPayble',
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: SizedBox(
                                width: 150,
                                height: 50,
                                child: RaisedButton(
                                  color: Colors.amber,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPaused = false;
                                    });
                                    Future.delayed(
                                        Duration(seconds: 2, milliseconds: 500),
                                        () {
                                      if (mounted) {
                                        setState(() {
                                          _isPaused = true;
                                        });
                                        Navigator.of(context).pop();
                                        firebaseService
                                            .deleteAllProducts(widget.uid);
                                      }
                                    });
                                  },
                                  child: Text(
                                    'PAY NOW',
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      textStyle: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      bottom: 0,
                      left: 0,
                      right: 0,
                    ),
                    if (!_isPaused)
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: FlareActor("assets/flare/SuccessCheck.flr",
                              alignment: Alignment.center,
                              fit: BoxFit.contain,
                              isPaused: _isPaused,
                              animation: 'Start'),
                        ),
                      ),
                  ],
                )
              : FlareActor("assets/flare/Filip.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  animation: 'idle'),
        ),
      ),
    );
  }

  Widget cartItemTiles(String uid, Product product) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      key: ValueKey(product),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Image.asset(
                      'assets/images/${product.name.toLowerCase()}.jpg'),
                ),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 3)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          product.name,
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
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
                                firebaseService.deleteProduct(uid, product.id);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 12)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
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
                                    if (product.quantity == 1) {
                                      firebaseService.deleteProduct(
                                          uid, product.id);
                                      return;
                                    }
                                    if (product.quantity != 0)
                                      firebaseService.updateQuantity(
                                          uid, product.id, -1, product.price);
                                  },
                                ),
                              ),
                            ),
                            Text(
                              product.quantity.toString(),
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
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
                                    firebaseService.updateQuantity(
                                        uid, product.id, 1, product.price);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            'Rs. ' + product.amount.toString(),
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
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
    );
  }
}
