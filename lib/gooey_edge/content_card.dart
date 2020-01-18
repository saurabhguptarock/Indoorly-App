import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indoorly/model/model.dart';
import 'package:indoorly/pages/ask_place.dart';
import 'package:indoorly/services/firebase_service.dart' as firebaseService;
import 'package:provider/provider.dart';

class ContentCard extends StatefulWidget {
  final String color;
  final Color altColor;
  final String title;
  final String subtitle;
  final bool show;

  ContentCard(
      {this.color, this.title = "", this.subtitle, this.altColor, this.show})
      : super();

  @override
  _ContentCardState createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  Ticker _ticker;

  @override
  void initState() {
    _ticker = Ticker((d) {
      setState(() {});
    })
      ..start();
    super.initState();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var time = DateTime.now().millisecondsSinceEpoch / 2000;
    var scaleX = 1.2 + sin(time) * .05;
    var scaleY = 1.2 + cos(time) * .07;
    var offsetY = 20 + cos(time) * 20;
    final user = Provider.of<User>(context);
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: <Widget>[
        Transform(
          transform: Matrix4.diagonal3Values(scaleX, scaleY, 1),
          child: Transform.translate(
            offset: Offset(-(scaleX - 1) / 2 * size.width,
                -(scaleY - 1) / 2 * size.height + offsetY),
            child: Image.asset('assets/images/Bg-${widget.color}.png',
                fit: BoxFit.cover),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 75.0, bottom: 25.0),
            child: Column(
              children: <Widget>[
                //Top Image
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Image.asset(
                        'assets/images/Illustration-${widget.color}.png',
                        fit: BoxFit.contain),
                  ),
                ),

                //Slider circles
                Container(
                    height: 14,
                    child: Image.asset(
                        'assets/images/Slider-${widget.color}.png')),

                //Bottom content
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: _buildBottomContent(user),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBottomContent(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.dMSerifDisplay(
            textStyle:
                TextStyle(height: 1.2, fontSize: 30.0, color: Colors.white),
          ),
        ),
        Text(
          widget.subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w300,
                color: Colors.white),
          ),
        ),
        if (widget.show)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: MaterialButton(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              color: widget.altColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Get Started',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 16,
                        letterSpacing: .8,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (ctx) => StreamProvider<User>.value(
                    value: firebaseService.streamUser(user.uid),
                    initialData: User.fromMap({}),
                    child: StreamProvider<List<Product>>.value(
                        value: firebaseService.streamProducts(user.uid),
                        initialData: [
                          Product(name: '', price: 0, quantity: 0, amount: 0)
                        ],
                        child: AskPlace()),
                  ),
                ));
              },
            ),
          )
      ],
    );
  }
}
