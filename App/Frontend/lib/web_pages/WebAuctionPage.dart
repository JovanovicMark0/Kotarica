
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utility/GetSize.dart';

class WebAuctionPage extends StatefulWidget {
  static const routeName = '/oglas';
  @override
  _WebAuctionPageState createState() => _WebAuctionPageState();
}

class _WebAuctionPageState extends State<WebAuctionPage> {
  @override

  Container mainContainer = Container(
      margin: EdgeInsets.only(top: 50, bottom: 50),
      width: 800,
      height: 1500,
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
              height: 800,
              width:  400,
              decoration: BoxDecoration(
                //color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                      'images/oglasSlike.jpg',
                      fit: BoxFit.cover))
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Text("Naziv oglasa", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
          ),
          Container(
            margin: EdgeInsets.only(top: 25),
            child: Text("Opis opis opis opis opis oglasa", style: TextStyle(fontSize: 15),),
          ),
          Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      "4200", //'\$${activity.price}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    'Kupi odmah',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      //color: Colors.white70,
                    ),
                  ),
                  Align(
                    child: Container(
                        padding: const EdgeInsets.only(
                            top: 5.0, right: 0.0, bottom: 0.0),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.favorite_border,
                            //color: Colors.white70),
                          ),
                        )),
                  ),
                ],
              ),
            ),

          Container(
            margin: EdgeInsets.only(top: 25),
            child: Text("Preostalo vremena:", style: TextStyle(fontSize: 30),),
          ),
          Container(
            margin: EdgeInsets.only(top: 25),
            child: Text("13 dana 6h", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
          ),
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
    title: Text("Aukcija"),
    centerTitle: true,
    backgroundColor: Color(0xff59071a),
  );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: ListView(
          children: [
            Stack(
              children: [
                Container(
                    width: GetSize.getMaxWidth(context),
                    height: 1600,
                    color: Color(0xffD5F5E7)
                ),
                Align(alignment: Alignment.center, child: mainContainer),
              ],
            )
          ],
        ),
      ),
    );
  }
}
