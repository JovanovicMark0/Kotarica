import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/models/LikesModel.dart';
import 'package:flutter_app/pages/HomePage.dart';
import 'package:flutter_app/pages/MessageUserPage.dart';
import 'package:flutter_app/pages/SettingsProfilePage.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_app/utility/ThemeManager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_app/widgets/Ocena.dart';

import 'AddChoosing.dart';
import 'InboxPage.dart';
import 'LoginPage.dart';
import 'NotificationPage.dart';
import 'OcenePage.dart';
import 'WishlistPage.dart';

class UserProfilePage extends StatefulWidget {
  static const routeName = '/profile';

  UserProfilePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

var list;
var lista;
Date usingDate;
var listLikes;
var brLajkova;
var brDislajkova;

class _UserProfilePageState extends State<UserProfilePage> {
  bool oglasiIsExpanded = false;
  bool informationIsExpanded = false;

  bool loading = true;
  SharedPreferences prefs;
  int id = -1;
  String email = "";
  String ime = "";
  String prezime = "";
  String telefon = "";
  String adresa = "";
  String sekundarnaAdresa = "";
  List<dynamic> listaLajkova = [];
  List<LikedUsers> mojiLajkovi = [];
  int brLajkova = 0;
  int brDislajkova = 0;

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    list = Provider.of<UserModel>(context, listen: false);
    listLikes = Provider.of<LikesModel>(context, listen: false);
    await list.initiateSetup();
    await listLikes.initiateSetup();
    listaLajkova = await listLikes.loadLiked([]);
  }

  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.getSharedPrefs().then((result) {
        setState(() {
          id = prefs.getInt("id");
          email = prefs.getString("email");
          ime = prefs.getString("firstname");
          prezime = prefs.getString("lastname");
          telefon = prefs.getString("phone");
          adresa = prefs.getString("primaryAddress");
          sekundarnaAdresa = prefs.getString("secondaryAddress");
          lista = list.loadDates([]);
          for (var i = 0; i < lista.length; i++) {
            if (lista[i].id == id) {
              usingDate = lista[i];
              break;
            }
          }
          brLajkova = 0;
          brDislajkova = 0;
          for (var i = 0; i < listaLajkova.length; i++) {
            //print("Iz inita ${listaLajkova[i].idUser}");
            if (listaLajkova[i].idUser == id && listaLajkova[i].isLiked == 1) {
              brLajkova++;
            }
          }
          for (var i = 0; i < listaLajkova.length; i++) {
            if (listaLajkova[i].idUser == id && listaLajkova[i].isLiked == 0) {
              brDislajkova++;
            }
          }

          for (var i = 0; i < listaLajkova.length; i++) {
            if (listaLajkova[i].idUser == id) mojiLajkovi.add(listaLajkova[i]);
          }

          loading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = GetSize.getMaxWidth(context);
    double screenHeight = GetSize.getMaxHeight(context);
    return Scaffold(
      backgroundColor: Color(0xff59071a),
        appBar: AppBar(
        title: Text("Moj profil"),
        //automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff59071a),
        ),
    body: loading
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
          : screenWidth < 700
              ? SingleChildScrollView(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: GetSize.getMaxHeight(context) * 1.25,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Themes.LIGHT_BACKGROUND_COLOR,
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      right:
                                          GetSize.getMaxHeight(context) * 0.05),
                                  child: Center(
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: 12, left: 10),
                                      child: CircleAvatar(
                                        backgroundImage: (usingDate.pictures == "QmTwCcmKj5DFX3z28NQ3azfRsh1Zu4JczUXz8iUC9AcLB1" ? AssetImage(
                                          'images/empty.png',
                                        ) : NetworkImage("http://147.91.204.116:11128/ipfs/${usingDate.pictures}",)),
                                        radius:
                                            GetSize.getMaxHeight(context) * 0.1,
                                      ),
                                    ),
                                  ), //profilna
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        ime + "\n" + prezime,
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Text(
                                                  "$brLajkova",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          Themes.INVERSE_MAIN),
                                                ),
                                              ),
                                              Container(
                                                child: Icon(
                                                  Icons.thumb_up_outlined,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Text(
                                                  "$brDislajkova",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          Themes.INVERSE_MAIN),
                                                ),
                                              ),
                                              Container(
                                                child: Icon(
                                                    Icons.thumb_down_outlined,
                                                    color: Colors.red[400]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Datum učlanjivanja: ",
                                            style: Themes.TEXT_STYLE_MAIN,
                                          ),
                                          Text(
                                            "${usingDate.day}.${usingDate.month}.${usingDate.year}.",
                                            style: Themes.TEXT_STYLE_MAIN,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ], // gornji deo
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: GetSize.getMaxHeight(context) * 0.03,
                              ),
                              child: Divider(
                                height: GetSize.getMaxWidth(context) * 0.048,
                                color: Themes.DIVIDER_COLOR,
                              ),
                            ),
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: GetSize.getMaxHeight(context) * 0.01,
                                  bottom: GetSize.getMaxHeight(context) * 0.01,
                                ),
                                width: GetSize.getMaxWidth(context) * 0.9,
                                constraints: new BoxConstraints(
                                  maxWidth: 600.0,
                                ),
                                child: Container(
                                  decoration: new BoxDecoration(
                                      color: Themes.INVERSE_SECONDARY,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ExpansionTile(
                                      onExpansionChanged: (isExpanded) {
                                        isExpanded
                                            ? setState(() => this
                                                .informationIsExpanded = true)
                                            : setState(() => this
                                                .informationIsExpanded = false);
                                      },
                                      collapsedBackgroundColor:
                                          Themes.INVERSE_SECONDARY,
                                      trailing: Icon(
                                        informationIsExpanded
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                        color: Themes.INVERSE_SECONDARY,
                                        size: 30.0,
                                      ),
                                      initiallyExpanded: false,
                                      title: Text(
                                        "Informacije",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Themes.INVERSE_MAIN,
                                        ),
                                      ),
                                      children: [
                                        ListTile(
                                              title: Text(
                                                "Ime: $ime\nPrezime: $prezime\nKorisničko ime: $email \nBroj telefona: $telefon",
                                                style: TextStyle(fontSize: 18),
                                              )
                                          ),
                                      ]),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  //top: GetSize.getMaxHeight(context) * 0.03,
                                  ),
                              child: Divider(
                                height: GetSize.getMaxWidth(context) * 0.048,
                                color: Colors.grey,
                              ),
                            ),
                            Center(
                              child: Container(
                                //OPIS EXPANDED
                                margin: EdgeInsets.only(
                                  top: GetSize.getMaxHeight(context) * 0.01,
                                  bottom: GetSize.getMaxHeight(context) * 0.01,
                                ),
                                width: GetSize.getMaxWidth(context) * 0.9,
                                constraints: new BoxConstraints(
                                  maxWidth: 600.0,
                                ),
                                child: Container(
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ExpansionTile(
                                      onExpansionChanged: (isExpanded) {
                                        isExpanded
                                            ? setState(() => this
                                                .informationIsExpanded = true)
                                            : setState(() => this
                                                .informationIsExpanded = false);
                                      },
                                      trailing: Icon(
                                        informationIsExpanded
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                        color: Themes.INVERSE_MAIN,
                                        size: 30.0,
                                      ),
                                      initiallyExpanded: false,
                                      title: Text(
                                        "Ocene",
                                        //textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Themes.INVERSE_MAIN,
                                        ),
                                      ),
                                      children: [
                                        for (var grade in mojiLajkovi)
                                          Ocena.ocena(
                                              list.getNameById(grade.idLikedMe),
                                              grade.message,
                                              (grade.isLiked == 1)
                                                  ? true
                                                  : false,
                                              GetSize.getMaxWidth(context),
                                              GetSize.getMaxHeight(context)),
                                        //style: TextStyle(fontSize: 18),
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              :Row(
                children: <Widget>[
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
                                : menuButton(
                                "Početna", Icons.home, HomePage()),
                            id == -1 ? Container() : SizedBox(height: 20),
                            id == -1
                                ? Container()
                                : menuButton("Moj profil",
                                Icons.person_sharp, UserProfilePage()),
                            id == -1 ? Container() : SizedBox(height: 20),
                            id == -1
                                ? Container()
                                : menuButton("Moje poruke",
                                Icons.messenger_outline, InboxPage()),
                            id == -1 ? Container() : SizedBox(height: 20),
                            // menuButton("Moji oglasi", CupertinoIcons.square_list_fill, LoginPage()),
                            // SizedBox(height: 20),
                            id == -1
                                ? Container()
                                : menuButton("Dodaj Oglas",
                                Icons.post_add_outlined, AddChoosing()),
                            id == -1 ? Container() : SizedBox(height: 20),
                            id == -1
                                ? Container()
                                : menuButton("Lista Želja", Icons.bookmark,
                                WishlistPage()),
                            id == -1 ? Container() : SizedBox(height: 20),
                            menuButton("Obaveštenja", Icons.notifications,
                                NotificationPage()),
                            SizedBox(height: 20),
                            id == -1
                                ? Container()
                                : menuButton(
                                "Ocene",
                                Icons.thumbs_up_down_outlined,
                                OcenePage()),
                            id == -1 ? Container() : SizedBox(height: 20),
                            /*id == -1
                                ? Container()
                                : menuButton("Podešavanja", Icons.settings,
                                SettingsProfilenPage()),*/
                            id == -1 ? Container() : SizedBox(height: 20),
                            SizedBox(height: 20),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                  color: Color(0xffd5f5e7),
                  width: screenWidth-200,
                  child: Stack(
                    children: <Widget>[
                      Container(
                          child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 12, left:screenWidth*0.25, right: screenWidth*0.05, bottom: screenWidth*0.03),
                                      child: CircleAvatar(
                                        backgroundImage: (usingDate.pictures == "QmTwCcmKj5DFX3z28NQ3azfRsh1Zu4JczUXz8iUC9AcLB1" ? AssetImage(
                                          'images/empty.png',
                                        ) : NetworkImage("http://147.91.204.116:11128/ipfs/${usingDate.pictures}",)),
                                        radius: GetSize.getMaxHeight(context) *
                                            0.12,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            ime + " " + prezime,
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                /*left: GetSize.getMaxWidth(context) *
                                                    0.14,*/
                                                top: GetSize.getMaxHeight(context) *
                                                    0.05,
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      "$brLajkova",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          color:
                                                          Themes.INVERSE_MAIN),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Icon(
                                                      Icons.thumb_up_outlined,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 50,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                right:
                                                GetSize.getMaxWidth(context) *
                                                    0.01,
                                                top: GetSize.getMaxHeight(context) *
                                                    0.05,
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      "$brDislajkova",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          color:
                                                          Themes.INVERSE_MAIN),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Icon(
                                                        Icons.thumb_down_outlined,
                                                        color: Colors.red[400]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                "Datum učlanjivanja: ",
                                                style: Themes.TEXT_STYLE_MAIN,
                                              ),
                                              Text(
                                                "${usingDate.day}.${usingDate.month}.${usingDate.year}.",
                                                style: Themes.TEXT_STYLE_MAIN,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              children: [
                                Container(
                                    width:
                                    GetSize.getMaxHeight(context) * 2.5,
                                    constraints: new BoxConstraints(
                                      maxWidth: 1000.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Informacije",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left:20),
                                          child: Container(
                                              width: GetSize.getMaxHeight(
                                                  context) *
                                                  5.5,
                                              child: Text("Ime: $ime\nPrezime: $prezime\nKorisničko ime: $email \nBroj telefona: $telefon",)),
                                        )
                                      ],
                                    )),
                                Center(
                                  child: Container(
                                    //OPIS EXPANDED
                                    margin: EdgeInsets.only(
                                      top: GetSize.getMaxHeight(context) *
                                          0.1,
                                      bottom:
                                      GetSize.getMaxHeight(context) *
                                          0.01,
                                    ),
                                    width:
                                    GetSize.getMaxWidth(context) * 0.9,
                                    constraints: new BoxConstraints(
                                      maxWidth: 1000.0,
                                    ),
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        //color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      child: ExpansionTile(
                                          onExpansionChanged: (isExpanded) {
                                            isExpanded
                                                ? setState(() =>
                                            this.informationIsExpanded =
                                            true)
                                                : setState(() =>
                                            this.informationIsExpanded =
                                            false);
                                          },
                                          //collapsedBackgroundColor: Colors.grey[200],
                                          trailing: Icon(
                                            informationIsExpanded
                                                ? Icons.expand_less
                                                : Icons.expand_more,
                                            color: Colors.black,
                                            size: 30.0,
                                          ),
                                          initiallyExpanded: false,
                                          title: Text(
                                            "Ocene",
                                            //textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                          children: [
                                            for (var grade in mojiLajkovi)
                                              Ocena.ocena(
                                                  list.getNameById(
                                                      grade.idLikedMe),
                                                  grade.message,
                                                  (grade.isLiked == 1)
                                                      ? true
                                                      : false,
                                                  GetSize.getMaxWidth(
                                                      context),
                                                  GetSize.getMaxHeight(
                                                      context)),
                                          ]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
                ],
              ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            backgroundColor: Themes.BACKGROUND_COLOR,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsProfilenPage()));
            },
          )
        ],
      ),
    );
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
