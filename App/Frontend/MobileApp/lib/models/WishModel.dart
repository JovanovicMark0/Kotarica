import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class WishModel extends ChangeNotifier {
  static Wish currentWish;
  List<Wish> wishes = [];
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
      _wishCount; // varijable iz ugovora Contracts/UsersContracts.sol
  ContractFunction _wishes;
  ContractFunction _addToWishList;
  ContractFunction _removeFromWishList;

  WishModel() {
    // constructor
    initiateSetup();
  }

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
    if(prefsPk != -1)
      _privateKey = prefsPk;
    else
      _privateKey = "0"*64;
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
        await rootBundle.loadString("src/abis/WishContract.json");

    var jsonAbi = jsonDecode(abiStringFile);

    //SERVER
    // final response =
    //     await http.get(Uri.http('147.91.204.116:11120', 'WishContract.json'));
    // var jsonAbi;
    // if (response.statusCode == 200) {
    //   jsonAbi = jsonDecode(response.body);
    // } else {
    //   throw Exception('Failed to load data from server');
    // }
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    if(prefsPk != -1) {
      _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    }
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "WishContract"), _contractAddress);

    _wishCount = _contract.function("wishAmount");
    _wishes = _contract.function("wishes");
    _addToWishList = _contract.function("addToWishList");
    _removeFromWishList = _contract.function("removeFromWishList");

    await getWish();
  }

  getWish() async {
    BigInt totalWishesBigInt = (await _client
        .call(contract: _contract, function: _wishCount, params: []))[0];

    int totalWishes = totalWishesBigInt.toInt();
    wishes.clear();
    for (var i = 0; i < totalWishes; i++) {
      var temp = await _client.call(
          contract: _contract, function: _wishes, params: [BigInt.from(i)]);
      wishes.add(Wish(
        idUser: temp[0].toInt(),
        idPost: temp[1].toInt(),
      )); //temp[2].toInt()));
    }

    isLoading = false;
    notifyListeners();
  }

  addToWishList(int idUser, int idPost) async {
    isLoading = true;
    notifyListeners();
    var userID = new BigInt.from(idUser);
    var postID = new BigInt.from(idPost);
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            maxGas: 6721975,
            function: _addToWishList,
            parameters: [userID, postID]));
    await getWish();
  }

  removeFromWishList(int idUser, int idPost) async {
    isLoading = true;
    notifyListeners();
    var userID = new BigInt.from(idUser);
    var postID = new BigInt.from(idPost);
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            maxGas: 6721975,
            function: _removeFromWishList,
            parameters: [userID, postID]));
    await getWish();
  }

  List<Wish> loadWishList(lista) {
    List<Wish> lista = [];
    for (var i = 0; i < wishes.length; i++) {
      lista.add(Wish(idUser: wishes[i].idUser, idPost: wishes[i].idPost));
    }
    return lista;
  }

  List<int> getWishList(int korisnik1) {
    List<int> listaZaVracanje = [];
    //List<Wish> lista = loadWishList([]);
    for (var i = 0; i < wishes.length; i++) {
      if (wishes[i].idUser == korisnik1) {
        listaZaVracanje.add(wishes[i].idPost);
      }
    }
    listaZaVracanje.toSet().toList();
    return listaZaVracanje;
  }

  Wish getCurrentBucket() {
    return currentWish;
  }
}

class Wish {
  int idUser;
  int idPost;
  Wish({this.idUser, this.idPost});
}
