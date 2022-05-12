import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/PurchaseModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/pages/HomePage.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/PostModel.dart';
import 'package:flutter_app/models/GradeModel.dart';
import '../models/WishModel.dart';
import '../utility/SignalRHelper.dart';
import '../utility/Tajmer.dart';
import 'AddChoosing.dart';
import 'GalleryPage.dart';
import 'InboxPage.dart';
import 'LoginPage.dart';
import 'MessageUserPage.dart';
import 'NotificationPage.dart';
import 'OcenePage.dart';
import 'ProfilePage.dart';
import 'SettingsProfilePage.dart';
import 'UserProfilePage.dart';
import 'WishlistPage.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class AuctionPage extends StatefulWidget {
  final selectedPost;
  final selectedDate;
  static const routeName = '/auction';
  AuctionPage({Key key, this.title, this.selectedPost, this.selectedDate})
      : super(key: key);
  final String title;

  @override
  _Auction createState() => _Auction();
}

int userID = -1;
String adresa = "";
String sekundarnaAdresa = "";
String adresaZaSlanje;
String imePrezimeZaSlanje;
String brojSlanje;
String ime = "";
String prezime = "";
String telefon = "";
User usingUser;
var postID;
String email = "";
var postModel;
var userModel;
double rating = 0;
var gradeModel;

var purchaseModel;

class _Auction extends State<AuctionPage> {
  bool descriptionIsExpanded = false;
  bool informationIsExpanded = false;
  TextEditingController licitirajController = new TextEditingController();
  bool loading = true;
  SharedPreferences prefs;
  int id = -1;
  List imageList = [];
  var wishModel;
  var wishList;
  var inWishList;
  int ocenio;

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    postModel = Provider.of<PostModel>(context, listen: false);
    await postModel.initiateSetup();
    purchaseModel = Provider.of<PurchaseModel>(context, listen: false);
    await purchaseModel.initiateSetup();
    userModel = Provider.of<UserModel>(context, listen: false);
    await userModel.initiateSetup();
    usingUser = userModel.getUserById(widget.selectedDate.idOwner);

    gradeModel = Provider.of<GradeModel>(context, listen: false);
    await gradeModel.initiateSetup();

    wishModel = Provider.of<WishModel>(context, listen: false);
    await wishModel.initiateSetup();
    wishList = await wishModel.getWishList(prefs.getInt("id"));
    inWishList = wishList.contains(widget.selectedPost.id);
    var listaSlika = postModel.getPictures(widget.selectedPost.id);
    listaSlika != null
        ? imageList = listaSlika
        : imageList.add("QmcQJs1BEezE17W8VAxUhtxR64DoZ4TsnC9Be5q6CvBFRt");
  }

  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.getSharedPrefs().then((result) {
        setState(() {
          postID = widget.selectedPost.id;
          id = prefs.getInt("id");
          userID = id;
          email = prefs.getString("email");
          ime = prefs.getString("firstname");
          prezime = prefs.getString("lastname");
          telefon = prefs.getString("phone");
          adresa = prefs.getString("primaryAddress");
          ocenio = gradeModel.ocenio(userID, postID);
          if (ocenio != 0) rating = ocenio + 0.0;

          sekundarnaAdresa = prefs.getString("secondaryAddress");
          loading = false;
        });
      });
    });
  }

  AlertDialog vecaPonuda() {
    return AlertDialog(
      content: Container(
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Text(
                "Vaša ponuda je veća od maksimalne cene, proizvod možete kupiti odmah.")
          ],
        ),
      ),
    );
  }

  AlertDialog manjaPonuda() {
    return AlertDialog(
      content: Container(
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[Text("Vaša ponuda je manja od trenutne cene.")],
        ),
      ),
    );
  }

  //final pictureOnDesktop = ;
  @override
  Widget build(BuildContext context) {
    //User current = UserModel.currentUser;
    AppBar appBar(naslov) {
      return AppBar(
        title: Text("${widget.selectedPost.name}"),
        elevation: 0,
        backgroundColor: Color(0xff59071a),
      );
    }

    Container slika() {
      return Container(
        // SLIKA
        height: GetSize.getMaxHeight(context) * 0.62,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(50.0),
          ),
          child: Swiper(
            autoplay: imageList.length > 1,
            duration: 100,
            itemBuilder: (BuildContext context, int index) {
              return imageList[index] == "QmTwCcmKj5DFX3z28NQ3azfRsh1Zu4JczUXz8iUC9AcLB1" ? Image.asset(
                'images/empty.png',
              ) : Image.network(
                "http://147.91.204.116:11128/ipfs/${imageList[index]}",
                //fit: BoxFit.fitHeight,
              );

            },
            itemCount: imageList.length,
            viewportFraction: 0.8,
            scale: 0.9,
          ),
        ),
      );
    }

    var wishIkonica;
    if (inWishList != null) {
      wishIkonica = inWishList
          ? Container(
              margin:
                  EdgeInsets.only(top: GetSize.getMaxHeight(context) * 0.0165),
              child: IconButton(
                onPressed: () async {
                  await wishModel.removeFromWishList(
                      id, widget.selectedPost.id);
                  setState(() => inWishList = false);
                },
                icon: Icon(
                  Icons.favorite,
                  color: Colors.white,
                  semanticLabel: "Dodaj u listu želja",
                ),
              ),
            )
          : Container(
              margin:
                  EdgeInsets.only(top: GetSize.getMaxHeight(context) * 0.0165),
              child: IconButton(
                onPressed: () async {
                  await wishModel.addToWishList(id, widget.selectedPost.id);
                  setState(() => inWishList = true);
                },
                icon: Icon(Icons.favorite_border, color: Colors.white),
              ),
            );
    }

    oceni(rating) async {
      await gradeModel.addToGradeList(userID, postID, rating.toInt());
    }

    Column vreme1(preostaloVreme) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
                top: GetSize.getMaxHeight(context) * 0.012,
                right: GetSize.getMaxWidth(context) * 0.02),
            child: Icon(Icons.timer_sharp, color: Color(0xff59071a)),
          ),
          Container(
            margin: EdgeInsets.only(
              top: GetSize.getMaxHeight(context) * 0.01,
            ),
            child: CountdownTimer(
              endTime: DateTime(
                      widget.selectedDate.year,
                      widget.selectedDate.month,
                      widget.selectedDate.day,
                      widget.selectedDate.hour,
                      widget.selectedDate.minut)
                  .add(new Duration(
                      days: int.parse(widget.selectedPost.typeofPoster)))
                  .millisecondsSinceEpoch,
              textStyle: TextStyle(
                fontSize: 22,
                color: Colors.black87,
              ),
              onEnd: () {},
            ),
          )
        ],
      );
    }

    Row vreme(preostaloVreme) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
                top: GetSize.getMaxHeight(context) * 0.012,
                right: GetSize.getMaxWidth(context) * 0.02),
            child: Icon(Icons.timer_sharp, color: Color(0xff59071a)),
          ),
          Container(
            margin: EdgeInsets.only(
              top: GetSize.getMaxHeight(context) * 0.01,
            ),
            child: CountdownTimer(
              endTime: DateTime(
                      widget.selectedDate.year,
                      widget.selectedDate.month,
                      widget.selectedDate.day,
                      widget.selectedDate.hour,
                      widget.selectedDate.minut)
                  .add(new Duration(
                      days: int.parse(widget.selectedPost.typeofPoster)))
                  .millisecondsSinceEpoch,
              textStyle: TextStyle(
                fontSize: 22,
                color: Colors.black87,
              ),
              onEnd: () {},
            ),
          )
        ],
      );
    }

    Column cena1(tekst, vrednost) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: GetSize.getMaxHeight(context) * 0.02),
            child: Center(
              //Pocetna cena
              child: Text(
                "$tekst" + ":",
                style: TextStyle(
                  fontSize: GetSize.getMaxHeight(context) * 0.025,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: GetSize.getMaxHeight(context) * 0.02),
            child: Container(
              padding: EdgeInsets.all(
                GetSize.getMaxHeight(context) * 0.01,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$vrednost" + " RSD",
                style: TextStyle(
                  fontSize: GetSize.getMaxHeight(context) * 0.025,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      );
    }

    Row cena(tekst, vrednost) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: GetSize.getMaxHeight(context) * 0.02),
            child: Center(
              //Pocetna cena
              child: Text(
                "$tekst" + ":",
                style: TextStyle(
                  fontSize: GetSize.getMaxHeight(context) * 0.025,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: GetSize.getMaxHeight(context) * 0.02),
            child: Container(
              padding: EdgeInsets.all(
                GetSize.getMaxHeight(context) * 0.01,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$vrednost" + " RSD",
                style: TextStyle(
                  fontSize: GetSize.getMaxHeight(context) * 0.025,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      );
    }

    Row licitacijaUnos() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: GetSize.getMaxWidth(context) * 0.2,
            child: Row(
              children: [
                //width: GetSize.getMaxWidth(context) * 0.4,
                Expanded(
                  child: TextFormField(
                    controller: licitirajController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: GetSize.getMaxHeight(context) * 0.02,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    decoration: new InputDecoration(
                      labelText: "Licitiraj",
                      labelStyle: TextStyle(
                        fontSize: GetSize.getMaxHeight(context) * 0.02,
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final galerija = Material(
      color: Color(0xff59081b),
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        minWidth: GetSize.getMaxWidth(context),
        padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GalleryPage(a: imageList)));
        },
        child: Center(
          child: Text(
            'Otvori galeriju',
            textScaleFactor: 0.8,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    Container licitacijaDugme() {
      return Container(
        // Licitiraj dugme
        margin: EdgeInsets.only(
          left: 5,
        ),
        child: ElevatedButton(
          onPressed: () async {
            String buyNowPrice = (widget.selectedPost.price.split("|")[1]);
            String trenutnaPonuda = "";
            for (int i = 0; i < widget.selectedPost.currentBid.length; i++) {
              if ([
                '0',
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
              ].contains(widget.selectedPost.currentBid[i]))
                trenutnaPonuda += widget.selectedPost.currentBid[i];
            }
            if (int.parse(buyNowPrice) <= int.parse(licitirajController.text)) {
              showDialog<int>(
                  context: context,
                  builder: (BuildContext context) {
                    return vecaPonuda();
                  });
            } else if (int.parse(trenutnaPonuda) >=
                int.parse(licitirajController.text)) {
              showDialog<int>(
                  context: context,
                  builder: (BuildContext context) {
                    return manjaPonuda();
                  });
            } else {
              setState(() => this.loading = true);
              bool flag = await postModel.addNewBid(this.widget.selectedPost.id,
                  licitirajController.text, id.toString());
              if (flag) {
                this.widget.selectedPost.currentBid = licitirajController.text;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AuctionPage(
                            selectedPost: this.widget.selectedPost,
                            selectedDate: this.widget.selectedDate)));
              }
              setState(() => this.loading = false);
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.green[600],
            padding: EdgeInsets.fromLTRB(
                GetSize.getMaxWidth(context) * 0.01,
                GetSize.getMaxWidth(context) * 0.01,
                GetSize.getMaxWidth(context) * 0.011,
                GetSize.getMaxWidth(context) * 0.01),
          ),
          child: Text(
            'Licitiraj',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: GetSize.getMaxHeight(context) * 0.027,
            ),
          ),
        ),
      );
    }

    Future<void> _alertKupi() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return KupovinaAlert();
        },
      );
    }

    Container dugmeKupiOdmah(cena) {
      return Container(
        margin: EdgeInsets.only(top: GetSize.getMaxHeight(context) * 0.02),
        child: ElevatedButton(
          onPressed: () {
            _alertKupi();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.green[600],
            padding: EdgeInsets.fromLTRB(
                GetSize.getMaxWidth(context) * 0.015,
                GetSize.getMaxWidth(context) * 0.01,
                GetSize.getMaxWidth(context) * 0.015,
                GetSize.getMaxWidth(context) * 0.01),
          ),
          child: Text(
            'Kupi odmah za ${widget.selectedPost.price.split("|")[1]} RSD',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: GetSize.getMaxHeight(context) * 0.027,
            ),
          ),
        ),
      );
    }

    Container dugmeObrisi() {
      return Container(
        margin: EdgeInsets.only(top: GetSize.getMaxHeight(context) * 0.02),
        child: ElevatedButton(
          onPressed: () async {
            setState(() => {loading = true});
            await postModel.deletePoster(this.widget.selectedPost.id);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.black54,
            padding: EdgeInsets.fromLTRB(
                GetSize.getMaxWidth(context) * 0.015,
                GetSize.getMaxWidth(context) * 0.01,
                GetSize.getMaxWidth(context) * 0.015,
                GetSize.getMaxWidth(context) * 0.01),
          ),
          child: Text(
            'Obrišite aukciju',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: GetSize.getMaxHeight(context) * 0.027,
            ),
          ),
        ),
      );
    }

    var screenHeight = GetSize.getMaxHeight(context);
    var screenWidth = GetSize.getMaxWidth(context);
    //return GetSize.getMaxWidth(context) < 500 ?
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
              title: Text(
                "${widget.selectedPost.name}",
                style: TextStyle(
                  height: 2,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              //automaticallyImplyLeading: false,
              centerTitle: true,
              elevation: 0,
              backgroundColor: Color(0xff59071a),
            ),
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
                          id == -1
                              ? Container()
                              : menuButton("Početna", Icons.home, HomePage()),
                          id == -1 ? Container() : SizedBox(height: 20),
                          id == -1
                              ? Container()
                              : menuButton("Moj profil", Icons.person_sharp,
                                  UserProfilePage()),
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
                              : menuButton("Ocene",
                                  Icons.thumbs_up_down_outlined, OcenePage()),
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
                  child: Container(
                    width: GetSize.getMaxWidth(context) - 200,
                    color: Color(0xffd5f5e7),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 5, //2,
                              child: Container(
                                height: GetSize.getMaxHeight(context) * 0.62,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Flexible(child: slika()),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Container(
                                    width: 150,
                                    child: galerija,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  GetSize.getMaxWidth(context) < 750
                                      ? vreme1(
                                          "${widget.selectedDate.day}d ${widget.selectedDate.hour}h ${widget.selectedDate.minut}min")
                                      : vreme(
                                          "${widget.selectedDate.day}d ${widget.selectedDate.hour}h ${widget.selectedDate.minut}min"),
                                  GetSize.getMaxWidth(context) < 750
                                      ? cena1("Početna cena",
                                          "${widget.selectedPost.price.split("|")[0]}")
                                      : cena("Početna cena",
                                          "${widget.selectedPost.price.split("|")[0]}"),
                                  GetSize.getMaxWidth(context) < 750
                                      ? cena1("Trenutna cena",
                                          "${widget.selectedPost.currentBid}")
                                      : cena("Trenutna cena",
                                          "${widget.selectedPost.currentBid}"),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: GetSize.getMaxHeight(context) * 0.02,
                                    ),
                                    child: id == widget.selectedDate.idOwner
                                        ? Container()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              licitacijaUnos(),
                                              licitacijaDugme(),
                                            ],
                                          ),
                                  ),
                                  id.toString() ==
                                          widget.selectedPost.currentBidder
                                      ? Text("*Vaša ponuda je trenutno aktivna")
                                      : Container(),
                                  id == widget.selectedDate.idOwner
                                      ? dugmeObrisi()
                                      : dugmeKupiOdmah(widget.selectedPost.price
                                          .split("|")[0]),
                                ],
                              ),
                            )
                          ],
                        ),
                        Center(
                          child: SmoothStarRating(
                            rating: rating,
                            isReadOnly: ocenio == 0 ? false : true,
                            size: 80,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            defaultIconData: Icons.star_border,
                            starCount: 5,
                            allowHalfRating: false,
                            spacing: 2.0,
                            onRated: (value) {
                              rating = value;
                              // print("rating value dd -> ${value.truncate()}");
                            },
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              //print("ocena je: $rating");
                              if (postModel.getPostOwner(postID) != userID) {
                                if (ocenio == 0) {
                                  oceni(rating);
                                  ocenio = 1;
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green[600],
                              padding: EdgeInsets.fromLTRB(
                                  GetSize.getMaxWidth(context) * 0.015,
                                  GetSize.getMaxWidth(context) * 0.015,
                                  GetSize.getMaxWidth(context) * 0.015,
                                  GetSize.getMaxWidth(context) * 0.015),
                            ),
                            child: Text(
                              'Oceni',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: GetSize.getMaxHeight(context) * 0.020,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: GetSize.getMaxWidth(context) * 0.7,
                              height: GetSize.getMaxHeight(context) * 0.2,
                              margin: EdgeInsets.only(
                                top: GetSize.getMaxHeight(context) * 0.03,
                              ),
                              child: Container(
                                decoration: new BoxDecoration(
                                    //color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Divider(),
                                    Text(
                                      "Opis",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      child: ListTile(
                                        title: Text(
                                          "${widget.selectedPost.description}",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: GetSize.getMaxWidth(context) * 0.7,
                              height: GetSize.getMaxHeight(context) * 0.4,
                              margin: EdgeInsets.only(
                                top: GetSize.getMaxHeight(context) * 0.03,
                              ),
                              child: Container(
                                decoration: new BoxDecoration(
                                    //color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Divider(),
                                    Text(
                                      "Informacije",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      child: ListTile(
                                        title: Text(
                                          "Vlasnik: ${widget.selectedPost.additionalInfo.split("|")[0]} ${widget.selectedPost.additionalInfo.split("|")[1]}\nMesto: ${widget.selectedPost.additionalInfo.split("|")[3]}\nKategorija: ${widget.selectedPost.category}\nPotkategorija: ${widget.selectedPost.subcategory}\nDatum dodavanja: ${widget.selectedDate.day}.${widget.selectedDate.month}.${widget.selectedDate.year}.\nID oglasa: ${widget.selectedPost.id}",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    backgroundColor: Color(0xff59071a),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    }),
                SizedBox(
                  height: 15,
                ),
                userID == usingUser.id
                    ? Container()
                    : FloatingActionButton(
                        child: Column(children: [
                          wishIkonica,
                          /* inWishList
                        ? tekstIkonice("Ukloni iz\nliste želja")
                        : tekstIkonice("Dodaj u\nlistu želja"),*/
                        ]),
                        backgroundColor: Color(0xff59071a),
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
        });
  }
}

class KupovinaAlert extends StatefulWidget {
  @override
  _KupovinaAlertState createState() => new _KupovinaAlertState();
}

class _KupovinaAlertState extends State<KupovinaAlert> {
  int radioImePrezime = 0;
  int radioAdresa = 1;
  int radioMobilni = 0;
  var _fokusIme = new FocusNode();
  var _fokusAdresa = new FocusNode();
  var _fokusTelefon = new FocusNode();
  @override
  void initState() {
    super.initState();
    _fokusIme.addListener(_onFocusChangeIme);
    _fokusAdresa.addListener(_onFocusChangeAdresa);
    _fokusTelefon.addListener(_onFocusChangeTelefon);
    setState(() => {loading2 = false});
  }

  void _onFocusChangeIme() {
    setState(() {
      radioImePrezime = 1;
    });
  }

  void _onFocusChangeAdresa() {
    setState(() {
      radioAdresa = 2;
    });
  }

  void _onFocusChangeTelefon() {
    setState(() {
      radioMobilni = 1;
    });
  }

  final imePrezimeKontroler = TextEditingController();
  final adresaKontroler = TextEditingController();
  final mobilniKontroler = TextEditingController();
  var adresaLista = adresa.split("|");
  var sekAdresaLista = sekundarnaAdresa.split("|");
  int nameFlag = -2;
  int addressFlag = -2;
  int phoneFlag = -2;
  double velicinaNaslova = 1.0;
  double velicinaPodnaslova = 0.9;
  var loading2 = true;
  void changeLoading() {
    loading2 = !loading2;
  }

  @override
  Widget build(BuildContext context) {
    return loading2
        ? Center(child: CircularProgressIndicator())
        : AlertDialog(
            title: Text(
              'Potvrdite informacije: ',
              textScaleFactor: 0.85,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ListTile(
                    title: Row(
                      children: [
                        Text(
                          "Ime i prezime",
                          textScaleFactor: velicinaNaslova,
                        ),
                        nameFlag == -1
                            ? Text(
                                "Niste izabrali!",
                                style: TextStyle(color: Colors.red),
                                textScaleFactor: velicinaPodnaslova,
                              )
                            : SizedBox(width: 0, height: 0)
                      ],
                    ),
                  ),
                  ime == "" || prezime == ""
                      ? SizedBox(width: 0, height: 0)
                      : ListTile(
                          subtitle: Row(
                          children: [
                            Transform.scale(
                              scale: 0.7,
                              child: new Radio(
                                value: 0,
                                groupValue: radioImePrezime,
                                activeColor: Colors.red,
                                onChanged: (value) {
                                  setState(() {
                                    radioImePrezime = value;
                                  });
                                },
                              ),
                            ),
                            Text(
                              ime + " " + prezime,
                              textScaleFactor: velicinaNaslova,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        )),
                  ListTile(
                    subtitle: TextField(
                      controller: imePrezimeKontroler,
                      textAlign: TextAlign.center,
                      focusNode: _fokusIme,
                    ),
                    leading: Transform.scale(
                      scale: 0.7,
                      child: new Radio(
                        value: 1,
                        groupValue: radioImePrezime,
                        activeColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            radioImePrezime = value;
                          });
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Text(
                          "Adresa",
                          textScaleFactor: velicinaNaslova,
                        ),
                        addressFlag == -1
                            ? Text(
                                "Niste izabrali!",
                                style: TextStyle(color: Colors.red),
                              )
                            : SizedBox(width: 0, height: 0)
                      ],
                    ),
                  ),
                  sekundarnaAdresa == "||"
                      ? SizedBox(width: 0, height: 0)
                      : ListTile(
                          subtitle: Row(children: [
                          Transform.scale(
                            scale: 0.7,
                            child: new Radio(
                              value: 1,
                              groupValue: radioAdresa,
                              activeColor: Colors.red,
                              onChanged: (value) {
                                setState(() {
                                  radioAdresa = value;
                                });
                              },
                            ),
                          ),
                          Text(
                            sekAdresaLista[1] +
                                " " +
                                sekAdresaLista[0] +
                                " " +
                                sekAdresaLista[2],
                            textScaleFactor: velicinaNaslova,
                          ),
                        ])),
                  adresa == "||"
                      ? SizedBox(width: 0, height: 0)
                      : ListTile(
                          subtitle: Row(
                            children: [
                              Transform.scale(
                                scale: 0.7,
                                child: new Radio(
                                  value: 0,
                                  groupValue: radioAdresa,
                                  activeColor: Colors.red,
                                  onChanged: (value) {
                                    setState(() {
                                      radioAdresa = value;
                                    });
                                  },
                                ),
                              ),
                              Text(
                                adresaLista[1] +
                                    " " +
                                    adresaLista[0] +
                                    " " +
                                    adresaLista[2],
                                textScaleFactor: velicinaNaslova,
                              ),
                            ],
                          ),
                        ),
                  ListTile(
                    subtitle: TextField(
                      controller: adresaKontroler,
                      textAlign: TextAlign.center,
                      focusNode: _fokusAdresa,
                    ),
                    leading: Transform.scale(
                      scale: 0.7,
                      child: new Radio(
                        value: 2,
                        groupValue: radioAdresa,
                        activeColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            radioAdresa = value;
                          });
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Text(
                          "Broj telefona",
                          textScaleFactor: velicinaNaslova,
                        ),
                        nameFlag == -1
                            ? Text(
                                "Niste izabrali!",
                                style: TextStyle(color: Colors.red),
                              )
                            : SizedBox(width: 0, height: 0)
                      ],
                    ),
                  ),
                  telefon == ""
                      ? SizedBox(width: 0, height: 0)
                      : ListTile(
                          subtitle: Row(
                          children: [
                            Transform.scale(
                              scale: 0.7,
                              child: new Radio(
                                value: 0,
                                groupValue: radioMobilni,
                                activeColor: Colors.red,
                                onChanged: (value) {
                                  setState(() {
                                    radioMobilni = value;
                                  });
                                },
                              ),
                            ),
                            Text(
                              telefon,
                              textScaleFactor: velicinaNaslova,
                            ),
                          ],
                        )),
                  ListTile(
                    subtitle: TextField(
                      controller: mobilniKontroler,
                      textAlign: TextAlign.center,
                      focusNode: _fokusTelefon,
                    ),
                    leading: Transform.scale(
                      scale: 0.7,
                      child: new Radio(
                        value: 1,
                        groupValue: radioMobilni,
                        activeColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            radioMobilni = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Otkaži'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Potvrdi kupovinu'),
                onPressed: () async {
                  setState(() => {loading2 = false});
                  var helperAdresa;
                  var helperIme;
                  var helperTelefon;
                  if (radioAdresa == -1)
                    helperAdresa = -1;
                  else {
                    if (radioAdresa == 0)
                      adresaZaSlanje = adresaLista[1] +
                          " " +
                          adresaLista[0] +
                          " " +
                          adresaLista[2];
                    else if (radioAdresa == 1)
                      adresaZaSlanje = sekAdresaLista[1] +
                          " " +
                          sekAdresaLista[0] +
                          " " +
                          sekAdresaLista[2];
                    else if (radioAdresa == 2) {
                      adresaZaSlanje = adresaKontroler.text;
                    }
                  }
                  if (radioImePrezime == -1)
                    helperIme = -1;
                  else {
                    if (radioImePrezime == 0)
                      imePrezimeZaSlanje = ime + " " + prezime;
                    else if (radioAdresa == 1)
                      imePrezimeZaSlanje = imePrezimeKontroler.text;
                  }

                  if (radioMobilni == -1)
                    helperTelefon = -1;
                  else {
                    if (radioMobilni == 0)
                      brojSlanje = telefon;
                    else if (radioMobilni == 1)
                      brojSlanje = mobilniKontroler.text;
                  }
                  if (radioAdresa != -1 &&
                      radioImePrezime != -1 &&
                      radioMobilni != -1) {
                    var signalR = Provider.of<SignalR>(context, listen: false);
                    await signalR.initSignalR();
                    await signalR.startConnection();
                    await signalR.sendMessage(
                        email, usingUser.email, "#@#$postID@#@");

                    await signalR.sendMessage(email, usingUser.email,
                        "Ime i prezime: $imePrezimeZaSlanje\nAdresa: $adresaZaSlanje\nBroj telefona: $brojSlanje");
                    String kupacPK = await userModel.getPKS(usingUser.id);
                    String prodavacPK = await userModel.getPKS(userID);
                    await purchaseModel.buy(userID, postID, DateTime.now(),
                        kupacPK.split("|")[1], prodavacPK.split("|")[1], -1.00);
                    await postModel.deletePoster(postID);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MessageUserPage(
                                  chatUser: usingUser.id,
                                )));
                  }
                  setState(() {
                    nameFlag = helperIme;
                    addressFlag = helperAdresa;
                    phoneFlag = helperTelefon;
                  });
                  // notificationModel.addNotification(prefs.getInt("id"), widget.postID,
                  //     postModel.getPostList(widget.postID));
                },
              ),
            ],
          );
  }
}
