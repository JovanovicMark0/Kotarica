import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/PostModel.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_app/utility/ThemeManager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AuctionPage.dart';

class MyPosts extends StatefulWidget {
  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");
  bool loading = true;
  List<dynamic> listaOglasa = [];
  SharedPreferences prefs;
  int id = -1;
  var postModel;
  var gotovaListaOglasa = null;

  List<Widget> itemList = null;

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  konekcija() async {
    postModel = Provider.of<PostModel>(context, listen: false);
    listaOglasa = postModel.getPostList(prefs.getInt("id"));
  }

  ucitajOglase() async {
    if (listaOglasa == [])
      gotovaListaOglasa = [];
    else
      gotovaListaOglasa = (await postModel.loadPosts3(
          listaOglasa,
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
          context));
  }

  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.getSharedPrefs().then((result) {
        setState(() {
          id = prefs.getInt("id");
        });
      }).then((value) => this
          .konekcija()
          .then((result) {})
          .then((value) => this.ucitajOglase().then((result) {
                setState(() {
                  loading = false;
                });
              })));
    });
  }

  void refreshItemsList() {
    itemList = [];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = GetSize.getMaxWidth(context);
    double screenHeight = GetSize.getMaxHeight(context);
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
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Themes.BACKGROUND_COLOR,
              title: Text("Moji oglasi"),
              automaticallyImplyLeading: false,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
                child: Stack(children: <Widget>[
              Container(
                  width: GetSize.getMaxWidth(context),
                  height: GetSize.getMaxHeight(context),
                  //padding: EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    color: Themes.LIGHT_BACKGROUND_COLOR,
                    //borderRadius: BorderRadius.circular(10)
                  ),
                  child: gotovaListaOglasa.length == 0
                      ? Center(
                          child: Text(
                            "Nemate nijedan oglas",
                            style: Themes.TEXT_STYLE_MAIN,
                          ),
                        )
                      : ListView(
                          children: [
                            ListView.builder(
                                itemCount: 1,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  return ListView.builder(
                                      //padding: EdgeInsets.only(
                                      //    top: 10.0, bottom: 15.0),
                                      shrinkWrap: true,
                                      itemCount: gotovaListaOglasa
                                          .length, //"KOLIKO IMA OGLASA count length",
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        //Activity activity = widget.destination.activities[index];
                                        return ListTile(
                                            title: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AuctionPage()),
                                              );
                                            });
                                          },
                                          child: gotovaListaOglasa[index],
                                          /*
                                            gotovaListaOglasa
                                                .map<Widget>((lista) {
                                              return lista;
                                            }).toList()
                                             */
                                        ));
                                      });
                                })
                          ],
                        ))
            ])));
  }
}
