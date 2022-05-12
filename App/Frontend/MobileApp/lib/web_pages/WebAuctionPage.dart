
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WebAuctionPage extends StatefulWidget {
  static const routeName = '/oglas';
  @override
  _WebAuctionPageState createState() => _WebAuctionPageState();
}

class _WebAuctionPageState extends State<WebAuctionPage> {
  @override

  Container mainContainer = Container(
      margin: EdgeInsets.only(top: 100),
      width: 800,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // za sliku
              margin: EdgeInsets.only(top: 50),
              height: 300,
              width:  500,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(child: Text("SLIKA"))
          ),
          Container(
            child: Text("Naziv oglasa"),
          ),
          Container(
              child: Text("Opis oglasa")),

        ],
      )
  );

  AppBar appBar = AppBar(
    elevation: 0,
    automaticallyImplyLeading: false,
    actions: <Widget>[
      Container(
        margin: EdgeInsets.only(right: 100),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  //TextButton(onPressed: (){}, child: Text(""))
                  Text("Odjavi se"),
                  SizedBox(width: 5),
                  Icon(Icons.login_outlined)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 20),
              child: Row(
                  children: [
                    Text("Drugo"),
                    SizedBox(width: 5),
                    Icon(Icons.question_answer)
                  ]),
            )
          ],
        ),
      )
    ],
    title: Text("Oglas"),
    centerTitle: true,
    backgroundColor: Color(0xff59071a),
  );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Stack(
          children: [
            Container(
                color: Color(0xffD5F5E7)
            ),
            Align(alignment: Alignment.center, child: mainContainer),
          ],
        ),
      ),
    );
  }
}
