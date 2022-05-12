import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/ChatMessageModel.dart';
import 'package:flutter_app/models/PostModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/utility/DateTimeFormatter.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_app/utility/ShippingInfoFormatter.dart';
import 'package:flutter_app/utility/SignalRHelper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/models/UserModel.dart' as uss;
import 'package:http/http.dart' as http;

import 'AddChoosing.dart';
import 'HomePage.dart';
import 'InboxPage.dart';
import 'LoginPage.dart';
import 'NotificationPage.dart';
import 'OcenePage.dart';
import 'SettingsProfilePage.dart';
import 'UserProfilePage.dart';
import 'WishlistPage.dart';

class MessageUserPage extends StatefulWidget {
  final chatUser; //User whos chat is active
  MessageUserPage({Key key, this.title, this.chatUser}) : super(key: key);
  final String title;

  @override
  _MessageUserPageState createState() => _MessageUserPageState();
}

class _MessageUserPageState extends State<MessageUserPage> {
  List<dynamic> messages = [];
  Set skupSvihPoruka = new Set();
  TextEditingController newMessage = TextEditingController();

  //UserModel.currentUser;

  //1
  var list;
  uss.User usingUser;
  var lista;
  uss.Date usingDate;

  bool loading = true;
  bool messageSending = false;
  SharedPreferences prefs;
  int idPref = -1;
  String emailPref = "";
  String imePref = "";
  String prezimePref = "";

  var signalR;
  var postModel;

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    list = Provider.of<uss.UserModel>(context, listen: false);
    await list.initiateSetup();
    postModel = Provider.of<PostModel>(context, listen: false);
    await postModel.initiateSetup();
    signalR = Provider.of<SignalR>(context, listen: false);
    await signalR.initSignalR();
    await signalR.startConnection();
  }

  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.getSharedPrefs().then((result) async {
        idPref = prefs.getInt("id");
        emailPref = prefs.getString("email");
        //ime = prefs.getString("firstname");
        prezimePref = prefs.getString("lastname");

        usingUser = list.getUserById(widget.chatUser);
        lista = list.loadDates([]);
        for (var i = 0; i < lista.length; i++) {
          if (lista[i].id == widget.chatUser) {
            usingDate = lista[i];
            break;
          }
        }
        await getMessages();
      });
    });
  }

  var targetURL;
  Future<void> getMessages() async {
    setState(() {
      loading = false;
    });

    var responseURL = await rootBundle.loadString('assets/config.json');
    Map<String, dynamic> config = jsonDecode(responseURL);
    targetURL = "http://${config['ip']}:5000/api/privatechat/" +
        emailPref +
        "/" +
        usingUser.email;

    // print("Ucitavam poruke clanova A:" +
    //     emailPref +
    //     ", B:" +
    //     usingUser.email +
    //     "\n");
    //print(targetURL);
    await novePoruke();
  }

  Future<void> novePoruke() async {
    var result = await http.get(targetURL);
    //print(result.statusCode);
    if (result.statusCode == 200) {
      var items = json.decode(result.body);
      List<dynamic> poruke = [];
      Set skupPoruka = new Set();
      for (int i = items.length - 1; i >= 0; i--) {
        if (items[i]['messageContent'].startsWith("#@#") &&
            items[i]['messageContent'].endsWith("@#@")) {
          var poster =
              postModel.getByID(int.parse(items[i]['messageContent'][3]));
          poruke.add(Message(
              items[i]["messageFrom"],
              items[i]["messageTo"],
              new Oglas(
                  idOglasa: poster.id,
                  naslov: poster.name,
                  poslednjaPonuda: poster.currentBid,
                  kupiOdmah: poster.price,
                  screenWidth: MediaQuery.of(context).size.width * 0.8,
                  screenHeight: MediaQuery.of(context).size.height * 0.8,
                  tip: poster.typeofPoster,
                  context: context,
                  dodatneInfo: poster.additionalInfo),
              items[i]["date"]));
          continue;
        }
        // print("DATUM JE " + items[i]["date"]);
        /*print(items[i]["messageFrom"] +
            " , " +
            items[i]["messageTo"] +
            " , " +
            items[i]["messageContent"] +
            " , " +
            items[i]["date"]);*/
        poruke.add(Message(items[i]["messageFrom"], items[i]["messageTo"],
            items[i]["messageContent"], items[i]["date"]));
        skupPoruka.add(items[i]["messageContent"]);
      }
      setState(() {
        messages = poruke;
        skupSvihPoruka = skupPoruka;
        loading = false;
      });
    } else {
      messages = [];
      //print("Nema poruka u cetu!\n");
      setState(() {
        loading = false;
      });
    }
  }

  //2
  @override
  Widget build(BuildContext context) {
    List<Message> poruke = [];

    if (loading) {
      return Container(
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
                    style: TextStyle(inherit: false, color: Color(0xff59071a)),
                  )),
              CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Color(0xff59071a)),
              ),
            ],
          )));
    } else if (loading == false && messages.length == 0) {
      for (int i = 0; i < messages.length; i++) {
        poruke.add(messages[i]);
      }
      for (int i = 0; i < signalR.novePoruke.length; i++) {
        Message novaPoruka = signalR.novePoruke[i];
        poruke.add(novaPoruka);
        skupSvihPoruka.add(novaPoruka);
      }
      return Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(55.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                title: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: CircleAvatar(
                          backgroundImage: (NetworkImage(
                            "http://147.91.204.116:11128/ipfs/${usingDate.pictures}",
                          )),
                          maxRadius: 40,
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 20, left: 30),
                          child: Text(
                            usingUser.firstname + " " + usingUser.lastname,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          )),
                    ],
                  ),
                ),
              )),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(children: <Widget>[
              Center(child: Text("Nemate poruka sa korisnikom.")),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          newMessage.text =
                              ShippingInfoFormatter.format(usingUser);
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Color(0xff59071a),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: messageSending
                              ? Container(
                                  child: Center(
                                      child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: Text(
                                          "Slanje...",
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              inherit: false,
                                              color: Color(0xff59071a)),
                                        )),
                                    CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Color(0xff59071a)),
                                    ),
                                  ],
                                )))
                              : TextField(
                                  controller: newMessage,
                                  decoration: InputDecoration(
                                      hintText: "Napiši poruku...",
                                      hintStyle:
                                          TextStyle(color: Colors.black54),
                                      border: InputBorder.none),
                                ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          if (!messageSending) {
                            if (newMessage.text != "" ||
                                newMessage.text != "\n" ||
                                newMessage.text != " ") {
                              await signalR.startConnection();
                              setState(() {
                                messageSending = true;
                              });
                              await signalR.sendMessage(
                                  emailPref, usingUser.email, newMessage.text);
                              //messages.add(message);
                              newMessage.text = "";
                              await novePoruke();
                              setState(() {
                                messageSending = false;
                              });
                            }
                          }
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        backgroundColor: Color(0xff59071a),
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
          );
    } else {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(55.0),
            child: AppBar(
              //automaticallyImplyLeading: false,
              title: Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: CircleAvatar(
                        //backgroundImage: AssetImage('images/profilnaSlika.jpg'),
                        backgroundImage: (NetworkImage(
                          "http://147.91.204.116:11128/ipfs/${usingDate.pictures}",
                        )),
                        maxRadius: 40,
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 20, left: 30),
                        child: Text(
                          usingUser.firstname + " " + usingUser.lastname,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
              ),
            )),
        body:
        Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                color: Color(0xffD5F5E7),
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.only(bottom: 55),
                child: ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    index = messages.length - index - 1;
                    var vreme =
                        messages[index].time.split("T")[1].split(":")[0] +
                            ":" +
                            messages[index].time.split("T")[1].split(":")[1] +
                            " " +
                            messages[index].time.split("-")[2].split("T")[0] +
                            "/" +
                            messages[index].time.split("-")[1] +
                            "/" +
                            messages[index].time.split("-")[0];
                    String date = vreme;
                    /*String formattedTime = DateTimeFormatter.formattedDate(date) +
                        " " +
                        DateTimeFormatter.formattedTime(date);*/
                    return Container(
                      padding: EdgeInsets.only(
                          left: 14, right: 14, top: 10, bottom: 10),
                      child: Align(
                        alignment: (messages[index].receiver == emailPref
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (messages[index].receiver == emailPref
                                ? Colors.white
                                : Color(0xff5F968E)),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              messages[index].messageText is Oglas
                                  ? messages[index].messageText
                                  : Text(messages[index].messageText,
                                      style:
                                          messages[index].receiver == emailPref
                                              ? TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black)
                                              : TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white)),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(date,
                                    style: messages[index].receiver == emailPref
                                        ? TextStyle(
                                            fontSize: 12, color: Colors.black)
                                        : TextStyle(
                                            fontSize: 12, color: Colors.white),
                                    textAlign:
                                        messages[index].receiver == emailPref
                                            ? TextAlign.left
                                            : TextAlign.right),
                              ),
                              /*Align(
                                    alignment: messages[index].messageType == "receiver" ? Alignment.bottomLeft : Alignment.bottomRight,
                                    child:
                                  )*/
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // RED Color(0xff59071a)
              // GREEN
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          newMessage.text =
                              ShippingInfoFormatter.format(usingUser);
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Color(0xff59071a),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: messageSending
                              ? Container(
                                  child: Center(
                                      child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: Text(
                                          "Slanje...",
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              inherit: false,
                                              color: Color(0xff59071a)),
                                        )),
                                    CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Color(0xff59071a)),
                                    ),
                                  ],
                                )))
                              : TextField(
                                  controller: newMessage,
                                  decoration: InputDecoration(
                                      hintText: "Napiši poruku...",
                                      hintStyle:
                                          TextStyle(color: Colors.black54),
                                      border: InputBorder.none),
                                ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          if (!messageSending) {
                            if (newMessage.text != "" ||
                                newMessage.text != "\n" ||
                                newMessage.text != " ") {
                              await signalR.startConnection();
                              setState(() {
                                messageSending = true;
                              });
                              await signalR.sendMessage(
                                  emailPref, usingUser.email, newMessage.text);
                              //messages.add(message);
                              newMessage.text = "";
                              await novePoruke();
                              setState(() {
                                messageSending = false;
                              });
                            }
                          }
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        backgroundColor: Color(0xff59071a),
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
