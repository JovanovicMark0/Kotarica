import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class NotificationModel extends ChangeNotifier {
  static Notification currentNotification;
  List<Notification> notifications = [];
  bool isLoading = true;
  String _rpcUrl; //HTTP://192.168.1.110:7545
  String _wsUrl; //ws://192.168.1.110:7545/

  String _privateKey;

  Web3Client _client;

  String _abiCode;
  EthereumAddress _contractAddress;
  //EthereumAddress _ownAddress;
  DeployedContract _contract;
  Credentials _credentials;

  ContractFunction
      _notificationsCount; // varijable iz ugovora Contracts/UsersContracts.sol
  ContractFunction _notifications;
  ContractFunction _addNotification;

  NotificationModel() {}

  String response;
  var prefs;
  var prefsPk;

  Future<void> initiateSetup() async {
    response = await rootBundle.loadString('assets/config.json');
    Map<String, dynamic> config = jsonDecode(response);
    _rpcUrl = "http://${config['ip']}:${config['port']}";
    _wsUrl = "ws://${config['ip']}:${config['port']}/";
    prefs = await SharedPreferences.getInstance();
    prefsPk = prefs.getString("privateKey") ?? -1;
    if (prefsPk != -1)
      _privateKey = prefsPk;
    else
      _privateKey = "0" * 64;
    await initiateSetup2();
  }

  Future<void> initiateSetup2() async {
    _client = Web3Client(_rpcUrl, http.Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    //MOBILNA
    String abiStringFile =
        await rootBundle.loadString("src/abis/NotificationContract.json");

    var jsonAbi = jsonDecode(abiStringFile);

    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    if (prefsPk != -1) {
      _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    }
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "NotificationContract"),
        _contractAddress);

    _notificationsCount = _contract.function("notificationAmount");
    _notifications = _contract.function("notifications");
    _addNotification = _contract.function("addNotification");

    await getNotifications();
  }

  getNotifications() async {
    BigInt totalNotificationBigInt = (await _client.call(
        contract: _contract, function: _notificationsCount, params: []))[0];

    int totaltotalNotifications = totalNotificationBigInt.toInt();
    notifications.clear();
    for (var i = 0; i < totaltotalNotifications; i++) {
      var temp = await _client.call(
          contract: _contract,
          function: _notifications,
          params: [BigInt.from(i)]);
      notifications.add(Notification(
          idUser: temp[0].toInt(),
          idPost: temp[1].toInt(),
          idPostOwner: temp[2].toInt())); //temp[2].toInt()));
    }

    isLoading = false;
    notifyListeners();
  }

  addNotification(int idUser, int idPost, int idOwner) async {
    isLoading = true;
    notifyListeners();
    var userID = new BigInt.from(idUser);
    var postID = new BigInt.from(idPost);
    var idOwner2 = new BigInt.from(idOwner);
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            maxGas: 6721975,
            function: _addNotification,
            parameters: [userID, postID, idOwner2]));
    getNotifications();
  }

  List<Notification> loadNotificationList(lista) {
    List<Notification> lista = [];
    for (var i = 0; i < notifications.length; i++) {
      lista.add(Notification(
          idUser: notifications[i].idUser,
          idPost: notifications[i].idPost,
          idPostOwner: notifications[i].idPostOwner));
    }
    return lista;
  }

  List<int> getNotificationListIBought(int korisnik1) {
    List<int> listaZaVracanje = [];
    List<Notification> lista = loadNotificationList([]);
    for (var i = 0; i < lista.length; i++) {
      if (lista[i].idUser == korisnik1) {
        listaZaVracanje.add(lista[i].idPost);
      }
    }
    listaZaVracanje.toSet().toList();
    return listaZaVracanje;
  }

  List<int> getNotificationList(int korisnik1) {
    List<int> listaZaVracanje = [];
    List<Notification> lista = loadNotificationList([]);
    for (var i = 0; i < lista.length; i++) {
      if (lista[i].idPostOwner == korisnik1) {
        listaZaVracanje.add(lista[i].idPost);
      }
    }
    listaZaVracanje.toSet().toList();
    return listaZaVracanje;
  }
}

class Notification {
  int idUser;
  int idPost;
  int idPostOwner;
  Notification({this.idUser, this.idPost, this.idPostOwner});
}
