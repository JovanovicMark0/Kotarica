import 'package:flutter/material.dart';

class GalleryPage extends StatefulWidget {
  final List a;
  GalleryPage({Key key, this.a}) : super(key: key);
  State<StatefulWidget> createState() {
    return _GalleryPageState();
  }
}

// ignore: must_be_immutable
class _GalleryPageState extends State<GalleryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Galerija",
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
      body: ListView.builder(
        itemBuilder: (BuildContext ctx, int index) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                this.widget.a[index] == "QmTwCcmKj5DFX3z28NQ3azfRsh1Zu4JczUXz8iUC9AcLB1" ? Image.asset(
                  'images/empty.png',
                ) : Image.network("http://147.91.204.116:11128/ipfs/${this.widget.a[index]}",)
              ],

            ),
          );
        },
        itemCount: this.widget.a.length,
      ),
    );
  }
}
