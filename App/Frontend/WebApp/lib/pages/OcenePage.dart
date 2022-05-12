import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_app/widgets/Ocena.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/LikesModel.dart';
import '../models/UserModel.dart';
import '../utility/GetSize.dart';
import '../utility/GetSize.dart';
import 'AddChoosing.dart';
import 'HomePage.dart';
import 'InboxPage.dart';
import 'LoginPage.dart';
import 'NotificationPage.dart';
import 'SettingsProfilePage.dart';
import 'UserProfilePage.dart';
import 'WishlistPage.dart';

class OcenePage extends StatefulWidget {
  static const routeName = '/profile';

  OcenePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _OcenePageState createState() => _OcenePageState();
}

class _OcenePageState extends State<OcenePage> {
  int totalLikeCount = 13;
  int totalDislikeCount = 0;
  int myLikeCount = 0;
  int myDislikeCount = 2;
  int otherLikeCount = 0;
  int otherDislikeCount = 0;
  var brojDisLajkova = "0";
  var brojLajkova = "0";
  var mojeOcene;
  var ocenioSam;
  bool loading = true;
  var listLikes;
  var listUsers;
  User korisnik;
  List<dynamic> listaLajkova;
  List<LikedUsers> mojiLajkovi = [];
  List<dynamic> listaJaLajkovao;
  List<IGraded> jaLajkovi = [];
  int brLajkova = 0;
  int brDislajkova = 0;

  var list;
  SharedPreferences prefs;
  int id;
  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getInt("id");
    listLikes = await Provider.of<LikesModel>(context, listen: false);
    listUsers = await Provider.of<UserModel>(context, listen: false);
    await listLikes.initiateSetup();
    await listUsers.initiateSetup();
    listaLajkova = await listLikes.loadLiked([]);
    listaJaLajkovao = await listLikes.loadILiked([]);
  }

  Future<String> BrojDisLajkova(BuildContext context) async {
    int brLajkova = 0;
    for (var i = 0; i < listaLajkova.length; i++) {
      if (listaLajkova[i].idUser == id && listaLajkova[i].isLiked == 0) {
        brLajkova++;
      }
    }
    for (var i = 0; i < listaLajkova.length; i++) {
      if (listaLajkova[i].idUser == id) mojiLajkovi.add(listaLajkova[i]);
    }
    for (var i = 0; i < listaJaLajkovao.length; i++) {
      if (listaJaLajkovao[i].idUser == id) jaLajkovi.add(listaJaLajkovao[i]);
    }
    return brLajkova.toString();
  }

  Future<String> BrojLajkova(BuildContext context) async {
    int brLajkova = 0;
    for (var i = 0; i < listaLajkova.length; i++) {
      if (listaLajkova[i].idUser == id && listaLajkova[i].isLiked == 1) {
        brLajkova++;
      }
    }
    return brLajkova.toString();
  }

  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.getSharedPrefs().then((result) {
        this.BrojLajkova(context).then((result) {
          setState(() {
            brojDisLajkova = result; //result;
          });
        }).then((value) => this
            .BrojDisLajkova(context)
            .then((result) {
              setState(() {
                brojLajkova = result;
              });
            })
            .then((value) => this.GetMyGradedList(context).then((result) {
                  setState(() {
                    mojeOcene = result;
                  });
                }))
            .then((value) => this.GetWhatIGradedList(context).then((result) {
                  setState(() {
                    ocenioSam = result;
                    loading = false;
                  });
                })));
      });
    });
  }

  @override
  _OcenePageState() {
    currentTabIndex = 0;
  }

  int currentTabIndex = 0; // 0 - total, 1 - my marks, 2 - other's marks

  Container positiveMark = Container(color: Colors.red, width: 200);

  DefaultTabController getDefaultTabController(BuildContext context) =>
      DefaultTabController(
          length: 2,
          child: SizedBox(
            height: 800,
            width: GetSize.getMaxWidth(context)-200,
            child: Scaffold(
                body: Column(
              children: <Widget>[
                SizedBox(
                  height: 74,
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    bottom: TabBar(
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                          icon: Icon(
                            Icons.thumbs_up_down_outlined,
                          ),
                          child: Text("Moje Ocene",
                              style: TextStyle(color: Colors.white)),
                        ),
                        Tab(
                          icon: Icon(Icons.thumbs_up_down),
                          child: Text("Ocenili Ste",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),

                // create widgets for each tab bar here
                Expanded(
                  child: TabBarView(
                    children: [
                      // first tab bar view widget
                      Container(
                        color: Color(0xffd5f5e7),
                        child: Column(
                          children: [
                            for (var grade in mojiLajkovi)
                              Ocena.ocena(
                                  listUsers.getNameById(grade.idLikedMe),
                                  grade.message,
                                  (grade.isLiked == 1) ? true : false,
                                  GetSize.getMaxWidth(context),
                                  GetSize.getMaxHeight(context)),
                          ],
                        ),
                      ),

                      // second tab bar viiew widget
                      Container(
                        color: Color(0xffd5f5e7),
                        child: Center(
                            child: Column(
                          children: [
                            for (var grade in jaLajkovi)
                              Ocena.ocena(
                                  listUsers.getNameById(grade.idILiked),
                                  grade.message,
                                  (grade.isLiked == 1) ? true : false,
                                  GetSize.getMaxWidth(context),
                                  GetSize.getMaxHeight(context)),
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ));

/*
  DefaultTabController myDefaultTabController = DefaultTabController(
    length: 2,
    child: TabBar(
      tabs: [
        Tab(
          icon: Icon(Icons.thumbs_up_down_outlined,),
          child: Text("Moje Ocene", style: TextStyle(color: Colors.white)),),
        Tab(
          icon: Icon(Icons.thumbs_up_down),
          child: Text("Ocenili Ste", style: TextStyle(color: Colors.white)),),
      ],
    ),
  );


  Container getTabController(BuildContext context) => Container(
    width: GetSize.getMaxWidth(context) * 0.8,
    decoration: BoxDecoration(
        color: Color(0xff59071a),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10)),
    ),
    child: DefaultTabController(
      length: 2,
      child: TabBar(
        tabs: [
          Tab(
            icon: Icon(Icons.thumbs_up_down_outlined,),
            child: Text("Moje Ocene", style: TextStyle(color: Colors.white)),),
          Tab(
              icon: Icon(Icons.thumbs_up_down),
            child: Text("Ocenili Ste", style: TextStyle(color: Colors.white)),),
        ],
      ),
    )
  );
*/
  // NE DIRAJ
  Container markContainer(String brojLajkova, String brojDisLajkova) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      height: 150,
      width: 200,
      decoration: BoxDecoration(
          color: Color(0xff59071a),
          border: Border.all(
            color: Color(0xff59071a),
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Center(
          child: SizedBox(
        width: 200,
        child: Container(
          padding: EdgeInsets.only(top: 30),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Column(children: [
                    Icon(
                      Icons.thumb_up_sharp,
                      size: 50,
                      color: Colors.greenAccent,
                    ),
                    Text(
                      brojLajkova,
                      //(getCurrentTabIndex() == 0 ? totalLikeCount : currentTabIndex == 1 ? myLikeCount : otherLikeCount).toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    )
                  ]),
                ),
                Container(
                  //color: Color(0xff59071a),
                  height: 100,
                  margin: EdgeInsets.only(left: 20),
                  child: Column(children: [
                    Icon(
                      Icons.thumb_down_sharp,
                      size: 50,
                      color: Colors.redAccent,
                    ),
                    Text(
                      brojDisLajkova,
                      //(currentTabIndex == 0 ? totalDislikeCount : currentTabIndex == 1 ? myDislikeCount : otherDislikeCount).toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    )
                  ]),
                )
              ]),
        ),
      )),
    );
  }

  Future<String> GetMyGradedList(BuildContext context) async {
    var broj = await listLikes.getMyGradedList(
        id, GetSize.getMaxWidth(context), GetSize.getMaxHeight(context));
    return broj;
  }

  Future<String> GetWhatIGradedList(BuildContext context) async {
    var broj = await listLikes.getWhatIGradedList(
        id, GetSize.getMaxWidth(context), GetSize.getMaxHeight(context));
    return broj;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff59071a),
      appBar: AppBar(
        title: Text("Ocene"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff59071a),
      ),
      body: loading
          ? Container(
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
          : Row(
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
                SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: GetSize.getMaxHeight(context) * 1.25,
                    width: GetSize.getMaxWidth(context)-200,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Color(0xffd5f5e7),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        child: Center(
                            child: markContainer(brojDisLajkova.toString(),
                                brojLajkova.toString())),
                      ),
                      Container(
                          child: Center(
                              child: getDefaultTabController(
                                  context))
                          )
                    ],
                  )
                ],
              ),
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
