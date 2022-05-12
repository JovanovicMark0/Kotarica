import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class GradeModel extends ChangeNotifier {
  static Grade currentWish;
  List<Grade> grades = [];
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
      _gradeCount; // varijable iz ugovora Contracts/UsersContracts.sol
  ContractFunction _grades;
  ContractFunction _addToGradeList;

  GradeModel() {
    // constructor
    //initiateSetup();
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
        await rootBundle.loadString("src/abis/GradeContract.json");

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
        ContractAbi.fromJson(_abiCode, "GradeContract"), _contractAddress);

    _gradeCount = _contract.function("gradeAmount");
    _grades = _contract.function("grades");
    _addToGradeList = _contract.function("addToGradeList");

    await getGrades();
  }

  getGrades() async {
    BigInt totalGradesBigInt = (await _client
        .call(contract: _contract, function: _gradeCount, params: []))[0];

    int totalGrades = totalGradesBigInt.toInt();
    grades.clear();
    for (var i = 0; i < totalGrades; i++) {
      var temp = await _client.call(
          contract: _contract, function: _grades, params: [BigInt.from(i)]);
      grades.add(Grade(
          idUser: temp[0].toInt(),
          idPost: temp[1].toInt(),
          grade: temp[2].toInt())); //temp[2].toInt()));
    }

    isLoading = false;
    notifyListeners();
  }

  addToGradeList(int idUser, int idPost, int grade) async {
    isLoading = true;
    notifyListeners();
    var userID = new BigInt.from(idUser);
    var postID = new BigInt.from(idPost);
    var ocena = new BigInt.from(grade);
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            maxGas: 6721975,
            function: _addToGradeList,
            parameters: [userID, postID, ocena]));
    await getGrades();
  }

  List<Grade> loadGradeList(lista) {
    List<Grade> lista = [];
    for (var i = 0; i < grades.length; i++) {
      lista.add(Grade(
          idUser: grades[i].idUser,
          idPost: grades[i].idPost,
          grade: grades[i].grade));
    }
    return lista;
  }

  List<int> getPostListById(int korisnik1) {
    List<int> listaZaVracanje = [];
    //List<Wish> lista = loadWishList([]);
    for (var i = 0; i < grades.length; i++) {
      if (grades[i].idUser == korisnik1) {
        listaZaVracanje.add(grades[i].idPost);
      }
    }
    listaZaVracanje.toSet().toList();
    return listaZaVracanje;
  }

  int ocenio(int idUser, idPost) {
    int flag = 0;
    for (var i = 0; i < grades.length; i++) {
      if (grades[i].idUser == idUser && grades[i].idPost == idPost)
        flag = grades[i].grade;
    }
    return flag;
  }
}

class Grade {
  int idUser;
  int idPost;
  int grade;
  Grade({this.idUser, this.idPost, this.grade});
}
