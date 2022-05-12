import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/CategoryModel.dart';
import 'package:flutter_app/pages/AddChoosing.dart';
import 'package:flutter_app/pages/AuctionPage.dart';
import 'package:flutter_app/pages/InboxPage.dart';
import 'package:flutter_app/pages/KotaricaPage.dart';
import 'package:flutter_app/pages/OcenePage.dart';
import 'package:flutter_app/pages/RegistrationPage.dart';
import 'package:flutter_app/pages/SettingsProfilePage.dart';
import 'package:flutter_app/pages/UserProfilePage.dart';
import 'package:flutter_app/pages/WishlistPage.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_app/widgets/NavigationBar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart'; //ikonice

import '../models/PostModel.dart';
import 'WebLoginPage.dart';
import 'WebRegistrationPage.dart';


final Color backgroundColor = Color(0xFF4A4A58);

class WebHomePage extends StatefulWidget {
  static const routeName = '/HomePage';
  final List<String> list = List.generate(10, (index) => "Texto $index");

  @override
  _WebHomePage createState() => _WebHomePage();
}

class _WebHomePage extends State<WebHomePage> with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 400);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;
  List<dynamic> lista;

  var list;
  var loading = true;

  konekcija() async {
    list = await Provider.of<PostModel>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);

    Future.delayed(Duration.zero, () {
      this.konekcija().then((result) {
        setState(() {
          loading = false;
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  AppBar appBar(context) {
    final UlogujSe = Material(
      color: Color(0xff59081b),
      child: MaterialButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WebLoginPage()),
          );
        },
        child: Center(
          child: Text(
            'Uloguj se',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    final RegistrujSe = Material(
      color: Color(0xff59081b),
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WebRegistrationPage()),
          );
        },
        child: Center(
          child: Text(
            'Registruj se',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    return AppBar(
      title: Image.asset("images/logo.png", fit: BoxFit.contain),
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 200),
          width: 90,
          child: UlogujSe,
        ),
        Container(
          margin: EdgeInsets.only(right: 20),
          width: 1,
          child: Text(" | "),
        ),
        Container(
          margin: EdgeInsets.only(right: 20),
          width: 90,
          child: RegistrujSe,
        ),

        Container(
          margin: EdgeInsets.only(right: 20),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  //showSearch(context: context, delegate: Search(widget.list));
                },
                child: Icon(Icons.search),
              ),
              Container(
                margin: EdgeInsets.only(left: 15),
                child: InkWell(
                    child: Icon(Icons.menu, color: Colors.white),
                    onTap: () {
                      setState(() {
                        if (isCollapsed)
                          _controller.forward();
                        else
                          _controller.reverse();

                        isCollapsed = !isCollapsed;
                      });
                    }),
              ),
            ],
          ),
        )
      ],
      //title: Text("Oglasi Kotarica"),
      //centerTitle: true,
      backgroundColor: Color(0xff59071a),
    );
  }

//Sort
  bool descriptionIsExpanded = false;
  bool informationIsExpanded = false;

//------

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    final UlogujSe = Material(
      color: Color(0xff59081b),
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        minWidth: GetSize.getMaxWidth(context),
        padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WebLoginPage()),
          );
        },
        child: Center(
          child: Text(
            'Ulogij se | ',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    final RegistrujSe = Material(
      color: Color(0xff59081b),
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        minWidth: GetSize.getMaxWidth(context),
        padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrationPage()),
          );
        },
        child: Center(
          child: Text(
            'Registruj se',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar(context),
      body:  loading ? Center(
        child: CircularProgressIndicator(
            backgroundColor: Colors.black,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red)),
      )
          : Stack(
        // GLAVNI POCETAK STRANICE
        children: <Widget>[
          Container(color: Color(0xff59071a), child: menu(context)), // meni
          dashboard(context), // plavi deo (main stranica)
        ],
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
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        onPressed: () {
          setState(() {
            Navigator.push(
              context,
              //PageTransition(type: PageTransitionType.rightToLeft, child: MessageUserPage())
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

                menuButton("Lista Želja", Icons.favorite, WishlistPage()),
                SizedBox(height: 10),
                menuButton("Dodaj oglas", Icons.post_add_outlined, AddChoosing()),
                SizedBox(height: 10),
                menuButton("Korpa", Icons.shopping_cart_sharp, KotaricaPage()),
                SizedBox(height: 10),
                menuButton("Moj profil", Icons.person_sharp, UserProfilePage()),
                SizedBox(height: 10),


                menuButton("Moje poruke", Icons.messenger_outline, InboxPage()),
                SizedBox(height: 10),
                menuButton("Moji oglasi", CupertinoIcons.square_list_fill, WebLoginPage()),
                SizedBox(height: 10),
                menuButton("Ocene", Icons.thumbs_up_down_outlined, OcenePage()),
                SizedBox(height: 10),
                menuButton("Podešavanja", Icons.settings, SettingsProfilenPage()),
                SizedBox(height: 10),
                Row(
                    children: [CustomSwitch(
                      activeColor: Colors.green,
                      value: false,
                      onChanged: (value) {
                        setState(() {
                          if(value){
                            // currently dark mode -> turns into light mode
                            // theme.setLightMode();
                          }
                          else{
                            // currently light mode -> turns into dark mode
                            //theme.setDarkMode(),
                            // izmena
                          }
                        });
                      },
                    ),
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          "Noćni režim",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]),
                SizedBox(height: 10),
                menuButton("Odjavi se", Icons.logout, WebLoginPage()),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //"BMW 530 3.0 xDrive asdgsdafasdgadsdgaasdf"



  Widget dashboard(context) {
    var list = Provider.of<CategoryModel>(context);
    //---------
    //Filter lista
    String value = "";
    bool disabledropdown = false;
    List<DropdownMenuItem<String>> menuItems = []; //List()

    List lista = list.listOfCategories();
    var listaKategorija = new Map<int, String>();
    for (var i = 0; i < lista.length; i++) {
      listaKategorija[lista[i].id] = lista[i].naziv;
    }

    // int categoryItemCount = 7;
    int categoryItemCount = list.noCategories();
    //final kategorije = listaKategorija;
    final allChecked = CheckBoxModal(title: "Sve");
    final checkBoxList = [
      CheckBoxModal(title: "Voce"),
      CheckBoxModal(title: "Povrce"),
      CheckBoxModal(title: "Domaci proizvodi"),
      CheckBoxModal(title: "Zdrava hrana"),
      CheckBoxModal(title: "Mesno"),
      CheckBoxModal(title: "Mlecno")
    ];

    onAllClicked(CheckBoxModal ckbItem){
      final newValue = !ckbItem.value;
      setState(() {
        ckbItem.value = newValue;
        checkBoxList.forEach((element) { element.value = newValue;});
      });
    }

    onItemClicked(CheckBoxModal ckbItem){
      final newValue = !ckbItem.value;
      setState(() {
        ckbItem.value = newValue;

        if(!newValue){
          allChecked.value = false;
        }
        else{
          // ako je cela lista selektovana => selektuj i "Sve"
          final allListChecked = checkBoxList.every((element) => element.value);
          allChecked.value = allListChecked;
        }
      });
    }

    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.0 * screenWidth,
      right: isCollapsed ? 0 : -0.1 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          animationDuration: duration,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          elevation: 15,
          color: Color(0xffD5F5E7),
          child: Container(
            child: Column(
              // BODY ZA STRANICU
              children: <Widget>[
                //---- FILTER
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Sort
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      margin: EdgeInsets.only(
                          bottom: 30, top: 15, left: 10, right: 10),
                      decoration: new BoxDecoration(
                          color: Color(0xffD5F5E7),
                          borderRadius: BorderRadius.circular(10)),
                      child: ExpansionTile(
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
                  ],
                ),
                /*Expanded(
                  child: ceoOglas(),
                )*/
                Expanded(
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        //flex: 1,
                        child: ListView(
                          children: [
                            ListTile(
                              onTap: () => onAllClicked(allChecked),
                              leading: Checkbox(
                                value: allChecked.value,
                                onChanged: (value) => onAllClicked(allChecked),
                              ),
                              title: Text(allChecked.title),
                            ),
                            Divider(),
                            ...checkBoxList.map((item) =>
                                ListTile(
                                  onTap: () => onItemClicked(item),
                                  leading: Checkbox(
                                    value: item.value,
                                    onChanged: (value) => onItemClicked(item),
                                  ),
                                  title: Text(item.title),
                                ),
                            ).toList(),
                          ],
                        ),
                      ),
                      Expanded(child: ceoOglas(),),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }


  ListView ceoOglas() {
    lista = list.loadPosts(screenWidth, screenHeight);
    return ListView.builder(
        padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
        itemCount: 1, //"KOLIKO IMA OGLASA count length",
        itemBuilder: (BuildContext context, int index) {
          //Activity activity = widget.destination.activities[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuctionPage()),
                );
              });
            },
            child: Column(
                children: lista.length == 0
                    ? [Text("NEMA OGLASA!")]
                    : lista.map<Widget>((lista) {
                  return lista;
                }).toList() //<Widget>((data) =>              _buildListItem(context, data)).toList(),
            ),
          );
        });
  }
}

class CheckBoxModal{
  String title;
  bool value;

  CheckBoxModal({@required this.title, this.value = false});
}

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResult;
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  final List<String> listExample;
  Search(this.listExample);

  final List<String> list = List.generate(10, (index) => "Text $index");

  List<String> recentList = ["BMW", "Audi", "Samsung"];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList
        : suggestionList.addAll(listExample.where(
          (element) => element.contains(query),
    ));

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestionList[index],
          ),
          onTap: () {
            selectedResult = suggestionList[index];
            showResults(context);
          },
        );
      },
    );
  }
}
