import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/AddNewPostPage.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'AddNewAuctionPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}

class AddChoosing extends StatefulWidget {
  AddChoosing({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddChoosingState createState() => _AddChoosingState();
}

class _AddChoosingState extends State<AddChoosing> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = GetSize.getMaxWidth(context);
    double screenHeight = GetSize.getMaxHeight(context);
    final LICITACIJA = Material(
      color: Color(0xff59081b),
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 250,
        height: 50,
        child: MaterialButton(
          minWidth: GetSize.getMaxWidth(context),
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AddNewAuctionPage()));
          },
          child: Center(
            child: Text(
              'Dodaj licitaciju',
              textScaleFactor: 0.8,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    final OGLAS = Material(
      color: Color(0xff59081b),
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 250,
        height: 50,
        child: MaterialButton(
          //minWidth: GetSize.getMaxWidth(context),
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AddNewPostPage()));
          },
          child: Center(
            child: Text(
              'Dodaj oglas',
              textScaleFactor: 0.8,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj",
          style: TextStyle(
            height: 2,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        //automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff59071a),
      ),
      body: Center(
        /* child: Container(
          child: FloatingActionButton(
            child: SpeedDial(
              animatedIcon: AnimatedIcons.list_view,
              //overlayColor: Color(0xff59071a),
              //overlayOpacity: 0.5,
              curve: Curves.ease,
              children: [
                SpeedDialChild(
                    child: Icon(Icons.shopping_cart_sharp),
                    label: "Dodaj oglas",
                    onTap: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddNewPostPage()),
                        );
                      });
                    }
                ),
                SpeedDialChild(
                    child: Icon(Icons.shopping_cart_sharp),
                    label: "Dodaj licitaciju",
                    onTap: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddNewAuctionPage()),
                        );
                      });
                    }
                )
              ],
            ),
          ),
        ),*/
        child: Container(
          width: GetSize.getMaxWidth(context),
          decoration: BoxDecoration(
            color: Color(0xffd5f5e7),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Izaberite šta želite da dodate:",
                  textScaleFactor: 1.8,
                ),
                SizedBox(
                  height: GetSize.getMaxHeight(context) * 0.06,
                ),
                OGLAS,
                SizedBox(
                  height: GetSize.getMaxHeight(context) * 0.04,
                ),
                LICITACIJA
              ]),
        ),
      ),
    );
  }
}
