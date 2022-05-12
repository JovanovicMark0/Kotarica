import 'package:flutter/material.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_app/utility/ThemeManager.dart';

//import 'package:flutter_app/widgets/navBar.dart';

class KotaricaPage extends StatefulWidget {
  static const routeName = '/kotarica';
  KotaricaPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _KotaricaPage createState() => _KotaricaPage();
}

class _KotaricaPage extends State<KotaricaPage> {
  bool descriptionIsExpanded = false;
  bool informationIsExpanded = false;

  @override
  Widget build(BuildContext context) {
    //double screenHeight = GetSize.getMaxHeight(context);
    //double screenWidth = GetSize.getMaxWidth(context);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Obaveštenja"),
          centerTitle: true,
          backgroundColor: Themes.BACKGROUND_COLOR,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Container(
              //height: GetSize.getMaxHeight(context) * 1.5,
              width: GetSize.getMaxWidth(context),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Themes.LIGHT_BACKGROUND_COLOR,
              ),
              child: Container(
                height: GetSize.getMaxHeight(context) - 139,
                child: Center(
                  child: Text(
                  "Trenutno nemate nikakva obaveštenja",
                  style: Themes.TEXT_STYLE_MAIN,
                  ),
                ),
              ) /*Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          bottom: 30, top: 10, left: 10, right: 10),
                      decoration: new BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Color(0xffbbd7cb), width: 1)),
                        //color: Themes.LIGHT_BACKGROUND_COLOR
                      ),
                      child: ExpansionTile(
                        backgroundColor: Themes.LIGHT_BACKGROUND_COLOR,
                        onExpansionChanged: (isExpanded) {
                          isExpanded
                              ? setState(
                                  () => this.informationIsExpanded = true)
                              : setState(
                                  () => this.informationIsExpanded = false);
                        },
                        //collapsedBackgroundColor: Colors.grey[200],
                        trailing: Icon(
                          informationIsExpanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Colors.black,
                          size: 20.0,
                        ),
                        initiallyExpanded: false,
                        title: Text(
                          "Sortiraj po",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        children: [
                          ListTile(
                            title: Text(
                              "Nazivu(A-Z)",
                            ),
                          ),
                          ListTile(
                            title: Text(
                              "Nazivu(Z-A)",
                            ),
                          ),
                          ListTile(
                            title: Row(
                              children: <Widget>[
                                Text("Ceni"),
                                Icon(Icons.arrow_upward),
                              ],
                            ),
                          ),
                          ListTile(
                            title: Row(
                              children: <Widget>[
                                Text("Ceni"),
                                Icon(Icons.arrow_downward),
                              ],
                            ),
                          ),
                          ListTile(
                            title: Row(
                              children: <Widget>[
                                Text("Vremenu"),
                                Icon(Icons.arrow_upward),
                              ],
                            ),
                          ),
                          ListTile(
                            title: Row(
                              children: <Widget>[
                                Text("Vremenu"),
                                Icon(Icons.arrow_downward),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*Container(
                      margin: EdgeInsets.only(bottom: 10),
                      height: GetSize.getMaxHeight(context) * 0.18,
                      width: GetSize.getMaxWidth(context) * 0.94,
                      decoration: BoxDecoration(
                        color: Color(0xff5f968e),
                        borderRadius: BorderRadius.all(Radius.circular(30.00)),
                      ),
                      child: Center(
                        child: Row(children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(4.0),
                            width: GetSize.getMaxWidth(context) * 0.35,
                            height: GetSize.getMaxHeight(context) * 0.20,
                            decoration: BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: new DecorationImage(
                                image: new ExactAssetImage(
                                    'images/oglasSlike.jpg'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(500.0)),
                              border: new Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.05),
                                child: Column(
                                  children: [
                                    Text(
                                      "BMW 530 3.0 xDrive ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      "Licitacija",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      "Preostalo vreme:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      "1d 5s 50m",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),*/
                    oglas(context),
                    oglas(context),
                    oglas(context),
                    oglas(context),
                    oglas(context),
                  ]))*/,
    )));
  }
}
/*GetSize.getMaxWidth(context) < 500
        ? Scaffold(
            appBar: AppBar(
              //title: Image.asset("images/logo.png", fit: BoxFit.contain),
              leading: Icon(Icons.menu),
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.search),
                ),
                Icon(Icons.notifications),
                Container(
                  margin: EdgeInsets.all(5.0),
                ),
              ],
              backgroundColor: Color(0xff59071a),
            ),
            body: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: GetSize.getMaxHeight(context) * 1.3,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Themes.LIGHT_BACKGROUND_COLOR,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuctionPage()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height:
                                    GetSize.getMaxHeight(context) * 0.18,
                                width: GetSize.getMaxWidth(context) * 0.94,
                                decoration: BoxDecoration(
                                  color: Color(0xff5f968e),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.00)),
                                ),
                                child: Center(
                                  child: Row(children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(4.0),
                                      width: GetSize.getMaxWidth(context) *
                                          0.35,
                                      height:
                                          GetSize.getMaxHeight(context) *
                                              0.20,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff7c94b6),
                                        image: new DecorationImage(
                                          image: new ExactAssetImage(
                                              'images/oglasSlike.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(500.0)),
                                        border: new Border.all(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05),
                                          child: Column(
                                            children: [
                                              Text(
                                                "BMW 530 3.0 xDrive ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                "Licitacija",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                "Preostalo vreme:",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                "1d 5s 50m",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: GetSize.getMaxHeight(context) * 0.02,
                        ),
                        //DRUGI RED
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuctionPage()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height:
                                    GetSize.getMaxHeight(context) * 0.18,
                                width: GetSize.getMaxWidth(context) * 0.94,
                                decoration: BoxDecoration(
                                  color: Color(0xff5f968e),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.00)),
                                ),
                                child: Center(
                                  child: Row(children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(4.0),
                                      width: GetSize.getMaxWidth(context) *
                                          0.35,
                                      height:
                                          GetSize.getMaxHeight(context) *
                                              0.20,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff7c94b6),
                                        image: new DecorationImage(
                                          image: new ExactAssetImage(
                                              'images/oglasSlike.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(500.0)),
                                        border: new Border.all(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05),
                                          child: Column(
                                            children: [
                                              Text(
                                                "BMW 530 3.0 xDrive ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                "Licitacija",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                "Preostalo vreme:",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                "1d 5s 50m",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: GetSize.getMaxHeight(context) * 0.02,
                        ),
                        //DRUGI RED
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuctionPage()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height:
                                    GetSize.getMaxHeight(context) * 0.18,
                                width: GetSize.getMaxWidth(context) * 0.94,
                                decoration: BoxDecoration(
                                  color: Color(0xff5f968e),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.00)),
                                ),
                                child: Center(
                                  child: Row(children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(4.0),
                                      width: GetSize.getMaxWidth(context) *
                                          0.35,
                                      height:
                                          GetSize.getMaxHeight(context) *
                                              0.20,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff7c94b6),
                                        image: new DecorationImage(
                                          image: new ExactAssetImage(
                                              'images/oglasSlike.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(500.0)),
                                        border: new Border.all(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05),
                                          child: Column(
                                            children: [
                                              Text(
                                                "BMW 530 3.0 xDrive ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                "Licitacija",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                "Preostalo vreme:",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                "1d 5s 50m",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ), //Treci
                        ),
                        Container(
                          height: GetSize.getMaxHeight(context) * 0.02,
                        ),
                        //DRUGI RED
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuctionPage()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height:
                                    GetSize.getMaxHeight(context) * 0.18,
                                width: GetSize.getMaxWidth(context) * 0.94,
                                decoration: BoxDecoration(
                                  color: Color(0xff5f968e),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.00)),
                                ),
                                child: Center(
                                  child: Row(children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(4.0),
                                      width: GetSize.getMaxWidth(context) *
                                          0.35,
                                      height:
                                          GetSize.getMaxHeight(context) *
                                              0.20,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff7c94b6),
                                        image: new DecorationImage(
                                          image: new ExactAssetImage(
                                              'images/oglasSlike.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(500.0)),
                                        border: new Border.all(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05),
                                          child: Column(
                                            children: [
                                              Text(
                                                "BMW 530 3.0 xDrive ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                "Licitacija",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                "Preostalo vreme:",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                "1d 5s 50m",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ), //PETI
                        ),
                        Container(
                          height: GetSize.getMaxHeight(context) * 0.02,
                        ),
                        //DRUGI RED
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height:
                                    GetSize.getMaxHeight(context) * 0.18,
                                width: GetSize.getMaxWidth(context) * 0.94,
                                decoration: BoxDecoration(
                                  color: Color(0xff5f968e),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.00)),
                                ),
                                child: Center(
                                  child: Row(children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(4.0),
                                      width: GetSize.getMaxWidth(context) *
                                          0.35,
                                      height:
                                          GetSize.getMaxHeight(context) *
                                              0.20,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff7c94b6),
                                        image: new DecorationImage(
                                          image: new ExactAssetImage(
                                              'images/oglasSlike.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(500.0)),
                                        border: new Border.all(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05),
                                          child: Column(
                                            children: [
                                              Text(
                                                "BMW 530 3.0 xDrive ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                "Licitacija",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                "Preostalo vreme:",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                "1d 5s 50m",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ), //SESTI
                        ),
                        Container(
                          height: GetSize.getMaxHeight(context) * 0.02,
                        ),
                        //DRUGI RED
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuctionPage()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height:
                                    GetSize.getMaxHeight(context) * 0.18,
                                width: GetSize.getMaxWidth(context) * 0.94,
                                decoration: BoxDecoration(
                                  color: Color(0xff5f968e),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.00)),
                                ),
                                child: Center(
                                  child: Row(children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(4.0),
                                      width: GetSize.getMaxWidth(context) *
                                          0.35,
                                      height:
                                          GetSize.getMaxHeight(context) *
                                              0.20,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff7c94b6),
                                        image: new DecorationImage(
                                          image: new ExactAssetImage(
                                              'images/oglasSlike.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(500.0)),
                                        border: new Border.all(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05),
                                          child: Column(
                                            children: [
                                              Text(
                                                "BMW 530 3.0 xDrive ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                "Licitacija",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                "Preostalo vreme:",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                "1d 5s 50m",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //KRAJ
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                // sets the background color of the `BottomNavigationBar`
                canvasColor: Color(0xff59071a),
              ),
              child: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bookmark),
                    label: 'Bookmark',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.post_add_outlined),
                    label: 'Add',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart_sharp),
                    label: 'Cart',
                    backgroundColor: Colors.red,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_sharp),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.amber[800],
                onTap: (currentIndex) {
                  if (currentIndex == 0)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  else
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                },
              ),
            ),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Column(
                    children: [
                      Row(
                        // osnovni red
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[500],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    // SLIKA
                                    height: GetSize.getMaxHeight(context) *
                                        0.05,
                                    child: Image.asset('images/logo.png'),
                                  ), // SLIKA
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          child: Text("Najnoviji oglasi"),
                                        ),
                                        Container(
                                          child: Text("Vas profil"),
                                        ),
                                        Container(
                                          child: Text("Pomoc"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ), // prvi red
                          Row(children: []),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text("Kategorija 1"),
                          Text("Kategorija 2"),
                          Text("Kategorija 3"),
                          Text("Kategorija 4"),
                          Text("Kategorija 5"),
                          Text("Kategorija 6"),
                          Text("Kategorija 7"),
                          Text("Kategorija 8"),
                          Text("Kategorija 9"),
                          Text("Kategorija 10"),
                          Text("Kategorija 11"),
                          Text("Kategorija 12"),
                          Text("Kategorija 13"),
                          Text("Kategorija 14"),
                          Text("Kategorija 15"),
                          Text("Kategorija 16"),
                          Text("Kategorija 17"),
                          Text("Kategorija 18"),
                          Text("Kategorija 19"),
                          Text("Kategorija 20"),
                          Text("Kategorija 21"),
                          Text("Kategorija 22"),
                          Text("Kategorija 23"),
                        ],
                      ),
                    ],
                  ),
                ], // osnovni kolona
              ),
            ),
          );
  }
}
*/
