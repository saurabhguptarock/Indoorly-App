import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:indoorly/model/model.dart';
import 'package:indoorly/pages/shop_page.dart';
import 'package:indoorly/services/firebase_service.dart' as firebaseService;
import 'package:indoorly/pages/login_scree.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Indoorly',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    if (user != null) {
      return StreamProvider<User>.value(
        value: firebaseService.streamUser(user.uid),
        initialData: User.fromMap({}),
        child: StreamProvider<List<Product>>.value(
            value: firebaseService.streamProducts(user.uid),
            initialData: [Product(name: '', price: 0, quantity: 0, amount: 0)],
            child: ShopPage()),
      );
    } else
      return LoginPage();
  }
}
