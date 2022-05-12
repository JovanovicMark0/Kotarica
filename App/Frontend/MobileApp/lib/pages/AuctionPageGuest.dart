import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/PurchaseModel.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_app/utility/ThemeManager.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/PostModel.dart';
import 'GalleryPage.dart';
import 'ProfilePage.dart';

class AuctionPageGuest extends StatefulWidget {
  final selectedPost;
  final selectedDate;
  static const routeName = '/auction';
  AuctionPageGuest({Key key, this.title, this.selectedPost, this.selectedDate})
      : super(key: key);
  final String title;

  @override
  _Auction createState() => _Auction();
}

int userID = -1;
String adresa = "";
String sekundarnaAdresa = "";
String adresaZaSlanje;
int radioAdresa = 0;
var purchaseModel;
var postID;

class _Auction extends State<AuctionPageGuest> {
  var screenHeight;
  var screenWidth;

  bool descriptionIsExpanded = false;
  bool informationIsExpanded = false;
  bool loading = true;
  SharedPreferences prefs;
  int id = -1;
  String email = "";
  String ime = "";
  String prezime = "";
  String telefon = "";
  List imageList = [];
  var postModel;

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    postModel = Provider.of<PostModel>(context, listen: false);
    await postModel.initiateSetup();
    purchaseModel = Provider.of<PurchaseModel>(context, listen: false);
    await purchaseModel.initiateSetup();
    var listaSlika = postModel.getPictures(widget.selectedPost.id);
    listaSlika != null
        ? imageList = listaSlika
        : imageList.add("QmTwCcmKj5DFX3z28NQ3azfRsh1Zu4JczUXz8iUC9AcLB1");
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
          sekundarnaAdresa = prefs.getString("secondaryAddress");
          loading = false;
        });
      });
    });
  }

  //final pictureOnDesktop = ;
  @override
  Widget build(BuildContext context) {
    screenHeight = GetSize.getMaxHeight(context);
    screenWidth = GetSize.getMaxWidth(context);

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

    /* Container prvaIkonica(ikonica) {
      return Container(
        margin: EdgeInsets.only(top: GetSize.getMaxHeight(context) * 0.03),
        child: Icon(
          ikonica,
          color: Color(0xff59071a),
        ),
      );
    }*/

    Container ikonice(ikonica) {
      return Container(
        margin: EdgeInsets.only(top: GetSize.getMaxHeight(context) * 0.05),
        child: Icon(
          ikonica,
          color: Color(0xff59071a),
        ),
      );
    }

    Container tekstIkonice(tekst) {
      return Container(
        child: Text(
          "$tekst",
          style: TextStyle(fontSize: 15, color: Color(0xff59071a)),
          textAlign: TextAlign.center,
        ),
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
            child: Text(
              "$preostaloVreme",
              style: TextStyle(fontSize: GetSize.getMaxHeight(context) * 0.035),
            ),
          )
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
                "$vrednost" + " din",
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
            width: GetSize.getMaxWidth(context) * 0.4,
            child: Row(
              children: [
                //width: GetSize.getMaxWidth(context) * 0.4,
                Expanded(
                  child: TextFormField(
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

    return loading
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
        : Scaffold(
            appBar: appBar("${widget.selectedPost.name}"),
            body: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: GetSize.getMaxHeight(context) * 2, //EDIT
                    decoration: BoxDecoration(
                      color: Themes.LIGHT_BACKGROUND_COLOR,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: GetSize.getMaxHeight(context) * 0.52,
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
                                    Container(
                                      width: 150,
                                      child: galerija,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Color(0xff59081b),
                        ),
                        vreme(
                            "${widget.selectedDate.day}d ${widget.selectedDate.hour}h ${widget.selectedDate.minut}min"),
                        cena("Početna cena", "${widget.selectedPost.price}"),
                        cena("Trenutna cena", "${widget.selectedPost.price}"),
                        Center(
                          child: Container(
                            //OPIS EXPANDED
                            margin: EdgeInsets.only(
                              top: GetSize.getMaxHeight(context) * 0.03,
                            ),
                            width: GetSize.getMaxWidth(context) * 0.9,
                            constraints: new BoxConstraints(
                              maxWidth: 600.0,
                            ),
                            child: Container(
                              decoration: new BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10)),
                              child: ExpansionTile(
                                  onExpansionChanged: (isExpanded) {
                                    isExpanded
                                        ? setState(() =>
                                            this.descriptionIsExpanded = true)
                                        : setState(() =>
                                            this.descriptionIsExpanded = false);
                                  },
                                  //collapsedBackgroundColor: Colors.grey[200],
                                  trailing: Icon(
                                    descriptionIsExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: Colors.black,
                                    size: 30.0,
                                  ),
                                  initiallyExpanded: false,
                                  title: Text(
                                    "Opis",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                  children: [
                                    ListTile(
                                      title: Text(
                                        "${widget.selectedPost.description}",
                                        style: TextStyle(fontSize: 18),
                                        /*maxLines: 2,
                                      overflow: TextOverflow.ellipsis,*/
                                      ),
                                    ),
                                    //style: TextStyle(fontSize: 18),
                                  ]),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            //OPIS EXPANDED
                            margin: EdgeInsets.only(
                              top: GetSize.getMaxHeight(context) * 0.03,
                            ),
                            width: GetSize.getMaxWidth(context) * 0.9,
                            constraints: new BoxConstraints(
                              maxWidth: 600.0,
                            ),
                            child: Container(
                              decoration: new BoxDecoration(
                                  color: Colors.grey[200],
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
                                      "Vlasnik: ${widget.selectedPost.additionalInfo.split("|")[0]} ${widget.selectedPost.additionalInfo.split("|")[1]}\nMesto: ${widget.selectedPost.additionalInfo.split("|")[3]}\nKategorija: ${widget.selectedPost.category}\nPotkategorija: ${widget.selectedPost.subcategory}\nDatum dodavanja: ${widget.selectedDate.day}.${widget.selectedDate.month}.${widget.selectedDate.year}.\nID oglasa: ${widget.selectedPost.id}",
                                      style: TextStyle(fontSize: 18),
                                      /*maxLines: 2,
                                      overflow: TextOverflow.ellipsis,*/
                                    ),
                                  ),
                                  //style: TextStyle(fontSize: 18),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
