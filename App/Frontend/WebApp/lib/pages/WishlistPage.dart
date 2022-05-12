import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/PostModel.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_app/utility/ThemeManager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/WishModel.dart';
import 'AddChoosing.dart';
import 'AuctionPage.dart';
import 'HomePage.dart';
import 'InboxPage.dart';
import 'LoginPage.dart';
import 'NotificationPage.dart';
import 'OcenePage.dart';
import 'SettingsProfilePage.dart';
import 'UserProfilePage.dart';

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
  var wishModel;
  var gotovaListaOglasa = null;

  List<Widget> itemList = null;

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  konekcija() async {
    postModel = Provider.of<PostModel>(context, listen: false);
    wishModel = Provider.of<WishModel>(context, listen: false);
    listaOglasa = wishModel.getWishList(id);
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
  }

  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.getSharedPrefs().then((result) {
        setState(() {
          id = prefs.getInt("id");
        });
      }).then((value) => this
          .konekcija()
          .then((result) {})
          .then((value) => this.ucitajOglase().then((result) {
                setState(() {
                  loading = false;
                });
              })));
    });
  }

  void refreshItemsList() {
    itemList = [];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = GetSize.getMaxWidth(context);
    double screenHeight = GetSize.getMaxHeight(context);
    return loading
        ? Container(
            width: screenWidth,
            height: screenHeight,
            color: Color(0xffD5F5E7),
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
      backgroundColor: Color(0xff59071a),
          appBar: AppBar(
            title: Text("Lista želja"),
            //automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 0,
            backgroundColor: Color(0xff59071a),
          ),
            body:Row(
              children:<Widget>[
                SizedBox(
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          id == -1
                              ? Container()
                              : menuButton("Početna", Icons.home, HomePage()),
                          id == -1 ? Container() : SizedBox(height: 20),
                          id == -1
                              ? Container()
                              : menuButton("Moj profil", Icons.person_sharp, UserProfilePage()),
                          id == -1 ? Container() : SizedBox(height: 20),
                          id == -1
                              ? Container()
                              : menuButton("Moje poruke", Icons.messenger_outline, InboxPage()),
                          id == -1 ? Container() : SizedBox(height: 20),
                          // menuButton("Moji oglasi", CupertinoIcons.square_list_fill, LoginPage()),
                          // SizedBox(height: 20),
                          id == -1
                              ? Container()
                              : menuButton("Dodaj Oglas", Icons.post_add_outlined, AddChoosing()),
                          id == -1 ? Container() : SizedBox(height: 20),
                          id == -1
                              ? Container()
                              : menuButton("Lista Želja", Icons.bookmark,
                              WishlistPage()),
                          id == -1 ? Container() : SizedBox(height: 20),
                          menuButton("Obaveštenja", Icons.notifications, NotificationPage()),
                          SizedBox(height: 20),
                          id == -1
                              ? Container()
                              : menuButton("Ocene", Icons.thumbs_up_down_outlined, OcenePage()),
                          id == -1 ? Container() : SizedBox(height: 20),
                          id == -1
                              ? Container()
                              : menuButton("Podešavanja", Icons.settings, SettingsProfilenPage()),
                          id == -1 ? Container() : SizedBox(height: 20),
                          SizedBox(height: 20),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
            SingleChildScrollView(
                child: Stack(children: <Widget>[
              Container(
                  width: GetSize.getMaxWidth(context)-200,
                  height: GetSize.getMaxHeight(context),
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
                        )
                      : ListView(
                          children: [
                            ListView.builder(
                                itemCount: 1,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  return Dismissible(
                                      key: Key(item),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (direction) {
                                        setState(() {
                                          items.removeAt(index);
                                        });

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Oglas $item izbačen je iz liste želja.")));
                                      },
                                      background: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          margin: EdgeInsets.only(right: 20),
                                          color: Themes.BACKGROUND_COLOR,
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Icon(
                                                    Icons.restore_from_trash,
                                                    size: 25,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                TextSpan(
                                                    text: "Ukloni iz liste",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: ListView.builder(
                                          //padding: EdgeInsets.only(
                                          //    top: 10.0, bottom: 15.0),
                                          shrinkWrap: true,
                                          itemCount: gotovaListaOglasa
                                              .length, //"KOLIKO IMA OGLASA count length",
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            //Activity activity = widget.destination.activities[index];
                                            return ListTile(
                                                title: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AuctionPage()),
                                                  );
                                                });
                                              },
                                              child: gotovaListaOglasa[index],
                                              /*
                                                gotovaListaOglasa
                                                    .map<Widget>((lista) {
                                                  return lista;
                                                }).toList()
                                                 */
                                            ));
                                          }));
                                })
                          ],
                        ))
            ])),],),);
  }

  Widget menu(context) {
    return SlideTransition(
      child: ScaleTransition(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 0.4 * GetSize.getMaxWidth(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  id == -1
                      ? Container()
                      : menuButton("Početna", Icons.home, HomePage()),
                  id == -1 ? Container() : SizedBox(height: 20),
                  id == -1
                      ? Container()
                      : menuButton("Moj profil", Icons.person_sharp, UserProfilePage()),
                  id == -1 ? Container() : SizedBox(height: 20),
                  id == -1
                      ? Container()
                      : menuButton("Moje poruke", Icons.messenger_outline, InboxPage()),
                  id == -1 ? Container() : SizedBox(height: 20),
                  // menuButton("Moji oglasi", CupertinoIcons.square_list_fill, LoginPage()),
                  // SizedBox(height: 20),
                  id == -1
                      ? Container()
                      : menuButton("Dodaj Oglas", Icons.post_add_outlined, AddChoosing()),
                  id == -1 ? Container() : SizedBox(height: 20),
                  id == -1
                      ? Container()
                      : menuButton("Lista Želja", Icons.bookmark, WishlistPage()),
                  id == -1 ? Container() : SizedBox(height: 20),
                  id == -1
                      ? Container()
                      : menuButton("Ocene", Icons.thumbs_up_down_outlined, OcenePage()),
                  id == -1 ? Container() : SizedBox(height: 20),
                  id == -1
                      ? Container()
                      : menuButton("Podešavanja", Icons.settings, SettingsProfilenPage()),
                  id == -1 ? Container() : SizedBox(height: 20),
                  id == -1
                      ? menuButton("Prijavite se", Icons.login, LoginPage())
                      : menuButton("Odjavite se", Icons.logout, LoginPage()),
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  TextButton menuButton(tekst, ikonica, putanja) {
    return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xff59071a)),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(
                ikonica,
                color: Colors.white,
              ),
            ),
            Text(
              tekst,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
        onPressed: () {
          setState(() {
            if (tekst == "Odjavite se") {
              prefs.remove("id");
              prefs.remove("email");
              prefs.remove("firstname");
              prefs.remove("password");
              prefs.remove("lastname");
              prefs.remove("phone");
              prefs.remove("primaryAddress");
              prefs.remove("secondaryAddress");
              Navigator.pushReplacement(
                context,
                //PageTransition(type: PageTransitionType.rightToLeft, child: MessageUserPage())
                MaterialPageRoute(builder: (context) => putanja),
              );
            } else {
              Navigator.push(
                context,
                //PageTransition(type: PageTransitionType.rightToLeft, child: MessageUserPage())
                MaterialPageRoute(builder: (context) => putanja),
              );
            }
          });
        }
    );

  }
}
