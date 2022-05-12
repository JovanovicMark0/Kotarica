import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class BucketModel extends ChangeNotifier {
  static Bucket currentBucket;
  List<Bucket> bucket = [];
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
  _bucketCount; // varijable iz ugovora Contracts/UsersContracts.sol
  ContractFunction _bucket;
  ContractFunction _addToBucketList;
  ContractFunction _getBasket;
  var prefsPk;

  BucketModel() {
    // constructor
    initiateSetup();
  }

  String response;
  var prefs;

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
    await rootBundle.loadString("src/abis/BucketContract.json");

    var jsonAbi = jsonDecode(abiStringFile);

    // SERVER
    // final response =
    //     await http.get(Uri.http('147.91.204.116:11120', 'BucketContract.json'));
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
        ContractAbi.fromJson(_abiCode, "BucketContract"), _contractAddress);

    _bucketCount = _contract.function("bucketAmount");
    _bucket = _contract.function("bucket");
    _addToBucketList = _contract.function("addToBucketList");
    _getBasket = _contract.function("getBasket");

    getBucket();
  }

  getBucket() async {
    BigInt totalLikesBigInt = (await _client
        .call(contract: _contract, function: _bucketCount, params: []))[0];

    int totalLikes = totalLikesBigInt.toInt();
    bucket.clear();
    for (var i = 0; i < totalLikes; i++) {
      var temp = await _client.call(
          contract: _contract, function: _bucket, params: [BigInt.from(i)]);
      bucket.add(Bucket(id: temp[0], bucketList: temp[1], nBucket: temp[2]));
    }

    isLoading = false;
    notifyListeners();
  }

  addToBucketList(int idUser, int idPost) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            maxGas: 6721975,
            contract: _contract,
            function: _addToBucketList,
            parameters: [idUser, idPost]));

    getBucket();
  }

  getBasket(int korisnik1) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            maxGas: 6721975,
            contract: _contract,
            function: _getBasket,
            parameters: [korisnik1]));

    getBucket();
  }

  Bucket getCurrentBucket() {
    return currentBucket;
  }
}

class Bucket {
  int id;
  List<int> bucketList;
  int nBucket;
  Bucket({this.id, this.bucketList, this.nBucket});
}
