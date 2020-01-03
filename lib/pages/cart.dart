import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indoorly/model/model.dart';
import 'package:indoorly/shared/shared_ui.dart';
import 'package:provider/provider.dart';
import 'package:indoorly/services/firebase_service.dart' as firebaseService;

class CartPage extends StatefulWidget {
  final String uid;

  const CartPage({Key key, this.uid}) : super(key: key);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<List<Product>>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: GoogleFonts.lato(fontSize: 25)),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: Container(
          child: products.length > 0
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (ctx, i) => Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 10)),
                      cartItemTiles(widget.uid, products[i])
                    ],
                  ),
                )
              : Center(
                  child: Text(
                    'Your cart is empty.',
                    style: GoogleFonts.lato(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
        ),
      ),
    );
  }

  Widget cartItemTiles(String uid, Product product) {
    return Card(
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
    );
  }
}
