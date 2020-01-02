import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indoorly/model/model.dart';
import 'package:indoorly/shared/shared_ui.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

List<Product> products = [
  Product(amount: '20', name: 'Lays', price: '20', quantity: '1')
];

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
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
                      cartItemTiles(products[i])
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

  Widget cartItemTiles(Product product) {
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
                  Padding(padding: EdgeInsets.only(top: 10)),
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
                            onTap: () {},
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
                                onTap: () {},
                              ),
                            ),
                          ),
                          Text(
                            product.quantity,
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
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          'Rs. ' + product.amount,
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
