import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';

class SignalR extends ChangeNotifier {
  List<Message> novePoruke = [];
  HubConnection connection;

  SignalR() {}

  initSignalR() async {
    var responseURL = await rootBundle.loadString('assets/config.json');
    Map<String, dynamic> config = jsonDecode(responseURL);
    final serverUrl = "http://${config['ip']}:5000/chatter";
    connection = HubConnectionBuilder().withUrl(serverUrl).build();
    connection.on('newMessage', novaPoruka);

    //startConnection();
  }

  startConnection() async {
    if (connection.state == HubConnectionState.Disconnected) {
      await connection.start();
    }
  }

  closeConnection() async {
    if (connection.state != HubConnectionState.Disconnected)
      await connection.stop();
  }

  sendMessage(
      String MessageFrom, String MessageTo, String MessageContent) async {
    await connection.invoke("SendMessage",
        args: <Object>[MessageFrom, MessageTo, MessageContent]);
  }

  novaPoruka(List<Object> args) {

    novePoruke.add(Message(args[0], args[1], args[2], args[3]));
    notifyListeners();
  }
}

class Message {
  String sender;
  String receiver;
  var messageText;
  String time;

  Message(String From, String To, var Content, String Time) {
    sender = From;
    receiver = To;
    messageText = Content;
    time = Time;
  }
}
//Time.split("T")[1].split(":")[0] + ":" + Time.split("T")[1].split(":")[1] + " " + Time.split("-")[2].split("T")[0]+"/"+Time.split("-")[1]+"/"+Time.split("-")[0]