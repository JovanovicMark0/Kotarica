import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/pages/AuctionPage.dart';
import 'package:flutter_app/pages/PostPage.dart';
import 'package:flutter_app/pages/InboxPage.dart';
import 'package:flutter_app/pages/OcenePage.dart';
import 'package:flutter_app/pages/AuctionPageGuest.dart';
import 'package:flutter_app/pages/PostPageGuest.dart';
import 'package:flutter_app/models/PostModel.dart';
import 'package:flutter_app/pages/SettingsProfilePage.dart';
import 'package:flutter_app/models/WishModel.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_app/utility/Tajmer.dart';
import 'package:flutter_app/utility/ThemeManager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart'; //ikonice
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/utility/FilterSortControllers.dart';

import '../models/PostModel.dart';
import '../utility/Filter.dart';
import '../utility/GetSize.dart';
import 'AddChoosing.dart';
import 'LoginPage.dart';
import 'NotificationPage.dart';
import 'RegistrationPage.dart';
import 'UserProfilePage.dart';
import 'WishlistPage.dart';

final Color backgroundColor = Color(0xFF4A4A58);

class HomePage extends StatefulWidget {
  static const routeName = '/HomePage';
  final List<String> list = List.generate(10, (index) => "Texto $index");

  @override
  _HomePage createState() => _HomePage();
  Oglas oglasStack = new Oglas();
}

class Oglas extends StatefulWidget {
  final idOglasa;
  final naslov;
  final poslednjaPonuda;
  final kupiOdmah;
  final screenWidth;
  final screenHeight;
  final tip;
  final context;
  final dodatneInfo;
  static const routeName = '/auction';
  Oglas(
      {Key key,
      this.idOglasa,
      this.naslov,
      this.poslednjaPonuda,
      this.kupiOdmah,
      this.screenWidth,
      this.screenHeight,
      this.tip,
      this.context,
      this.dodatneInfo})
      : super(key: key);

  @override
  _OglasState createState() => _OglasState();
}

class _OglasState extends State<Oglas> {
  String urlSlike;
  Poster poster;
  Date datum;
  String imeIPrezimeVlasnika;
  String grad;
  int tipOglasa = 1;
  bool inWishList = false;
  var loading = true;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      this.init().then((value) {
        setState(() {
          loading = false;
        });
      });
    });
  }

  init() async {
    urlSlike = list.getThumbnail(widget.idOglasa) != null
        ? list.getThumbnail(widget.idOglasa)
        : "QmTwCcmKj5DFX3z28NQ3azfRsh1Zu4JczUXz8iUC9AcLB1"; //
    if (widget.tip == "Oglas") tipOglasa = -1;
    else tipOglasa = 1;
    for (var i = 0; i < lista2.length; i++) {
      if (lista2[i].id == widget.idOglasa) {
        var temp = widget.dodatneInfo.split("|");
        imeIPrezimeVlasnika = temp[0] + " " + temp[1];
        grad = temp[2];
        datum = listaDatuma[i];
        poster = lista2[i];
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = GetSize.getMaxHeight(context);
    var screenWidth = GetSize.getMaxWidth(context);
    init();
    if (listaZelja.contains(widget.idOglasa)) inWishList = true;
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
        : GestureDetector(
            onTap: () {
              for (var i = 0; i < lista2.length; i++) {
                if (lista2[i].id == widget.idOglasa) {
                  datum = listaDatuma[i];
                  poster = lista2[i];
                  break;
                }
              }
              if (tipOglasa == -1) {
                if (id != -1)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostPage(
                            selectedPost: poster, selectedDate: datum)),
                  );
                else
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostPageGuest(
                            selectedPost: poster, selectedDate: datum)),
                  );
              } else {
                if (id != -1)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AuctionPage(
                            selectedPost: poster, selectedDate: datum)),
                  );
                else
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AuctionPageGuest(
                            selectedPost: poster, selectedDate: datum)),
                  );
              }
            },
            child: Stack(
              children: [
                Container(
                  //ZELENA POZADINA OGLASA
                  height: GetSize.getMaxHeight(context) * 0.2,
                  margin: EdgeInsets.fromLTRB(
                      widget.screenWidth * 0.03, 0.0, 10.0, 8.0),
                  decoration: BoxDecoration(
                    color: tipOglasa == -1
                        ? Themes.DARK_BACKGROUND_COLOR
                        : Color.fromRGBO(53, 76, 73, 1),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    margin: widget.screenWidth < 1450
                        ? EdgeInsets.fromLTRB(
                            widget.screenWidth * 0.41, 0.1, 9.0, 4.0)
                        : widget.screenWidth < 350
                            ? EdgeInsets.fromLTRB(
                                widget.screenWidth * 0.3, 0.1, 9.0, 4.0)
                            : EdgeInsets.fromLTRB(
                                widget.screenWidth * 0.09, 0.1, 10, 3),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: widget.screenHeight * 0.02),
                                    width: widget.screenWidth * 0.27,
                                    child: Text(
                                      widget.naslov, //activity.name,
                                      style: TextStyle(
                                        fontSize: widget.screenWidth < 1330
                                            ? widget.screenWidth < 350
                                                ? 12
                                                : 17
                                            : 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  tipOglasa == -1
                                      ? Container(
                                          child: Text(
                                            imeIPrezimeVlasnika,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.screenWidth <
                                                      1330
                                                  ? widget.screenWidth < 350
                                                      ? 12
                                                      : widget.screenHeight *
                                                          0.017
                                                  : widget.screenHeight * 0.021,
                                            ),
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: Icon(
                                                Icons.access_time_outlined,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                            ),
                                            Wrap(
                                              children: [
                                                CountdownTimer(
                                                  endTime: DateTime(
                                                          datum.year,
                                                          datum.month,
                                                          datum.day,
                                                          datum.hour,
                                                          datum.minut)
                                                      .add(new Duration(
                                                          days: int.parse(
                                                              widget.tip)))
                                                      .millisecondsSinceEpoch,
                                                  textStyle: TextStyle(
                                                    fontSize: widget
                                                                .screenWidth <
                                                            1330
                                                        ? widget.screenWidth <
                                                                350
                                                            ? 12
                                                            : widget.screenHeight *
                                                                0.017
                                                        : widget.screenHeight *
                                                            0.021,
                                                    color: Colors.white,
                                                  ),
                                                  onEnd: () {},
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                  tipOglasa == -1
                                      ? Container(
                                          child: Text(
                                            grad,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.screenWidth <
                                                      1330
                                                  ? widget.screenWidth < 350
                                                      ? 12
                                                      : widget.screenHeight *
                                                          0.017
                                                  : widget.screenHeight * 0.021,
                                            ),
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FittedBox(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 1.0),
                                                  child: ImageIcon(
                                                    AssetImage(
                                                        'images/gavel.png'),
                                                    size: 15,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                            Text(
                                              widget.poslednjaPonuda + " RSD",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Text(
                                        tipOglasa == -1
                                            ? widget.kupiOdmah + "\nRSD"
                                            : widget.kupiOdmah.split('|')[1] +
                                                '\nRSD', //'\$${activity.price}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: widget.screenHeight < 1410
                                              ? widget.screenHeight * 0.015
                                              : widget.screenHeight * 0.021,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      tipOglasa == -1 ? 'Cena' : 'Kupi odmah',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    id == -1
                                        ? Container()
                                        : id == datum.idOwner ? Container() : Align(
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0,
                                                  right: 0.0,
                                                  bottom: 0.0),
                                              child: inWishList
                                                  ? IconButton(
                                                      onPressed: () async {
                                                        await modelWish
                                                            .removeFromWishList(
                                                                id,
                                                                widget
                                                                    .idOglasa);
                                                        setState(() =>
                                                            inWishList = false);
                                                      },
                                                      icon: Icon(Icons.bookmark,
                                                          color:
                                                              Colors.grey[850]),
                                                    )
                                                  : IconButton(
                                                      onPressed: () async {
                                                        await modelWish
                                                            .addToWishList(
                                                                id,
                                                                widget
                                                                    .idOglasa);

                                                        setState(() =>
                                                            inWishList = true);
                                                      },
                                                      icon: Icon(
                                                          Icons
                                                              .bookmark_border_rounded,
                                                          color:
                                                              Colors.white70),
                                                    ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: widget.screenWidth * 0.02,
                  top: widget.screenHeight * 0.02,
                  bottom: widget.screenHeight * 0.003,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: urlSlike == "QmTwCcmKj5DFX3z28NQ3azfRsh1Zu4JczUXz8iUC9AcLB1" ? Image.asset(
                      'images/empty.png',
                      fit: BoxFit.cover,
                      width: widget.screenWidth * 0.30,
                      height: widget.screenHeight * 0.20,
                    ) : Image.network(
                        "http://147.91.204.116:11128/ipfs/$urlSlike",
                        fit: BoxFit.cover,
                        width: widget.screenWidth * 0.1,
                        height: widget.screenHeight * 0.02),
                  ),
                ),
              ],
            ),
          );
  }
}

var list;
var modelWish;
var listaZelja;
var prefs;
int id;
List<dynamic> lista;
List<dynamic> lista2;
List<dynamic> listaDatuma;

var flagForFilter;
var listenerForFilter;

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 400);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;
  var categories = [];
  var showSubcategories = false;
  var loading = true;
  int activePaginationPage = 0;
  int filteredResults = 0;
  List<Widget> ikonice = [];
  List<Widget> paginationButtons = [];
  //FocusNode _focus = new FocusNode();

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<dynamic> _refresh() async {
    if (filteredResults == 0)
      return konekcija().then((f) {
        setState(() => loading = false);
      });
    else if (filteredResults == 1)
      return await loadFilteredPosts().then((f) {
        setState(() => loading = false);
      });
  }

  konekcija() async {
    filteredResults = 0;
    setState(() => loading = true);
    modelWish = Provider.of<WishModel>(context, listen: false);
    await modelWish.initiateSetup();
    listaZelja = await modelWish.getWishList(id);
    list = Provider.of<PostModel>(context, listen: false);
    await list.initiateSetup();

    lista2 = await list.loadPosts2([]);
    listaDatuma = await list.loadDates([]);

    lista = await list.loadPosts(0, 1, [], screenWidth, screenHeight, context);

    await categoriesReload();

    await paginationButtonsRefresh(filteredResults);
    // Setovanje filtera
    FilterSort.kategorija = "Kategorija";
    FilterSort.potkategorija = "Potkategorija";
    FilterSort.pretraga.text = "";
    FilterSort.minPrice =
        FilterSort.cheapestItem.toDouble();
    FilterSort.maxPrice =
        FilterSort.mostExpensiveItem.toDouble();
    FilterSort.nacinPlacanja = 0;
    FilterSort.grad = "Sve";
    FilterSort.tipOglasa = 0;

    //promena loadinga;
    setState(() {
      loading = false;
    });
  }
  ocistiteFiltere() async {
    filteredResults = 0;
    setState(() => loading = true);
    lista = await list.loadPosts(0, 1, [], screenWidth, screenHeight, context);
    await categoriesReload();

    await paginationButtonsRefresh(filteredResults);
    // Setovanje filtera
    FilterSort.kategorija = "Kategorija";
    FilterSort.potkategorija = "Potkategorija";
    FilterSort.pretraga.text = "";
    FilterSort.minPrice =
        FilterSort.cheapestItem.toDouble();
    FilterSort.maxPrice =
        FilterSort.mostExpensiveItem.toDouble();
    FilterSort.nacinPlacanja = 0;
    FilterSort.grad = "Sve";
    FilterSort.tipOglasa = 0;

    //promena loadinga;
    setState(() {
      loading = false;
    });
  }

  loadFilteredPosts() async {
    setState(() {
      loading = true;
    });
    filteredResults = 1;
    lista = await list.loadFilteredPosts(0, screenWidth, screenHeight, context);
    await categoriesReload();
    paginationButtonsRefresh(filteredResults);
    setState(() {
      loading = false;
    });
    setState(() {
      loading = false;
    });
    setState(() {
      loading = false;
    });
  }

  var hintTextSearch = 'Pretraga';

  categoriesReload() async {
    var temp = await rootBundle.loadString('assets/categories.json');
    var categoriesJSON = jsonDecode(temp);
    categories.clear();
    ikonice.clear();
    for (int i = 1; i <= categoriesJSON.length; i++) {
      if (FilterSort.kategorija == categoriesJSON["$i"]["Category"]) {
        ikonice.insert(
            0,
            GestureDetector(
                child: Container(
                    width: 95,
                    child: Column(
                      children: [
                        screenHeight < 600 ?
                        Image.asset(
                            "images/${categoriesJSON["$i"]["ikonicaSelected"]}",
                            width: 20, height: 20):
                        Image.asset(
                            "images/${categoriesJSON["$i"]["ikonicaSelected"]}",
                            width: 40, height: 40),
                        Text(
                          "${categoriesJSON["$i"]["Category"]}",
                          textAlign: TextAlign.center,
                          textScaleFactor: 1,
                        ),
                      ],
                    )),
                onTap: () async {
                  FilterSort.kategorija = "Kategorija";
                  FilterSort.potkategorija = "Potkategorija";
                  await loadFilteredPosts();
                  setState(() {
                    loading = false;
                  });
                }));
      } else {
        ikonice.add(GestureDetector(
            child: Container(
                width: 95,
                child: Column(
                  children: [
                    screenHeight < 600 ?
                    Image.asset("images/${categoriesJSON["$i"]["ikonica"]}",
                        width: 20, height: 20) :Image.asset("images/${categoriesJSON["$i"]["ikonica"]}",
                        width: 40, height: 40),
                    Text(
                      "${categoriesJSON["$i"]["Category"]}",
                      textAlign: TextAlign.center,
                      textScaleFactor: 1,
                    ),
                  ],
                )),
            onTap: () async {
              FilterSort.kategorija = "${categoriesJSON["$i"]["Category"]}";
              FilterSort.potkategorija = "Potkategorija";
              await loadFilteredPosts();
              setState(() {
                loading = false;
              });
            }));
      }
    }
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
      this.getSharedPrefs().then((value) {
        setState(() {
          id = prefs.getInt("id") ?? -1;
        });
        this.konekcija().then((result) {
          setState(() {
            loading = false;
          });
        });
      });
    });
  }

  FittedBox getInactivePaginationButton(int i) {
    return FittedBox(
      child: Container(
        margin: EdgeInsets.only(left: 5.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            primary: Color(0xff59071a), // foreground
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
          ),
          child: Text('${i + 1}'),
        ),
      ),
    );
  }

  FittedBox getActivePaginationButton(int i) {
    return FittedBox(
      child: Container(
        margin: EdgeInsets.only(left: 5.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color(0xffD5F5E7), // foreground
            side: BorderSide(width: 2, color: Color(0xff59071a)),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
          ),
          onPressed: () async {
            if (filteredResults == 0)
              lista = await list.loadPosts(i * FilterSort.brojObjavaPoStrani, 1,
                  [], screenWidth, screenHeight, context);
            else {
              //if(i < activePaginationPage)

              lista = await list.loadFilteredPosts(
                  i * FilterSort.brojObjavaPoStrani,
                  screenWidth,
                  screenHeight,
                  context);
            }
            setState(() {
              activePaginationPage = i;
            });
            paginationButtonsRefresh(filteredResults);
          },
          child: Text('${i + 1}', style: TextStyle(color: Color(0xff59071a))),
        ),
      ),
    );
  }

  FittedBox getMiddlePaginationButton() {
    return FittedBox(
      child: Container(
        margin: EdgeInsets.only(left: 5.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            primary: Color(0xffD5F5E7), // foreground
            side: BorderSide(width: 2, color: Color(0xff59071a)),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
          ),
          child: Text('...', style: TextStyle(color: Color(0xff59071a))),
        ),
      ),
    );
  }

  paginationButtonsRefresh(int flag) {
    int brojOglasa = flag == 0 ? list.noPosts() : list.noFilteredPosts();
    int brojStranica = ((brojOglasa) / FilterSort.brojObjavaPoStrani).ceil();
    var paginationButtons1 = [];
    if (brojStranica > 1) {
      if (brojStranica < 5) {
        for (int i = 0; i < brojStranica; i++) {
          if (activePaginationPage == i) {
            paginationButtons1.add(getInactivePaginationButton(i));
          } else {
            paginationButtons1.add(getActivePaginationButton(i));
          }
        }
      } else {
        if (activePaginationPage == 0) {
          //na prvoj stranici je
          paginationButtons1.add(getInactivePaginationButton(0));
          paginationButtons1.add(getActivePaginationButton(1));
          paginationButtons1.add(getActivePaginationButton(2));
          paginationButtons1.add(getMiddlePaginationButton());
          paginationButtons1.add(getActivePaginationButton(brojStranica - 1));
        } else if (activePaginationPage == 1) {
          //na drugoj stranici je
          paginationButtons1.add(getActivePaginationButton(0));
          paginationButtons1.add(getInactivePaginationButton(1));
          paginationButtons1.add(getActivePaginationButton(2));
          paginationButtons1.add(getMiddlePaginationButton());
          paginationButtons1.add(getActivePaginationButton(brojStranica - 1));
        } else if (activePaginationPage == brojStranica - 2) {
          //na pretposlednjoj stranici
          paginationButtons1.add(getActivePaginationButton(0));
          if (activePaginationPage != 2) //ne znam sto ovako mora ali mora
            paginationButtons1.add(getMiddlePaginationButton());
          paginationButtons1
              .add(getActivePaginationButton(activePaginationPage - 1));
          paginationButtons1
              .add(getInactivePaginationButton(activePaginationPage));
          paginationButtons1.add(getActivePaginationButton(brojStranica - 1));
        } else if (activePaginationPage == brojStranica - 1) {
          // na poslednjoj stranici
          paginationButtons1.add(getActivePaginationButton(0));
          if (activePaginationPage != 1)
            paginationButtons1.add(getMiddlePaginationButton());
          paginationButtons1
              .add(getActivePaginationButton(activePaginationPage - 1));
          paginationButtons1
              .add(getInactivePaginationButton(activePaginationPage));
        } else {
          //negde na sredini
          paginationButtons1.add(getActivePaginationButton(0));
          if (activePaginationPage != 2)
            paginationButtons1.add(getMiddlePaginationButton());
          paginationButtons1
              .add(getActivePaginationButton(activePaginationPage - 1));
          paginationButtons1
              .add(getInactivePaginationButton(activePaginationPage));
          paginationButtons1
              .add(getActivePaginationButton(activePaginationPage + 1));
          if (activePaginationPage != brojStranica - 1)
            paginationButtons1.add(getMiddlePaginationButton());
          paginationButtons1.add(getActivePaginationButton(brojStranica - 1));
        }
      }
    }
    paginationButtons = paginationButtons1.cast<Widget>();
  }

  @override
  void dispose() {
    if (mounted) {
      _controller.dispose();
      super.dispose();
    }
  }

  AppBar appBar1(context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 20),
          child: Row(
            children: [
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
      title: Text("Kotarica"),
      centerTitle: true,
      backgroundColor: Themes.BACKGROUND_COLOR,
    );
  }

  AppBar appBar(context) {
    final OdjaviSe = Material(
      color: Color(0xff59081b),
      child: MaterialButton(
        onPressed: () {
          if (id != -1) {
            prefs.remove("id");
            prefs.remove("email");
            prefs.remove("firstname");
            prefs.remove("password");
            prefs.remove("lastname");
            prefs.remove("phone");
            prefs.remove("primaryAddress");
            prefs.remove("secondaryAddress");
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        child: Center(
          child: Text(
            id == -1 ? 'Prijavite se' : 'Odjavite se',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    final registrujSe = Material(
      color: Color(0xff59081b),
      child: MaterialButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrationPage()),
          );
        },
        child: Center(
          child: Text(
            'Registrujte se',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 200),
          width: 90,
          child: OdjaviSe,
        ),
        id == -1
            ? Container(
                margin: EdgeInsets.only(left: 20),
                width: 120,
                child: registrujSe,
              )
            : Container(),
      ],
      /*leading: Container(
        child: IconButton(
          icon: Image.asset('images/logo.png'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),*/
      leading: Image(
        image: AssetImage('images/logo.png'),
      ),
      title: Text("Oglasi Kotarica"),
      centerTitle: true,
      backgroundColor: Color(0xff59071a),
    );
  }

//Sort
  bool descriptionIsExpanded = false;
  bool informationIsExpanded = false;

//------

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    screenHeight = GetSize.getMaxHeight(context);
    screenWidth = GetSize.getMaxWidth(context);

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
        : screenWidth < 800
            ? RefreshIndicator(
                onRefresh: () => _refresh(),
                child: Scaffold(
                  backgroundColor: backgroundColor,
                  appBar: appBar1(context),
                  body: Stack(
                    // GLAVNI POCETAK STRANICE
                    children: <Widget>[
                      Container(
                          color: Themes.BACKGROUND_COLOR,
                          child: menu(context)), // meni
                      dashboard2(context), // plavi deo (main stranica)
                    ],
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () => _refresh(),
                child: Scaffold(
                  backgroundColor: Color(0xff59071a),
                  appBar: appBar(context),
                  body: Row(
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
                                /*Image.asset(
                                  'images/logo.png',
                                  fit: BoxFit.fitHeight,
                                ),*/
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
                      Expanded(
                        flex: 8,
                        child: screenWidth < 1100
                            ? dashboard1(context)
                            : dashboard(context),
                      ),
                    ],
                  ),
                ),
              );
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
            child: Container(
              width: 0.4 * screenWidth,
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
                      : menuButton(
                          "Moj profil", Icons.person_sharp, UserProfilePage()),
                  id == -1 ? Container() : SizedBox(height: 20),
                  id == -1
                      ? Container()
                      : menuButton(
                          "Moje poruke", Icons.messenger_outline, InboxPage()),
                  id == -1 ? Container() : SizedBox(height: 20),
                  // menuButton("Moji oglasi", CupertinoIcons.square_list_fill, LoginPage()),
                  // SizedBox(height: 20),
                  id == -1
                      ? Container()
                      : menuButton("Dodaj Oglas", Icons.post_add_outlined,
                          AddChoosing()),
                  id == -1 ? Container() : SizedBox(height: 20),
                  id == -1
                      ? Container()
                      : menuButton(
                          "Lista Želja", Icons.bookmark, WishlistPage()),
                  id == -1 ? Container() : SizedBox(height: 20),
                  //menuButton("Korpa", Icons.shopping_cart_sharp, KotaricaPage()),
                  //SizedBox(height: 20),
                  id == -1
                      ? Container()
                      : menuButton(
                          "Ocene", Icons.thumbs_up_down_outlined, OcenePage()),
                  id == -1 ? Container() : SizedBox(height: 20),
                  id == -1
                      ? Container()
                      : menuButton("Podešavanja", Icons.settings,
                          SettingsProfilenPage()),
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

  Widget dashboard2(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.15 * screenWidth,
      right: isCollapsed ? 0 : -0.1 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          animationDuration: duration,
          elevation: 15,
          color: Color(0xffD5F5E7),
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ceoOglas(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dashboard1(context) {
    return Material(
      animationDuration: duration,
      elevation: 15,
      color: Color(0xffD5F5E7),
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ceoOglas(),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboard(context) {
    var size = MediaQuery.of(context).size;
    final _formKey = GlobalKey<FormState>();
    var tempSortiranje;
    final myController = TextEditingController();
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;
    return Material(
      animationDuration: duration,
      elevation: 15,
      color: Color(0xffD5F5E7),
      child: Container(
        height: GetSize.getMaxHeight(context) * 2,
        child: Column(
          children: <Widget>[
            Column(
              children: [
                Container(
                  width: screenWidth * 0.3,
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value) async {
                      activePaginationPage = 0;
                      PostModel.lastIndex = 0;
                      await loadFilteredPosts();
                      setState(() {
                        loading = false;
                      });
                    },
                    controller: FilterSort.pretraga,
                    cursorColor: Colors.black,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                          activePaginationPage = 0;
                          PostModel.lastIndex = 0;
                          await loadFilteredPosts();
                        },
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.white54,
                      filled: true,
                      hintText: hintTextSearch,
                      helperMaxLines: 1,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(50),
                        borderSide: new BorderSide(),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    // KATEGORIJE
                    children: <Widget>[
                      kategorije(),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: Container(
                        width: screenWidth * 0.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      _alertFilter().then((val) async {
                                        if (val == 1) {
                                          await loadFilteredPosts();
                                        }
                                      });
                                    },
                                    child: Text(
                                      "Filtrirajte >",
                                      textScaleFactor: 1.1,
                                    )),
                              ],
                            ),
                            filteredResults == 1
                                ? GestureDetector(
                                    onTap: () {
                                      FilterSort.kategorija = "Kategorija";
                                      FilterSort.potkategorija = "Potkategorija";
                                      FilterSort.pretraga.text = "";
                                      FilterSort.minPrice =
                                          FilterSort.cheapestItem.toDouble();
                                      FilterSort.maxPrice =
                                          FilterSort.mostExpensiveItem.toDouble();
                                      FilterSort.nacinPlacanja = 0;
                                      FilterSort.grad = "Sve";
                                      FilterSort.tipOglasa = 0;
                                      filteredResults = 0;
                                      ocistiteFiltere();
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "Očistite filtere",
                                          textScaleFactor: 1.1,
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(left: 5.0),
                                            child: Icon(
                                                Icons.auto_delete_outlined))
                                      ],
                                    ))
                                : Container(),
                            Column(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Stack(
                                                overflow: Overflow.visible,
                                                children: <Widget>[
                                                  Positioned(
                                                    right: -40.0,
                                                    top: -40.0,
                                                    child: InkResponse(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: CircleAvatar(
                                                        child:
                                                            Icon(Icons.close),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(4.0),
                                                    child: DropdownButton<
                                                            String>(
                                                        hint:
                                                            Text("Sortiranje"),
                                                        value: tempSortiranje,
                                                        items: [
                                                          DropdownMenuItem<
                                                                  String>(
                                                              value: "0",
                                                              child: Center(
                                                                child: Text(
                                                                    "Prvo starije"),
                                                              )),
                                                          DropdownMenuItem<
                                                                  String>(
                                                              value: "1",
                                                              child: Center(
                                                                child: Text(
                                                                    "Prvo novije"),
                                                              )),
                                                          DropdownMenuItem<
                                                                  String>(
                                                              value: "2",
                                                              child: Center(
                                                                child: Text(
                                                                    "Prvo najjeftinije"),
                                                              )),
                                                          DropdownMenuItem<
                                                                  String>(
                                                              value: "3",
                                                              child: Center(
                                                                child: Text(
                                                                    "Prvo najskuplje"),
                                                              )),
                                                          DropdownMenuItem<
                                                                  String>(
                                                              value: "4",
                                                              child: Center(
                                                                child:
                                                                    Text("A-Z"),
                                                              )),
                                                          DropdownMenuItem<
                                                                  String>(
                                                              value: "5",
                                                              child: Center(
                                                                child:
                                                                    Text("Z-A"),
                                                              )),
                                                        ],
                                                        onChanged: (_value) => {
                                                              setState(() {
                                                                FilterSort
                                                                        .sort =
                                                                    int.parse(
                                                                        _value);
                                                                Navigator.pop(
                                                                    context);
                                                                _refresh();
                                                              })
                                                            }),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Text(
                                      "Sortirajte >",
                                      textScaleFactor: 1.1,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Expanded(
              flex: 15,
              child: GridView.count(
                primary: false,
                crossAxisCount: screenWidth < 1500 ? 2 : 3,
                childAspectRatio: (itemWidth / itemHeight),
                children: List.generate(lista.length, (index) {
                  if (lista.length == 0) {
                    return Text("Trenutno nema nikakvih oglasa.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        )
                    );
                  }  else {
                    return Center(
                      child: lista[index],
                    );
                  }
                }),
              ),
            ),
            Expanded(
                child: Container(
              width: screenWidth * 0.9,
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: paginationButtons),
            ))
          ],
        ),
      ),
    );
  }

  SingleChildScrollView kategorije() {
    return new SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: ikonice,
        ));
  }

  Future<int> _alertFilter() async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Filter();
      },
    );
  }

  ListView ceoOglas() {
    var tempSortiranje;
    var gotovaLista = [
      Container(
        width: screenWidth * 0.3,
        height: 45,
        margin: EdgeInsets.all(10),
        child: TextField(
          //focusNode: _focus,
          controller: FilterSort.pretraga,
          textAlignVertical: TextAlignVertical.bottom,
          cursorColor: Colors.black,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                activePaginationPage = 0;
                PostModel.lastIndex = 0;
                await loadFilteredPosts();
                setState(() {
                  loading = false;
                });
              },
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: Colors.white54,
            filled: true,
            hintText: hintTextSearch,
            helperMaxLines: 1,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(50),
              borderSide: new BorderSide(),
            ),
          ),
        ),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          // KATEGORIJE
          children: <Widget>[
            kategorije(),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(8.0),
            child: Container(
              width: screenWidth * 0.4,
              height: screenHeight*0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                          onTap: () {
                            _alertFilter().then((val) async {
                              if (val == 1) {
                                await loadFilteredPosts();
                              }
                            });
                          },
                          child: Text(
                            "Filtrirajte >",
                            textScaleFactor: 1.1,
                          )),
                    ],
                  ),
                  new Spacer(),
                  filteredResults == 1
                      ? GestureDetector(
                          onTap: () {
                            FilterSort.kategorija = "Kategorija";
                            FilterSort.potkategorija = "Potkategorija";
                            FilterSort.pretraga.text = "";
                            FilterSort.minPrice =
                                FilterSort.cheapestItem.toDouble();
                            FilterSort.maxPrice =
                                FilterSort.mostExpensiveItem.toDouble();
                            FilterSort.nacinPlacanja = 0;
                            FilterSort.grad = "Sve";
                            FilterSort.tipOglasa = 0;
                            filteredResults = 0;
                            konekcija();
                          },
                          child: Row(
                            children: [
                              Text(
                                "Očistite filtere",
                                textScaleFactor: 1.1,
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 5.0),
                                  child: Icon(Icons.auto_delete_outlined))
                            ],
                          ))
                      : Container(),
                  new Spacer(),
                  Column(
                    children: [
                      GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Stack(
                                      overflow: Overflow.visible,
                                      children: <Widget>[
                                        Positioned(
                                          right: -40.0,
                                          top: -40.0,
                                          child: InkResponse(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: CircleAvatar(
                                              child: Icon(Icons.close),
                                              backgroundColor: Colors.red,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: DropdownButton<String>(
                                              hint: Text("Sortiranje"),
                                              value: tempSortiranje,
                                              items: [
                                                DropdownMenuItem<String>(
                                                    value: "0",
                                                    child: Center(
                                                      child:
                                                          Text("Prvo starije"),
                                                    )),
                                                DropdownMenuItem<String>(
                                                    value: "1",
                                                    child: Center(
                                                      child:
                                                          Text("Prvo novije"),
                                                    )),
                                                DropdownMenuItem<String>(
                                                    value: "2",
                                                    child: Center(
                                                      child: Text(
                                                          "Prvo najjeftinije"),
                                                    )),
                                                DropdownMenuItem<String>(
                                                    value: "3",
                                                    child: Center(
                                                      child: Text(
                                                          "Prvo najskuplje"),
                                                    )),
                                                DropdownMenuItem<String>(
                                                    value: "4",
                                                    child: Center(
                                                      child: Text("A-Z"),
                                                    )),
                                                DropdownMenuItem<String>(
                                                    value: "5",
                                                    child: Center(
                                                      child: Text("Z-A"),
                                                    )),
                                              ],
                                              onChanged: (_value) => {
                                                    setState(() {
                                                      FilterSort.sort =
                                                          int.parse(_value);
                                                      Navigator.pop(context);
                                                      _refresh();
                                                    })
                                                  }),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Text(
                            "Sortirajte >",
                            textScaleFactor: 1.1,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ];
    var levaLista = (lista.map<Widget>((lista) {
      return lista;
    }).toList());

    gotovaLista += levaLista;
    gotovaLista += [
      Container(
        width: screenWidth * 0.9,
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: paginationButtons),
      )
    ];
    //gotovaLista.add();
    return ListView.builder(
        padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          //Activity activity = widget.destination.activities[index];
          return Column(
              children: lista.length == 0
                  ? gotovaLista + [Text("Trenutno nema nikakvih oglasa.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  )
              )]
                  : gotovaLista);
        });
  }
}
