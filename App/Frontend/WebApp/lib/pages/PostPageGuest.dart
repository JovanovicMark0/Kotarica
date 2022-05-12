import 'package:flutter/material.dart';
import 'package:flutter_app/models/PostModel.dart';
import 'package:flutter_app/models/PurchaseModel.dart';
import 'package:flutter_app/pages/GalleryPage.dart';
import 'package:flutter_app/pages/ProfilePage.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/WishModel.dart';

class PostPageGuest extends StatefulWidget {
  final selectedPost;
  final selectedDate;
  static const routeName = '/post';
  PostPageGuest({Key key, this.title, this.selectedPost, this.selectedDate})
      : super(key: key);
  final String title;

  @override
  _Post createState() => _Post();
}

int userID = -1;
String adresa = "";
String sekundarnaAdresa = "";
String adresaZaSlanje;
String ime = "";
String prezime = "";
String telefon = "";
int radioAdresa = -1;
int radioImePrezime = -1;
int radioMobilni = -1;
var purchaseModel;
var postID;

class _Post extends State<PostPageGuest> {
  bool descriptionIsExpanded = false;
  bool informationIsExpanded = false;
  bool loading = true;
  SharedPreferences prefs;

  String slikaO = "";
  String email = "";

  var postModel;
  var wishModel;
  var wishList;
  var inWishList;
  List imageList = [];

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    postModel = Provider.of<PostModel>(context, listen: false);
    await postModel.initiateSetup();
    purchaseModel = Provider.of<PurchaseModel>(context, listen: false);
    await purchaseModel.initiateSetup();

    wishModel = Provider.of<WishModel>(context, listen: false);
    await wishModel.initiateSetup();
    wishList = await wishModel.getWishList(prefs.getInt("id"));
    inWishList = wishList.contains(widget.selectedPost.id);

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
          userID = prefs.getInt("id");
          email = prefs.getString("email");
          ime = prefs.getString("firstname");
          prezime = prefs.getString("lastname");
          telefon = prefs.getString("phone");
          adresa = prefs.getString("primaryAddress");
          adresaZaSlanje = adresa;
          sekundarnaAdresa = prefs.getString("secondaryAddress");
          //slika = prefs.getString("photo");
          slikaO = "http://147.91.204.116:11128/ipfs/" +
              "QmTwCcmKj5DFX3z28NQ3azfRsh1Zu4JczUXz8iUC9AcLB1";
          loading = false;
        });
      });
    });
  }

  //final pictureOnDesktop = ;
  @override
  Widget build(BuildContext context) {
    var screenHeight = GetSize.getMaxHeight(context);
    var screenWidth = GetSize.getMaxWidth(context);
    AppBar appBar(naslov) {
      return AppBar(
        title: Text(widget.selectedPost.name),
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

    _launch(url) async {
      if (await canLaunch(url)) {
        await launch(url);
      }
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
            appBar: AppBar(
              title: Text( "${widget.selectedPost.name}",
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
            body: SingleChildScrollView(
              child: Container(
                color: Color(0xffd5f5e7),
                child: Column(
                  children: <Widget>[
                   /* Container(
                      width: GetSize.getMaxWidth(context),
                      color: Color(0xff59081b),
                      child: Center(
                        child: Text(
                          "${widget.selectedPost.name}",
                          style: TextStyle(
                            height: 2,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 5,
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
                              ],
                            ))
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: GetSize.getMaxWidth(context) * 0.9,
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
                          width: GetSize.getMaxWidth(context) * 0.9,
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
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                    child: Icon(
                      Icons.perm_contact_cal_rounded,
                      color: Colors.white,
                    ),
                    backgroundColor: Color(0xff59071a),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(
                                title: ime + prezime,
                                idOwner: widget.selectedDate.idOwner)),
                      );
                    }),
              ],
            ),
          );
    /*Scaffold(
      appBar: appBar("BMW 530 3.0 xDrive"),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: GetSize.getMaxHeight(context) * 2, //EDIT
              decoration: BoxDecoration(
                color: Color(0xffd5f5e7),
              ),
              child: Column(
                children: [
                  Container(
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
                              Container(
                                width: 150,
                                child: galerija,
                              ),
                              Flexible(
                                child: new Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Column(children: [
                                      wishIkonica,
                                      inWishList ? tekstIkonice(
                                          "Ukloni iz\nliste želja") : tekstIkonice(
                                          "Dodaj u\nlistu želja"),
                                    ]),
                                    //ikonice(Icons.message_outlined),
                                    //tekstIkonice("Kontaktiraj\nvlasnika"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  dugmeKupi(3000),
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
                                title: Text("${widget.selectedPost.description}",
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
      /*bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Color(0xff59071a),
        ),
        child: navBar,
      ),*/
      floatingActionButton: SpeedDial(
        backgroundColor: Color(0xff59071a),
        closeManually: true,
        child: Icon(
          Icons.account_circle,
          color: Colors.white,
        ),
        curve: Curves.easeIn,
        children: [
          SpeedDialChild(
            child: Icon(
              Icons.message_outlined,
              color: Colors.white,
            ),
            backgroundColor: Color(0xff59071a),
            onTap: () => _launch('sms:' + telefon),
          ),
          SpeedDialChild(
            child: Icon(
              Icons.call,
              color: Colors.white,
            ),
            backgroundColor: Color(0xff59071a),
            onTap: () => _launch('tel:' + telefon),
          ),
          SpeedDialChild(
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
    );*/
  }
}
