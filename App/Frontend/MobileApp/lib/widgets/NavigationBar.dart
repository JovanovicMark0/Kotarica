/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/AddNewPostPage.dart';
import 'package:flutter_app/pages/HomePage.dart';
import 'package:flutter_app/pages/KotaricaPage.dart';
import 'package:flutter_app/pages/LoginPage.dart';
import 'package:flutter_app/pages/ProfilePage.dart';
import 'package:flutter_app/pages/WishlistPage.dart';
import 'package:flutter_app/utility/PageEnum.dart';

PageController controller;

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar>
    with SingleTickerProviderStateMixin {

  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 400);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;
  List<dynamic> lista;
  @override
  void initState() {
    controller = PageController(initialPage: PageEnum.HOME_PAGE.index);
    super.initState();

    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  double iconSize = 22;
  double bottomMargin = 7;
  int _currentPage = 0;

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigationTapped(int page) {
    (context as Element).reassemble();
    controller.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.indigo, child: menu(context)),
          PageView(
          children: [
            Container(
              child: HomePage(),
            ),
            Container(
              child: WishlistPage(),
            ),
            Container(
              child: AddNewPostPage(),
            ),
            Container(
              child: KotaricaPage(),
            ),
            Container(
              child: ProfilePage(),
            ),
          ],
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: _onPageChanged,
        ),
      ]),
      bottomNavigationBar: SizedBox(
        height: 63, // VISINA NAVIGACIONOG BAR-A
        child: CupertinoTabBar(
          border: Border(top: BorderSide(color: Colors.transparent)),
          iconSize: 30,
          backgroundColor: Themes.BACKGROUND_COLOR,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              // ignore: deprecated_member_use
                title: Container(
                  margin: EdgeInsets.only(bottom: bottomMargin),
                  child: Text(
                    "Početna",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                tooltip: "Prikaži sve aktuelne oglase.",
                //label: "Početna",
                icon: Icon(Icons.home, size: iconSize)
              //title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              tooltip: "Prikaži sve željene oglase.",
              // ignore: deprecated_member_use
              title: Container(
                margin: EdgeInsets.only(bottom: bottomMargin),
                child: Text(
                  "Lista Želja",
                  style: TextStyle(fontSize: 12),
                ),
              ),
              icon: Icon(Icons.favorite, size: iconSize),
              //title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              tooltip: "Postavi novi oglas.",
              // ignore: deprecated_member_use
              title: Container(
                margin: EdgeInsets.only(bottom: bottomMargin),
                child: Text(
                  "Dodaj Oglas",
                  style: TextStyle(fontSize: 12),
                ),
              ),
              icon: Icon(Icons.post_add_outlined, size: iconSize),
              //title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              tooltip: "Prikaži sve oglase koje pratite.",
              // ignore: deprecated_member_use
              title: Container(
                margin: EdgeInsets.only(bottom: bottomMargin),
                child: Text(
                  "Korpa",
                  style: TextStyle(fontSize: 12),
                ),
              ),
              icon: Icon(Icons.shopping_cart_sharp, size: iconSize),
              //title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              tooltip: "Prikaži svoj profil.",
              // ignore: deprecated_member_use
              title: Container(
                margin: EdgeInsets.only(bottom: bottomMargin),
                child: Text(
                  "Profil",
                  style: TextStyle(fontSize: 12),
                ),
              ),
              icon: Icon(Icons.person_sharp, size: iconSize),
              //title: Container(height: 0.0),
            ),
          ],
          onTap: (index) {
            _navigationTapped(index);
          },
          currentIndex: _currentPage,
        )
      ),
    ));
  }

  TextButton menuButton(tekst, putanja) {
    return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Themes.BACKGROUND_COLOR),
        ),
        child: Row(
          children: <Widget>[
            Text(
              'Odjavi se',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            )
          ],
        ),
        onPressed: () {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => putanja),
            );
          });
        });
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                menuButton("Odjavi se", LoginPage()),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

}*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/pages/AddNewAuctionPage.dart';
import 'package:flutter_app/pages/AddNewPostPage.dart';
import 'package:flutter_app/pages/HomePage.dart';
import 'package:flutter_app/pages/NotificationPage.dart';
import 'package:flutter_app/pages/AddChoosing.dart';
import 'package:flutter_app/pages/OcenePage.dart';
import 'package:flutter_app/pages/ProfilePage.dart';
import 'package:flutter_app/pages/UserProfilePage.dart';
import 'package:flutter_app/pages/WishlistPage.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_app/utility/PageEnum.dart';
import 'package:flutter_app/utility/ThemeManager.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';

PageController controller;

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();

  // Animacija sadrzaja sendvic menija
  // IZMENITI DA OVAKO LEPO SLAJDUJE
  static Route toOcenePage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => OcenePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-2.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
//

}

class _NavigationBarState extends State<NavigationBar>
    with SingleTickerProviderStateMixin {
  double iconSize = 22;
  double bottomMargin = 7;
  int _currentPage = 0;
  bool isGuestUser = true;
  SharedPreferences prefs;
  int idPrefs = -1;
  String emailPrefs = "";
  String imePrefs = "";
  String sifraPrefs = "";
  String prezimePrefs = "";
  String telefonPrefs = "";
  String adresaPrefs = "";
  String sekundarnaAdresaPrefs = "";

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.getSharedPrefs().then((result) {
        setState(() {
          idPrefs = prefs.getInt("id");
          emailPrefs = prefs.getString("email");
          imePrefs = prefs.getString("firstname");
          sifraPrefs = prefs.getString("password");
          prezimePrefs = prefs.getString("lastname");
          telefonPrefs = prefs.getString("phone");
          adresaPrefs = prefs.getString("primaryAddress");
          sekundarnaAdresaPrefs = prefs.getString("secondaryAddress");
          if (idPrefs != -1) isGuestUser = false;
        });
      });
    });
    controller = PageController(initialPage: PageEnum.HOME_PAGE.index);
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigationTapped(int page) {
    (context as Element).reassemble();
    controller.jumpToPage(page);
  }

  Scaffold emptyPage() {
    return Scaffold(
        body: Center(
            child: Text(
      "Molimo prijavite se na nalog.",
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      body: Stack(children: [
        PageView(
          children: [
            Container(
              child: HomePage(),
            ),
            Container(
              child: WishlistPage(),
            ),
            Container(
              child: AddChoosing(),
              // child: AddNewPostPage(),
            ),
            Container(
              child: NotificationPage(),
            ),
            Container(
              child: UserProfilePage(),
            ),
          ],
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: _onPageChanged,
        ),
      ]),
      bottomNavigationBar: SizedBox(
          height: 63, // VISINA NAVIGACIONOG BAR-A
          child: CupertinoTabBar(
            border: Border(top: BorderSide(color: Colors.transparent)),
            iconSize: 30,
            activeColor: Colors.amber[800],
            inactiveColor: Colors.white,
            //inactiveColor: isGuestUser ? Colors.grey : Colors.white,
            backgroundColor: Themes.BACKGROUND_COLOR,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  // ignore: deprecated_member_use
                  title: Container(
                    margin: EdgeInsets.only(bottom: bottomMargin),
                    child: Text(
                      "Početna",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  tooltip: "Prikaži sve aktuelne oglase.",
                  //label: "Početna",
                  icon: Icon(Icons.home, size: iconSize)
                  //title: Container(height: 0.0),
                  ),
              BottomNavigationBarItem(
                tooltip: "Prikaži sve željene oglase.",
                // ignore: deprecated_member_use
                title: Container(
                  margin: EdgeInsets.only(bottom: bottomMargin),
                  child: Text(
                    "Lista želja",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                icon:Icon(Icons.bookmark, size: iconSize),
                //title: Container(height: 0.0),
              ),
              BottomNavigationBarItem(
                tooltip: "Postavi novi oglas.",
                // ignore: deprecated_member_use
                title: Container(
                  margin: EdgeInsets.only(bottom: bottomMargin),
                  child: Text(
                    "Dodaj oglas",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                icon: Icon(Icons.post_add_outlined),
                //title: Container(height: 0.0),
              ),
              BottomNavigationBarItem(
                //tooltip: "Prikaži sve oglase koje pratite.",
                // ignore: deprecated_member_use
                title: Container(
                  key: Key("guest1"),
                  margin: EdgeInsets.only(bottom: bottomMargin),
                  child: Text(
                    "Obaveštenja",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                icon: Icon(Icons.notifications, size: iconSize),
                //title: Container(height: 0.0),
              ),
              BottomNavigationBarItem(
                tooltip: "Prikaži svoj profil.",
                // ignore: deprecated_member_use
                title: Container(
                  margin: EdgeInsets.only(bottom: bottomMargin),
                  child: Text(
                    "Moj profil",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                icon: Icon(Icons.person_sharp, size: iconSize),
                //title: Container(height: 0.0),
              ),
            ],
            onTap: (index) {
              //isGuestUser = true;
              if (!isGuestUser) {
                // jeste prijavljen korisnik
                _navigationTapped(index);
              } else if (index == PageEnum.HOME_PAGE.index) {
                _navigationTapped(index);
              } else {}
            },
            currentIndex: _currentPage,
          )),
    ));
  }

/*
  void setPageOnTap(BuildContext context){
    switch(_currentPage){
      case PageEnum.HOME_PAGE:
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
        break;
      case PageEnum.WISHLIST_PAGE:
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => WishlistPage()));
        break;
      case PageEnum.ADD_NEW_PAGE:
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewPostPage()));
        break;
      case PageEnum.KOTARICA_PAGE:
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => KotaricaPage()));
        break;
      case PageEnum.PROFILE_PAGE:
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
        break;
    }
  }*/
}
