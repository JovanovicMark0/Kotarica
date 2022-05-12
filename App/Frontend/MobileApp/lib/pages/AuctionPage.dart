import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/PurchaseModel.dart';
import 'package:flutter_app/models/WishModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/models/NotificationModel.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_app/models/GradeModel.dart';
import 'package:flutter_app/utility/SignalRHelper.dart';
import 'package:flutter_app/utility/ThemeManager.dart';
import 'package:flutter_app/widgets/NavigationBar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../models/PostModel.dart';
import '../utility/Tajmer.dart';
import 'GalleryPage.dart';
import 'MessageUserPage.dart';
import 'ProfilePage.dart';

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
int radioImePrezime = 0;
int radioAdresa = 0;
int radioMobilni = 0;
var purchaseModel;
var usingUser;
var postID;
String email;
var userModel;
double rating = 0;
var gradeModel;

class _Auction extends State<AuctionPage> {
  var screenHeight;
  var screenWidth;

  bool descriptionIsExpanded = false;
  bool informationIsExpanded = false;
  TextEditingController licitirajController = new TextEditingController();
  bool loading = true;
  SharedPreferences prefs;
  int id = -1;
  List imageList = [];
  int ocenio;
  var postModel;
  var wishModel;
  var wishList;
  var inWishList;

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    postModel = Provider.of<PostModel>(context, listen: false);
    userModel = Provider.of<UserModel>(context, listen: false);
    await userModel.initiateSetup();
    usingUser = await userModel.getUserById(this.widget.selectedDate.idOwner);
    await postModel.initiateSetup();
    purchaseModel = Provider.of<PurchaseModel>(context, listen: false);
    await purchaseModel.initiateSetup();
    var listaSlika = postModel.getPictures(widget.selectedPost.id);
    listaSlika != null
        ? imageList = listaSlika
        : imageList.add("QmcQJs1BEezE17W8VAxUhtxR64DoZ4TsnC9Be5q6CvBFRt");
    wishModel = Provider.of<WishModel>(context, listen: false);
    await wishModel.initiateSetup();
    wishList = await wishModel.getWishList(prefs.getInt("id"));
    inWishList = wishList.contains(widget.selectedPost.id);
    gradeModel = Provider.of<GradeModel>(context, listen: false);
    await gradeModel.initiateSetup();
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
          ocenio = gradeModel.ocenio(userID, postID);
          if (ocenio != 0) rating = ocenio + 0.0;
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
              return imageList[index] ==
                      "QmTwCcmKj5DFX3z28NQ3azfRsh1Zu4JczUXz8iUC9AcLB1"
                  ? Image.asset(
                      'images/empty.png',
                    )
                  : Image.network(
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

    Container tekstIkonice(tekst) {
      return Container(
        child: Text(
          "$tekst",
          style: TextStyle(fontSize: 15, color: Color(0xff59071a)),
          textAlign: TextAlign.center,
        ),
      );
    }

    Container kontaktirajVlasnika() {
      return Container(
        margin: EdgeInsets.only(top: GetSize.getMaxHeight(context) * 0.05),
        child: IconButton(
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MessageUserPage(
                          chatUser: widget.selectedDate.idOwner,
                        )));
          },
          icon: Icon(Icons.message_outlined, color: Colors.grey[850]),
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
                fontSize: GetSize.getMaxWidth(context) * 0.06,
                color: Colors.black87,
              ),
              onEnd: () {},
            ),
          )
        ],
      );
    }

    oceni(rating) async {
      await gradeModel.addToGradeList(userID, postID, rating.toInt());
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
            width: GetSize.getMaxWidth(context) * 0.4,
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
          return KupovinaAlert(postID: widget.selectedPost.id);
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
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => NavigationBar()));
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

    var wishIkonica;
    if (inWishList != null) {
      wishIkonica = inWishList
          ? Container(
              margin:
                  EdgeInsets.only(top: GetSize.getMaxHeight(context) * 0.05),
              child: IconButton(
                onPressed: () async {
                  await wishModel.removeFromWishList(
                      id, widget.selectedPost.id);
                  setState(() => inWishList = false);
                },
                icon: Icon(Icons.bookmark, color: Colors.grey[850]),
              ),
            )
          : Container(
              margin:
                  EdgeInsets.only(top: GetSize.getMaxHeight(context) * 0.05),
              child: IconButton(
                onPressed: () async {
                  await wishModel.addToWishList(id, widget.selectedPost.id);
                  setState(() => inWishList = true);
                },
                icon: Icon(Icons.bookmark_border_rounded,
                    color: Colors.grey[850]),
              ),
            );
    }

    _launch(url) async {
      if (await canLaunch(url)) {
        await launch(url);
      }
    }

    //return GetSize.getMaxWidth(context) < 500 ?
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
                                    userID == usingUser.id
                                        ? Container()
                                        : Flexible(
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    wishIkonica,
                                                    inWishList
                                                        ? tekstIkonice(
                                                            "Ukloni iz\nliste želja")
                                                        : tekstIkonice(
                                                            "Dodaj u\nlistu želja"),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    kontaktirajVlasnika(),
                                                    tekstIkonice(
                                                        "Kontaktirajte\nvlasnika"),
                                                  ],
                                                ),
                                              ],
                                            ),
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
                        cena("Početna cena",
                            "${widget.selectedPost.price.split("|")[0]}"),
                        cena("Trenutna cena",
                            "${widget.selectedPost.currentBid}"),
                        Container(
                          margin: EdgeInsets.only(
                            top: GetSize.getMaxHeight(context) * 0.02,
                          ),
                          child: id == widget.selectedDate.idOwner
                              ? Container()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    licitacijaUnos(),
                                    licitacijaDugme(),
                                  ],
                                ),
                        ),
                        id.toString() == widget.selectedPost.currentBidder
                            ? Text("*Vaša ponuda je trenutno aktivna")
                            : Container(),
                        id == widget.selectedDate.idOwner
                            ? dugmeObrisi()
                            : dugmeKupiOdmah(
                                widget.selectedPost.price.split("|")[0]),
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
                            },
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
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
            floatingActionButton: userID == usingUser.id
                ? Container()
                : SpeedDial(
                    backgroundColor: Color(0xff59071a),
                    closeManually: true,
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                    ),
                    curve: Curves.easeIn,
                    children: [
                      SpeedDialChild(
                        label: "Pošalji SMS",
                        labelBackgroundColor: Themes.BACKGROUND_COLOR,
                        labelStyle: TextStyle(color: Colors.white),
                        child: Icon(
                          Icons.message_outlined,
                          color: Colors.white,
                        ),
                        backgroundColor: Color(0xff59071a),
                        onTap: () => _launch('sms:' + usingUser.phone),
                      ),
                      SpeedDialChild(
                        label: "Pozovi",
                        labelBackgroundColor: Themes.BACKGROUND_COLOR,
                        labelStyle: TextStyle(color: Colors.white),
                        child: Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
                        backgroundColor: Color(0xff59071a),
                        onTap: () => _launch('tel:' + usingUser.phone),
                      ),
                      SpeedDialChild(
                        label: "Profil vlasnika",
                        labelBackgroundColor: Themes.BACKGROUND_COLOR,
                        labelStyle: TextStyle(color: Colors.white),
                        child: Icon(
                          Icons.perm_contact_cal_rounded,
                          color: Colors.white,
                        ),
                        backgroundColor: Color(0xff59071a),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                    idOwner: widget.selectedDate.idOwner)),
                          );
                        },
                      ),
                    ],
                  ),
          );
  }
}

class KupovinaAlert extends StatefulWidget {
  final postID;
  KupovinaAlert({Key key, this.postID});
  @override
  _KupovinaAlertState createState() => new _KupovinaAlertState();
}

class _KupovinaAlertState extends State<KupovinaAlert> {
  var _fokusIme = new FocusNode();
  var _fokusAdresa = new FocusNode();
  var _fokusTelefon = new FocusNode();
  //var notificationModel;
  var postModel;
  SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    _fokusIme.addListener(_onFocusChangeIme);
    _fokusAdresa.addListener(_onFocusChangeAdresa);
    _fokusTelefon.addListener(_onFocusChangeTelefon);
    Future.delayed(Duration.zero, () {
      this.getSharedPreferences().then((result) {
        setState(() {
          loading2 = false;
        });
      });
    });
  }

  void _onFocusChangeIme() {
    setState(() {
      radioImePrezime = 1;
    });
  }

  getSharedPreferences() async {
    postModel = Provider.of<PostModel>(context, listen: false);
    await postModel.initiateSetup();
    //notificationModel = Provider.of<NotificationModel>(context, listen: false);
    //await notificationModel.initiateSetup();
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
  bool loading2 = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = GetSize.getMaxWidth(context);
    double screenHeight = GetSize.getMaxHeight(context);
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
                  setState(() => {loading2 = true});
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
                        email, usingUser.email, "#@#${widget.postID}@#@");

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
                  //notificationModel.addNotification(prefs.getInt("id"),
                  //widget.postID, postModel.getPostOwner(widget.postID));
                },
              ),
            ],
          );
  }
}
