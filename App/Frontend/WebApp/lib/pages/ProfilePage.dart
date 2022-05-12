import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_app/models/LikesModel.dart';
import 'package:flutter_app/models/PostModel.dart';
import 'package:flutter_app/models/UserModel.dart' as uss;
import 'package:flutter_app/pages/MessageUserPage.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utility/ThemeManager.dart';
import 'AddChoosing.dart';
import 'HomePage.dart';
import 'InboxPage.dart';
import 'LoginPage.dart';
import 'NotificationPage.dart';
import 'OcenePage.dart';
import 'SettingsProfilePage.dart';
import 'UserProfilePage.dart';
import 'WishlistPage.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';
  final idOwner;

  ProfilePage({Key key, this.title, this.idOwner}) : super(key: key);
  final String title;

  @override
  _ProfilePage createState() => _ProfilePage();
}

var list;
var listLikes;
var lajkovani;
var jaLajkovao;
uss.User usingUser;
var lista;
uss.Date usingDate;

class _ProfilePage extends State<ProfilePage> {
  bool oglasiIsExpanded = false;
  bool informationIsExpanded = false;
  bool loading = true;
  List<dynamic> listaLajkova;
  int brLajkova = 0;
  int brDislajkova = 0;
  SharedPreferences prefs;
  int id = -1;
  String email = "";
  String ime = "";
  String prezime = "";
  String telefon = "";
  String adresa = "";
  String sekundarnaAdresa = "";

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    list = await Provider.of<uss.UserModel>(context, listen: false);
    listLikes = await Provider.of<LikesModel>(context, listen: false);
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
          //ime = prefs.getString("firstname");
          prezime = prefs.getString("lastname");
          telefon = prefs.getString("phone");
          adresa = prefs.getString("primaryAddress");
          sekundarnaAdresa = prefs.getString("secondaryAddress");
          usingUser = list.getUserById(widget.idOwner);
          lista = list.loadDates([]);
          for (var i = 0; i < lista.length; i++) {
            if (lista[i].id == usingUser.id) {
              usingDate = lista[i];
              break;
            }
          }

          for (var i = 0; i < listaLajkova.length; i++) {
            if (listaLajkova[i].idUser == usingUser.id &&
                listaLajkova[i].isLiked == 1) {
              brLajkova++;
            }
          }
          for (var i = 0; i < listaLajkova.length; i++) {
            if (listaLajkova[i].idUser == usingUser.id &&
                listaLajkova[i].isLiked == 0) {
              brDislajkova++;
            }
          }
          loading = false;
        });
      });
    });
  }

  _launch(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  setLike(String poruka) async {
    await listLikes.addLike(id, usingUser.id, poruka);
  }

  setDislike(String poruka) async {
    await listLikes.addDislike(id, usingUser.id, poruka);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = GetSize.getMaxHeight(context);
    var screenWidth = GetSize.getMaxWidth(context);
    final _formKey = GlobalKey<FormState>();
    final myController = TextEditingController();
    return Scaffold(
      backgroundColor: Color(0xff59071a),
      appBar: AppBar(
        title: Text("Profil vlasnika oglasa"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff59071a),
      ), //0xff59071a
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
                                        backgroundImage:
                                        usingDate.pictures == "QmTwCcmKj5DFX3z28NQ3azfRsh1Zu4JczUXz8iUC9AcLB1" ? AssetImage(
                                          'images/empty.png',
                                        ) : NetworkImage(
                                          "http://147.91.204.116:11128/ipfs/${usingDate.pictures}",
                                        ),
                                        //AssetImage('images/profilnaSlika.jpg'),
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
                                        usingUser.firstname +
                                            "\n " +
                                            usingUser.lastname,
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
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          content: Stack(
                                                            overflow: Overflow
                                                                .visible,
                                                            children: <Widget>[
                                                              Positioned(
                                                                right: -40.0,
                                                                top: -40.0,
                                                                child:
                                                                    InkResponse(
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      CircleAvatar(
                                                                    child: Icon(
                                                                        Icons
                                                                            .close),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                ),
                                                              ),
                                                              Form(
                                                                key: _formKey,
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          TextField(
                                                                        controller:
                                                                            myController,
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          RaisedButton(
                                                                        child: Text(
                                                                            "Pošalji"),
                                                                        onPressed:
                                                                            () {
                                                                          setLike(
                                                                              myController.text);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                                child: Icon(
                                                  Icons.thumb_up_outlined,
                                                  color: Colors.green,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  padding: EdgeInsets.fromLTRB(
                                                      GetSize.getMaxWidth(
                                                              context) *
                                                          0.02,
                                                      GetSize.getMaxWidth(
                                                              context) *
                                                          0.018,
                                                      GetSize.getMaxWidth(
                                                              context) *
                                                          0.02,
                                                      GetSize.getMaxWidth(
                                                              context) *
                                                          0.018),
                                                ),
                                              )
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
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          content: Stack(
                                                            overflow: Overflow
                                                                .visible,
                                                            children: <Widget>[
                                                              Positioned(
                                                                right: -40.0,
                                                                top: -40.0,
                                                                child:
                                                                    InkResponse(
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      CircleAvatar(
                                                                    child: Icon(
                                                                        Icons
                                                                            .close),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                ),
                                                              ),
                                                              Form(
                                                                key: _formKey,
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          TextField(
                                                                        controller:
                                                                            myController,
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          RaisedButton(
                                                                        child: Text(
                                                                            "Pošalji"),
                                                                        onPressed:
                                                                            () {
                                                                          setDislike(
                                                                              myController.text);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                                child: Icon(
                                                  Icons.thumb_down_outlined,
                                                  color: Colors.red,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  padding: EdgeInsets.fromLTRB(
                                                      GetSize.getMaxWidth(
                                                              context) *
                                                          0.02,
                                                      GetSize.getMaxWidth(
                                                              context) *
                                                          0.018,
                                                      GetSize.getMaxWidth(
                                                              context) *
                                                          0.02,
                                                      GetSize.getMaxWidth(
                                                              context) *
                                                          0.018),
                                                ),
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
                                            "Datum uclanjivanja: ",
                                            style: Themes.TEXT_STYLE_MAIN,
                                          ),
                                          Text(
                                            "${usingDate.day}.${usingDate.month}.${usingDate.year}.",
                                            style: Themes.TEXT_STYLE_MAIN,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          ElevatedButton(
                                            child: Icon(
                                              Icons.phone,
                                              color: Color(0xff59091a),
                                            ),
                                            /*Text(
                                    "Pozovite\nkorisnika",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize:
                                            GetSize.getMaxHeight(context) *
                                                0.02),
                                  ),*/
                                            onPressed: () =>
                                                _launch('tel:' + telefon),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              padding: EdgeInsets.fromLTRB(
                                                  GetSize.getMaxWidth(context) *
                                                      0.02,
                                                  GetSize.getMaxWidth(context) *
                                                      0.018,
                                                  GetSize.getMaxWidth(context) *
                                                      0.02,
                                                  GetSize.getMaxWidth(context) *
                                                      0.018),
                                            ),
                                          ),
                                          Container(
                                            width: 7,
                                          ),
                                          ElevatedButton(
                                            child: Icon(
                                              Icons.message_rounded,
                                              color: Color(0xff59091a),
                                            ),
                                            /*Text(
                                    "Pozovite\nkorisnika",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize:
                                            GetSize.getMaxHeight(context) *
                                                0.02),
                                  ),*/
                                            onPressed: () =>
                                                _launch('sms:' + telefon),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              padding: EdgeInsets.fromLTRB(
                                                  GetSize.getMaxWidth(context) *
                                                      0.02,
                                                  GetSize.getMaxWidth(context) *
                                                      0.018,
                                                  GetSize.getMaxWidth(context) *
                                                      0.02,
                                                  GetSize.getMaxWidth(context) *
                                                      0.018),
                                            ),
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
                                        "Informacije",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
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
                                        "Svi oglasi",
                                        //textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                      children: [
                                        ListTile(
                                          title: Padding(
                                            padding: EdgeInsets.only(left:20),
                                            child: Text(
                                              "Ime: $ime\nPrezime: $prezime\nKorisničko ime: $email \nBroj telefona: $telefon",
                                              style: TextStyle(fontSize: 18),
                                              /*maxLines: 2,
                                    overflow: TextOverflow.ellipsis,*/
                                            ),
                                          ),
                                        ),
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
              : Row(
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
                              id == -1
                                  ? Container()
                                  : menuButton("Podešavanja", Icons.settings,
                                  SettingsProfilenPage()),
                              id == -1 ? Container() : SizedBox(height: 20),
                              SizedBox(height: 20),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Container(
                    width: screenWidth-200,
                  color: Color(0xffd5f5e7),
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
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 12),
                                      child: CircleAvatar(
                                        backgroundImage: (usingDate.pictures == "QmTwCcmKj5DFX3z28NQ3azfRsh1Zu4JczUXz8iUC9AcLB1" ? AssetImage(
                                          'images/empty.png',
                                        ) : NetworkImage(
                                          "http://147.91.204.116:11128/ipfs/${usingDate.pictures}",
                                        )),
                                        radius: GetSize.getMaxHeight(context) *
                                            0.12,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: Text(
                                        usingUser.firstname +
                                            "\n" +
                                            usingUser.lastname,
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
                                            left: GetSize.getMaxWidth(context) *
                                                0.14,
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
                                                    fontWeight: FontWeight.w400,
                                                  ),
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
                                                    fontWeight: FontWeight.w400,
                                                  ),
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
                                          Text("Datum uclanjivanja: "),
                                          Text(
                                              "${usingDate.day}.${usingDate.month}.${usingDate.year}."),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
                                            Container(
                                                width: GetSize.getMaxHeight(
                                                        context) *
                                                    5.5,
                                                child: Text("Ovo je neki opis"
                                                    "Ovo je neki opisOvo je neki opis"
                                                    "Ovo je neki opisOvo je neki opis"
                                                    "Ovo je neki opisOvo je neki opis"
                                                    "Ovo je neki opisOvo je neki opis"
                                                    "Ovo je neki opisOvo je neki opis"
                                                    "Ovo je neki opisOvo je neki opis"))
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
                                              trailing: Icon(
                                                informationIsExpanded
                                                    ? Icons.expand_less
                                                    : Icons.expand_more,
                                                color: Colors.black,
                                                size: 30.0,
                                              ),
                                              initiallyExpanded: false,
                                              title: Text(
                                                "Svi oglasi",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              children: [
                                                ListTile(
                                                  title: Text(
                                                    '''Ovo je neki opis
                                    Ovo je neki opisOvo je neki opis
                                    Ovo je neki opisOvo je neki opis
                                    Ovo je neki opisOvo je neki opis
                                    Ovo je neki opisOvo je neki opis
                                    Ovo je neki opisOvo je neki opis
                                    Ovo je neki opisOvo je neki opis''',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ),
                                                //style: TextStyle(fontSize: 18),
                                              ]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
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
              Icons.message_outlined,
              color: Colors.white,
            ),
            backgroundColor: Color(0xff59091a),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MessageUserPage(
                            chatUser: widget.idOwner,
                          )));
            },
            heroTag: null,
          ),
          SizedBox(
            height: 10,
          ),
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
