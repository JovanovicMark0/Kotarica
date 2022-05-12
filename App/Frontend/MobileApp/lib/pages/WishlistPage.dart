import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/PostModel.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_app/utility/ThemeManager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../models/WishModel.dart';
import 'AuctionPage.dart';
import 'HomePage.dart';

class WishlistPage extends StatefulWidget {
  static const routeName = '/wishlist';
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");
  bool loading = true;
  var listaOglasa;
  SharedPreferences prefs;
  int id = -1;
  var postModel;
  double rating = 0;
  var wishModel;
  var gotovaListaOglasa = null;
  int flag = 0;
  List<Widget> itemList = null;

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  konekcija() async {
    postModel = Provider.of<PostModel>(context, listen: false);
    wishModel = Provider.of<WishModel>(context, listen: false);
    //await postModel.addGrade(0, 5);
    await postModel.getPoster();
    listaOglasa = await wishModel.getWishList(id);
  }

  ucitajOglase() async {
    if (listaOglasa == [])
      gotovaListaOglasa = [];
    else
      gotovaListaOglasa = (await postModel.loadPosts(
          0,
          0,
          listaOglasa,
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
          context));
    if (flag == 0)
      setState(() {
        loading = false;
      });
  }

  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.getSharedPrefs().then((result) {
        setState(() {
          id = prefs.getInt("id");
        });
      }).then((value) => this.konekcija().then((value) => this.ucitajOglase()));
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = GetSize.getMaxWidth(context);
    double screenHeight = GetSize.getMaxHeight(context);
    Future.delayed(Duration.zero, () async {
      listaOglasa = await wishModel.getWishList(id);
      await ucitajOglase();
      flag = 1;
    });
    return loading
        ? Container(
            width: screenWidth,
            height: screenHeight,
            color: Themes.LIGHT_BACKGROUND_COLOR,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(
                      "Molimo sačekajte",
                      textScaleFactor: 1,
                      style:
                          TextStyle(inherit: false, color: Color(0xff59071a)),
                    )),
                CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Color(0xff59071a)),
                ),
              ],
            )))
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Themes.BACKGROUND_COLOR,
              title: Text("Lista Želja"),
              automaticallyImplyLeading: false,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
                child: Stack(children: <Widget>[
              Container(
                  width: GetSize.getMaxWidth(context),
                  height: GetSize.getMaxHeight(context) - 135,
                  //padding: EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    color: Themes.LIGHT_BACKGROUND_COLOR,
                    //borderRadius: BorderRadius.circular(10)
                  ),
                  child: gotovaListaOglasa.length == 0
                      ? Center(
                          child: Text(
                            "Još uvek niste dodali nijedan oglas",
                            style: Themes.TEXT_STYLE_MAIN,
                          ),
                          // child: SmoothStarRating(
                          //   rating: rating,
                          //   isReadOnly: false,
                          //   size: 80,
                          //   filledIconData: Icons.star,
                          //   halfFilledIconData: Icons.star_half,
                          //   defaultIconData: Icons.star_border,
                          //   starCount: 5,
                          //   allowHalfRating: true,
                          //   spacing: 2.0,
                          //   onRated: (value) {
                          //     print("rating value -> $value");
                          //     // print("rating value dd -> ${value.truncate()}");
                          //   },
                          // ),
                        )
                      : ListView(
                          children: [
                            ListView.builder(
                                itemCount: 1,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ListView.builder(
                                      //padding: EdgeInsets.only(
                                      //    top: 10.0, bottom: 15.0),
                                      shrinkWrap: true,
                                      itemCount: gotovaListaOglasa
                                          .length, //"KOLIKO IMA OGLASA count length",
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        //Activity activity = widget.destination.activities[index];
                                        return ListTile(
                                            title: gotovaListaOglasa[index]);
                                      });
                                })
                          ],
                        ))
            ])));
  }
}
