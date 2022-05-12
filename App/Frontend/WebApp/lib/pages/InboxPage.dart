import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_app/utility/SignalRHelper.dart';
import 'package:flutter_app/models/UserModel.dart' as uss;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ConversationListModel.dart';
import '../utility/GetSize.dart';
import 'HomePage.dart';

class InboxPage extends StatefulWidget {
  String thisUser;
  InboxPage({this.thisUser});

  @override
  _InboxPageState createState() => _InboxPageState();
}

// komentar
class _InboxPageState extends State<InboxPage> {
  List<Message> svePoruke = [];
  Set skupSvihPoruka = new Set();
  TextEditingController newMessage = TextEditingController();

//1
  var usersChat;

  var list;
  uss.User usingUser;
  var lista;
  uss.Date usingDate;

  bool loading = true;
  SharedPreferences prefs;
  int idPref = -1;
  String emailPref = "";
  String imePref = "";
  String prezimePref = "";

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    list = await Provider.of<uss.UserModel>(context, listen: false);
    await list.initiateSetup();
  }

  senderPref(email) {
    return list.getUserByEmail(email);
  }

  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.getSharedPrefs().then((result) async {
        idPref = prefs.getInt("id");
        emailPref = prefs.getString("email");
        //ime = prefs.getString("firstname");
        prezimePref = prefs.getString("lastname");
        lista = list.loadDates([]);
        for (var i = 0; i < lista.length; i++) {
          if (lista[i].id == id) {
            usingDate = lista[i];
            break;
          }
        }
        await getMessages();
      });
    });
  }

  Future<void> getMessages() async {
    setState(() {
      loading = false;
    });

    var responseURL = await rootBundle.loadString('assets/config.json');
    Map<String, dynamic> config = jsonDecode(responseURL);
    var targetURL = "http://${config['ip']}:5000/api/messages/" + emailPref;


    var result = await http.get(targetURL);
    if (result.statusCode == 200) {
      var items = json.decode(result.body);
      List<Message> poruke = [];
      Set skupPoruka = new Set();
      for (int i = 0; i < items.length; i++) {
        poruke.add(Message(items[i]["messageFrom"], items[i]["messageTo"],
            items[i]["messageContent"], items[i]["date"]));
        skupPoruka.add(items[i]["messageContent"]);
      }
      setState(() {
        svePoruke = poruke;
        skupSvihPoruka = skupPoruka;
        loading = false;
      });
    } else {
      svePoruke = [];
      loading = false;
    }
  }

//2
  final double maxContainerWidth = 600;

  @override
  Widget build(BuildContext context) {
    var screenWidth = GetSize.getMaxWidth(context);
    //SIGNALR
    var signalR = Provider.of<SignalR>(context);
    List<Message> porukeKorisnika = [];

    for (int i = 0; i < svePoruke.length; i++) {
      porukeKorisnika.add(svePoruke[i]);
    }
    for (int i = 0; i < signalR.novePoruke.length; i++) {
      Message poruka = signalR.novePoruke[i];
      porukeKorisnika.add(poruka);
      skupSvihPoruka.add(poruka.messageText);
    }
    //

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
    } else if (loading == false && svePoruke.length == 0) {
      return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(55.0),
            child: AppBar(
              elevation: 0,
              title: Text("Moje poruke"),
              centerTitle: true,
            ),
          ),
          body: Center(child: Text("Sanduče za poruke je prazno.")));
    } else {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55.0),
          child: Container(
            //padding: EdgeInsets.only(left: 35, right: 35),
            child: AppBar(
              elevation: 0,
              title: Text("Moje poruke"),
              centerTitle: true,
            ),
          ),
        ),
        body: Container(
          width: screenWidth,
          height: GetSize.getMaxHeight(context),
          //margin: EdgeInsets.fromLTRB(screenWidth * 0.03, 0.0, 10.0, 8.0),
          //padding: EdgeInsets.only(left: , right: 400),
          child: Stack(children: [
            Container(
              height: GetSize.getMaxHeight(context),
              color: Color(0xffD5F5E7),
            ),
            ListView.builder(
              itemCount: svePoruke.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return ConversationList(
                  secondUser: emailPref == svePoruke[index].receiver
                      ? senderPref(svePoruke[index].sender)
                      : senderPref(svePoruke[index].receiver),
                  name: emailPref == svePoruke[index].sender
                      ? senderPref(svePoruke[index].receiver)
                      : senderPref(svePoruke[index].sender),
                  messageText: svePoruke[index].messageText,
                  imageUrl: "http://147.91.204.116:11128/ipfs/${usingDate.pictures}",
                  time: svePoruke[index].time.split("T")[1].split(":")[0] +
                      ":" +
                      svePoruke[index].time.split("T")[1].split(":")[1] +
                      "\n" +
                      svePoruke[index].time.split("-")[2].split("T")[0] +
                      "/" +
                      svePoruke[index].time.split("-")[1] +
                      "/" +
                      svePoruke[index].time.split("-")[0],
                  //time: svePoruke[svePoruke.length-1].time.toString(),
                  newMessage:
                      (index == 0 || index == 3) ? false : false, //true false
                );
              },
            ),
          ]),
        ),
      );
    }
  }
}
