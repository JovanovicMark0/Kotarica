import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/pages/ProfilePage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class LikesModel extends ChangeNotifier {
  //static Like currentLike;
  List<LikedUsers> lajkovani = [];
  List<IGraded> jaLajkovao = [];
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

  ContractFunction _likedUsersAmount;
  ContractFunction _iGradedLikesAmount;
  ContractFunction _likedUsers;
  ContractFunction _iGradedLikes;
  ContractFunction _addLike;
  ContractFunction _addDislike;
  ContractFunction _addILiked;
  ContractFunction _addIDisLiked;

  LikesModel() {
    // constructor
  }

  String response;
  var prefs;
  var prefsPk;
  get idLiked => null;

  Future<void> initiateSetup() async {
    response = await rootBundle.loadString('assets/config.json');
    Map<String, dynamic> config = jsonDecode(response);
    _rpcUrl = "http://${config['ip']}:${config['port']}";
    _wsUrl = "ws://${config['ip']}:${config['port']}/";
    prefs = await SharedPreferences.getInstance();
    prefsPk = prefs.getString("privateKey") ?? -1;
    if(prefsPk != -1)
      _privateKey = prefs.getString("privateKey");
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
    // MOBILNA
    String abiStringFile =
        await rootBundle.loadString("src/abis/LikesContract.json");

    var jsonAbi = jsonDecode(abiStringFile);

    // SERVER
    // final response = await http.get(Uri.http('147.91.204.116:11120', 'LikesContract.json'));
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
        ContractAbi.fromJson(_abiCode, "LikesContract"), _contractAddress);

    _likedUsersAmount = _contract.function("likedUsersAmount");
    _iGradedLikesAmount = _contract.function("iGradedLikesAmount");
    _likedUsers = _contract.function("likedUsers");
    _iGradedLikes = _contract.function("iGradedLikes");
    _addLike = _contract.function("addLike");
    _addDislike = _contract.function("addDislike");
    _addILiked = _contract.function("addILiked");
    _addIDisLiked = _contract.function("addIDisLiked");
    await getLiked();
  }

  getLiked() async {
    BigInt totalLikesBigInt = (await _client
        .call(contract: _contract, function: _likedUsersAmount, params: []))[0];

    int totalLikes = totalLikesBigInt.toInt();
    lajkovani.clear();
    for (var i = 0; i < totalLikes; i++) {
      var temp = await _client.call(
          contract: _contract, function: _likedUsers, params: [BigInt.from(i)]);
      lajkovani.add(LikedUsers(
          idUser: (temp[0]).toInt(),
          idLikedMe: (temp[1]).toInt(),
          isLiked: (temp[2]).toInt(),
          message: temp[3]));
    }
    BigInt totalILikesBigInt = (await _client.call(
        contract: _contract, function: _iGradedLikesAmount, params: []))[0];

    int totalLikes2 = totalILikesBigInt.toInt();
    jaLajkovao.clear();
    for (var i = 0; i < totalLikes2; i++) {
      var temp = await _client.call(
          contract: _contract,
          function: _iGradedLikes,
          params: [BigInt.from(i)]);
      jaLajkovao.add(IGraded(
          idUser: (temp[0]).toInt(),
          idILiked: (temp[1]).toInt(),
          isLiked: (temp[2]).toInt(),
          message: temp[3]));
    }
    isLoading = false;
    notifyListeners();
  }

  addLike(int korisnik1, int korisnik2, String mess) async {
    isLoading = true;
    var id1 = new BigInt.from(korisnik1);
    var id2 = new BigInt.from(korisnik2);
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            maxGas: 6721975,
            function: _addLike,
            parameters: [id1, id2, mess]));

    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            maxGas: 6721975,
            function: _addILiked,
            parameters: [id1, id2, mess]));
    getLiked();
  }

  addDislike(int korisnik1, int korisnik2, String mess) async {
    isLoading = true;
    var id1 = new BigInt.from(korisnik1);
    var id2 = new BigInt.from(korisnik2);
    notifyListeners();
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        maxGas: 6721975,
        function: _addDislike,
        parameters: [id1, id2, mess],
      ),
    );
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        maxGas: 6721975,
        function: _addIDisLiked,
        parameters: [id1, id2, mess],
      ),
    );

    getLiked();
  }

  Future<List<dynamic>> loadLiked(lista) async {
    List<LikedUsers> lista = [];
    for (var i = 0; i < lajkovani.length; i++) {
      lista.add(LikedUsers(
          idUser: lajkovani[i].idUser,
          idLikedMe: lajkovani[i].idLikedMe,
          isLiked: lajkovani[i].isLiked,
          message: lajkovani[i].message));
    }
    return lista;
  }

  List<dynamic> loadILiked(lista) {
    List<IGraded> lista = [];
    for (var i = 0; i < jaLajkovao.length; i++) {
      lista.add(IGraded(
          idUser: jaLajkovao[i].idUser,
          idILiked: jaLajkovao[i].idILiked,
          isLiked: jaLajkovao[i].isLiked,
          message: jaLajkovao[i].message));
    }
    return lista;
  }

  Future<String> getMyGradedList(id, screenWidth, screenHeight) async {
    return lajkovani.length.toString();
  }

  Future<String> getWhatIGradedList(id, screenWidth, screenHeight) async {
    return jaLajkovao.length.toString();
  }
}

class LikedUsers {
  int idUser;
  int idLikedMe;
  int isLiked;
  String message;

  LikedUsers({this.idUser, this.idLikedMe, this.isLiked, this.message});
}

class IGraded {
  int idUser;
  int idILiked;
  int isLiked;
  String message;

  IGraded({this.idUser, this.idILiked, this.isLiked, this.message});
}
