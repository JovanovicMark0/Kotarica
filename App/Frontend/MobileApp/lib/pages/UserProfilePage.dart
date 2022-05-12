import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/models/LikesModel.dart';
import 'package:flutter_app/pages/HomePage.dart';
import 'package:flutter_app/pages/MessageUserPage.dart';
import 'package:flutter_app/pages/SettingsProfilePage.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_app/utility/ThemeManager.dart';
import 'package:flutter_app/widgets/navBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_app/widgets/Ocena.dart';

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
  var screenWidth;
  var screenHeight;
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
    screenHeight = GetSize.getMaxHeight(context);
    screenWidth = GetSize.getMaxWidth(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Moj Profil"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Themes.BACKGROUND_COLOR,
      ), //0xff59071a
      /*leading: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    left: GetSize.getMaxWidth(context) * 0.015),
                child: (Icon(Icons.arrow_back_ios)),
              ),
            ],
          )),*/
      body: loading
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
          : SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: GetSize.getMaxHeight(context) * 1.25,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Themes.LIGHT_BACKGROUND_COLOR,
                      /* uglovi na pozadini
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),*/
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  right: GetSize.getMaxHeight(context) * 0.05),
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 12, left: 10),
                                  child: CircleAvatar(
                                    backgroundImage: (usingDate.pictures == "QmTwCcmKj5DFX3z28NQ3azfRsh1Zu4JczUXz8iUC9AcLB1" ? AssetImage(
                                      'images/empty.png',
                                    ) : NetworkImage("http://147.91.204.116:11128/ipfs/${usingDate.pictures}",)),
                                    radius: GetSize.getMaxHeight(context) * 0.1,
                                  ),
                                ),
                              ), //profilna
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  /*margin: EdgeInsets.only(
                              left: GetSize.getMaxWidth(context) * 0.12,
                            ),*/
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
                                      /*margin: EdgeInsets.only(
                                  left: GetSize.getMaxWidth(context) * 0.17,
                                  top: GetSize.getMaxHeight(context) * 0.01,
                                ),*/
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Text(
                                              "$brLajkova",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                  color: Themes.INVERSE_MAIN),
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
                                      /*margin: EdgeInsets.only(
                                  left: GetSize.getMaxWidth(context) * 0.035,
                                  top: GetSize.getMaxHeight(context) * 0.01,
                                ),*/
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Text(
                                              "$brDislajkova",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                  color: Themes.INVERSE_MAIN),
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
                                  /*margin: EdgeInsets.only(
                                left: GetSize.getMaxWidth(context) * 0.12),*/
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
                            //OPIS EXPANDED

                            /*

                            dsad
                            ds
                            ad
                            asd
                            a
                            sd
                             */

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
                                        ? setState(() =>
                                            this.informationIsExpanded = true)
                                        : setState(() =>
                                            this.informationIsExpanded = false);
                                  },
                                  /*collapsedBackgroundColor:
                                      Themes.INVERSE_SECONDARY,*/
                                  trailing: Icon(
                                    informationIsExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: Themes.INVERSE_MAIN,
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
                                  "Ime: $ime\nPrezime: $prezime\nКоrisničko ime: $email \nBroj telefona: $telefon",
                          style: TextStyle(fontSize: 18),
                        ),
                  ),
                                    //style: TextStyle(fontSize: 18),
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
                            color: Themes.DIVIDER_COLOR,
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
                                  color: Themes.INVERSE_SECONDARY,
                                  borderRadius: BorderRadius.circular(10)),
                              child: ExpansionTile(
                                  onExpansionChanged: (isExpanded) {
                                    isExpanded
                                        ? setState(() =>
                                            this.informationIsExpanded = true)
                                        : setState(() =>
                                            this.informationIsExpanded = false);
                                  },
                                  //collapsedBackgroundColor: Colors.grey[200],
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
                                  (mojiLajkovi.length > 0) ?
                                    {for (var grade in mojiLajkovi)
                                      ListTile(title: Ocena.ocena(
                                          list.getNameById(grade.idLikedMe),
                                          grade.message,
                                          (grade.isLiked == 1) ? true : false,
                                          GetSize.getMaxWidth(context),
                                          GetSize.getMaxHeight(context)),
                                    //style: TextStyle(fontSize: 18),
                                      )}
                                    : ListTile(
                                        title: Text("Nemate nijednu ocenu",
                                        style: TextStyle(color: Colors.redAccent),)
                                      )
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

      /*bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Themes.BACKGROUND_COLOR,
        ),
        child: navBar,
      ),*/
    );
  }
}
