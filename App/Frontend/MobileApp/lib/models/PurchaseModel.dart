import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class PurchaseModel extends ChangeNotifier {
  List<Purchase> purchases = [];
  bool isLoading;

  String _rpcUrl; // HHTTP://192.168.0.11:7545
  String _wsUrl; // ws://192.168.1.110:7545/
  String port;

  String _privateKey;

  Web3Client _client;

  String _abiCode;
  EthereumAddress _contractAddress;
  EthereumAddress _ownAddress;
  DeployedContract _contract;
  Credentials _credentials;

  // varijable iz ugovora Contracts/UsersContracts.sol
  ContractFunction _listOfUsersWhoBought;
  ContractFunction _buy;
  ContractFunction _getBoughtList;
  ContractFunction _getBoughtDateList;

  PurchaseModel();

  String response;
  var prefs;
  var prefsPk;

  Future<void> initiateSetup() async {
    response = await rootBundle.loadString('assets/config.json');
    Map<String, dynamic> config = jsonDecode(response);
    port = config['port'];
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
    // MOBILNA
    String abiStringFile =
    await rootBundle.loadString("src/abis/BuyContract.json");

    var jsonAbi = jsonDecode(abiStringFile);

    // SERVER
    // final response = await http.get(Uri.http('147.91.204.116:11120', 'BuyContract.json'));
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
      _ownAddress = await _credentials.extractAddress();
    }
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "PosterContract"), _contractAddress);
    _listOfUsersWhoBought = _contract.function("listOfUsersWhoBought");
    _buy = _contract.function("buy");
    _getBoughtList = _contract.function("getBoughtList");
    _getBoughtDateList = _contract.function("getBoughtDateList");
  }

  Future<void> buy(int _userID, int _postID, DateTime date, String sender, String receiver, double priceInEther) async {
    List<BigInt> _datum = [];
    _datum.add(BigInt.from(date.year));
    _datum.add(BigInt.from(date.month));
    _datum.add(BigInt.from(date.day));
    _datum.add(BigInt.from(date.day));
    _datum.add(BigInt.from(date.minute));
    _datum.add(BigInt.from(date.second));

    var _user = BigInt.from(_userID);
    var _post = BigInt.from(_postID);

    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            maxGas: 6721975,
            contract: _contract,
            function: _buy,
            parameters: [
              _user,
              _post,
              _datum,
            ]));
  }

  transactEthers(String publicKey1, String publicKey2, double amountEther) async
  {
    EtherAmount amount = new EtherAmount.inWei(BigInt.from(amountEther*100000000*10000000000));
    // EthereumAddress adresa = await unlocked.extractAddress();
    //print(adresa.toString());
    EthereumAddress sender = EthereumAddress.fromHex(publicKey1);
    EthereumAddress receiver = EthereumAddress.fromHex(publicKey2);
    await _client.sendTransaction(_credentials,
        Transaction(from: sender,
          to: receiver,
          value:amount,
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 6721975, ));

  }

  getDates(int _userID) async {
    var dateListBigInt = await _client.call(
        contract: _contract,
        function: _getBoughtDateList,
        params: [BigInt.from(_userID)]);

    var dateListBigInt2 = []; //TODO razdvoji sate, minute ...
    for (int i = 0; i < dateListBigInt.length; i++) {
      dateListBigInt2.add(dateListBigInt[i].toInt());
    }
    List<Date> dateList = dateListBigInt2.cast<Date>();

    return dateList;
  }

  getBought(int _userID) async {
    var boughtListBigInt = await _client.call(
        contract: _contract,
        function: _getBoughtList,
        params: [BigInt.from(_userID)]);

    var boughtListBigInt2 = [];
    for (int i = 0; i < boughtListBigInt.length; i++) {
      boughtListBigInt2.add(boughtListBigInt[i].toInt());
    }
    List<Date> boughtList = boughtListBigInt2.cast<Date>();

    return boughtList;
  }
}

class Date {
  int year;
  int month;
  int day;
  int hour;
  int minut;
  int second;
  Date({this.year, this.month, this.day, this.hour, this.minut, this.second});
}

class Purchase {
  List<int> listOfBoughtProducts = [];
  List<Date> daysOfPurchases = [];
  int nBought;

  Purchase({this.listOfBoughtProducts, this.daysOfPurchases, this.nBought});
}
