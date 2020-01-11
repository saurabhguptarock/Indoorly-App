import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indoorly/model/model.dart';
import 'package:indoorly/pages/building_page.dart';
import 'package:indoorly/pages/shop_page.dart';
import 'package:indoorly/services/firebase_service.dart' as firebaseService;
import 'package:provider/provider.dart';

class AskPlace extends StatefulWidget {
  @override
  _AskPlaceState createState() => _AskPlaceState();
}

class _AskPlaceState extends State<AskPlace> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'Select Place To Visit',
                  style: GoogleFonts.lato(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    'This is displayed only once when the app is started. Please be careful while selecting the Place, You wont be able to change it.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.grey, height: 1.4),
                        fontSize: 15),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                InkWell(
                  onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => StreamProvider<User>.value(
                        value: firebaseService.streamUser(user.uid),
                        initialData: User.fromMap({}),
                        child: StreamProvider<List<Product>>.value(
                            value: firebaseService.streamProducts(user.uid),
                            initialData: [
                              Product(
                                  name: '', price: 0, quantity: 0, amount: 0)
                            ],
                            child: ShopPage()),
                      ),
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/Shop.webp',
                    height: 130,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'I want to go to Shop',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w600, fontSize: 18),
                )
              ],
            ),
            Column(
              children: <Widget>[
                InkWell(
                  onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => StreamProvider<User>.value(
                          value: firebaseService.streamUser(user.uid),
                          initialData: User.fromMap({}),
                          child: BuildingPage()),
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/Building.webp',
                    height: 130,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'I want to go to Building',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w600, fontSize: 18),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
