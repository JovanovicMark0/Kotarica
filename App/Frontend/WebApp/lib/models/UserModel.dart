import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/pages/ProfilePage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:string_validator/string_validator.dart';

import '../pages/HomePage.dart';

class UserModel extends ChangeNotifier {
  // int usersCount = 0;
  List<User> users = [];
  List<Date> dates = [];
  bool isLoading = true;
  String _rpcUrl; //HTTP://192.168.1.110:7545
  String _wsUrl; //ws://192.168.1.110:7545/

  String _privateKey;

  Web3Client _client;

  String _abiCode;
  EthereumAddress _contractAddress;
  EthereumAddress _ownAddress;
  DeployedContract _contract;
  Credentials _credentials;

  ContractFunction
  _userCount; // varijable iz ugovora Contracts/UsersContracts.sol
  ContractFunction _users;
  ContractFunction _createUser;
  ContractFunction _deleteUser;
  ContractFunction _editUser;
  ContractFunction _editPicture;
  ContractFunction _getPrivateKey;
  ContractEvent _UserCreated;

  ContractFunction
  _dateCount; // varijable iz ugovora Contracts/UsersContracts.sol
  ContractFunction _dates;
  ContractFunction _createDate;
  ContractEvent _DateCreated;

  SharedPreferences prefs;
  UserModel() {}
  var prefsPk;
  String response;

  Future<void> initiateSetup() async {

    response = await rootBundle.loadString('assets/config.json');
    Map<String, dynamic> config = await jsonDecode(response);
    _rpcUrl = "http://${config['ip']}:${config['port']}";
    _wsUrl = "ws://${config['ip']}:${config['port']}/";
    prefs = await SharedPreferences.getInstance();
    _privateKey = prefs.getString("privateKey");
    //_privateKey = config['privateKey'];
    prefsPk = _privateKey ?? -1;
    if(prefsPk != -1) {
      _privateKey = prefsPk;
    } else
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
    await rootBundle.loadString("src/abis/UsersContract.json");

    var jsonAbi = jsonDecode(abiStringFile);

    // SERVER
    // final response = await http.get(Uri.http('147.91.204.116:11120', 'UsersContract.json'));
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
    if(prefsPk != -1 && isHexadecimal(prefsPk)) {
      _credentials = await _client.credentialsFromPrivateKey(_privateKey);
      _ownAddress = await _credentials.extractAddress();
    }
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "UsersContract"), _contractAddress);

    _userCount = _contract.function("usersCount");
    _users = _contract.function("users");
    _createUser = _contract.function("createUser");
    _editUser = _contract.function("editUser");
    _editPicture = _contract.function("editPicture");
    _deleteUser = _contract.function("deleteUser");
    _UserCreated = _contract.event("UserCreated");
    _dateCount = _contract.function("dateCount");
    _dates = _contract.function("dates");
    _getPrivateKey = _contract.function("getPrivateKey");
    _createDate = _contract.function("createDate");
    _DateCreated = _contract.event("DateCreated");
    await getUser();
    await getDate();
  }
  Future<String> getPKS(int id) async {
    return (await _client.call(
        contract: _contract, function: _getPrivateKey, params: [BigInt.from(id)]))[0];
  }
  getUser() async {
    BigInt totalUsersBigInt = (await _client
        .call(contract: _contract, function: _userCount, params: []))[0];

    int totalUsers = totalUsersBigInt.toInt();
    users.clear();
    users = [];
    for (var i = 0; i < totalUsers; i++) {
      var temp = await _client.call(
          contract: _contract, function: _users, params: [BigInt.from(i)]);

      users.add(User(
          id: (temp[0]).toInt(),
          firstname: temp[1],
          lastname: temp[2],
          email: temp[3],
          password: temp[4],
          primaryAddress: temp[5],
          secondaryAddress: temp[6],
          phone: temp[7]));
    }
    isLoading = false;
    notifyListeners();
  }

  getDate() async {
    BigInt totalDatesBigInt = (await _client
        .call(contract: _contract, function: _dateCount, params: []))[0];

    int totalDates = totalDatesBigInt.toInt();
    dates.clear();
    for (var i = 0; i < totalDates; i++) {
      var temp = await _client.call(
          contract: _contract, function: _dates, params: [BigInt.from(i)]);
      dates.add(Date(
          id: (temp[0]).toInt(),
          day: (temp[1]).toInt(),
          month: (temp[2]).toInt(),
          year: (temp[3]).toInt(),
          hour: (temp[4]).toInt(),
          minut: (temp[5]).toInt(),
          pictures: temp[6]));
    }

    isLoading = false;
    notifyListeners();
  }

  Future<String> checkUser(String email, String pass) async {
    getUser();
    isLoading = true;
    for (var i = 0; i < users.length; i++) {
      if (users[i].email == email) {
        //provera emaila
        if (users[i].password == pass) {
          prefs.setInt("id", users[i].id);
          prefs.setString("email", users[i].email);
          prefs.setString("password", users[i].password);
          prefs.setString("firstname", users[i].firstname);
          prefs.setString("lastname", users[i].lastname);
          prefs.setString("password", users[i].password);
          prefs.setString("phone", users[i].phone);
          prefs.setString("primaryAddress", users[i].primaryAddress);
          prefs.setString("secondaryAddress", users[i].secondaryAddress);
          var temp = await _client.call(
              contract: _contract, function: _getPrivateKey, params: [BigInt.from(i)]);
          prefs.setString("privateKey", temp[0].split("|")[0]);
          prefs.setString("publicKey", temp[0].split("|")[1]);
          isLoading = false;
          return "true";
        }
        isLoading = false;
        return "WrongPass";
      }
    }
    isLoading = false;
    return "WrongEmail";
  }

  User getUserById(int id) {
    for (var i = 0; i < users.length; i++) {
      if (users[i].id == id) {
        return users[i];
      }
    }
    return null;
  }

  String getNameById(int id) {
    for (var i = 0; i < users.length; i++) {
      if (users[i].id == id) {
        return users[i].firstname;
      }
    }
    return null;
  }

  User getUserByEmail(String email) {
    for (var i = 0; i < users.length; i++) {
      if (users[i].email == email) {
        return users[i];
      }
    }
    return null;
  }

  List<dynamic> loadDates(lista) {
    List lista = [];
    for (var i = 0; i < dates.length; i++) {
      lista.add(Date(
          id: dates[i].id,
          day: dates[i].day,
          month: dates[i].month,
          year: dates[i].year,
          hour: dates[i].hour,
          minut: dates[i].minut,
          pictures: dates[i].pictures));
    }
    return lista;
  }

  List<dynamic> loadUsers(lista) {
    List lista = [];
    for (var i = 0; i < users.length; i++) {
      lista.add(User(
          id: users[i].id,
          email: users[i].email,
          password: users[i].password,
          firstname: users[i].firstname,
          lastname: users[i].lastname,
          primaryAddress: users[i].primaryAddress,
          secondaryAddress: users[i].secondaryAddress,
          phone: users[i].phone));
    }
    return lista;
  }

  Future<int> addUser(
      String ime,
      String prezime,
      String mejl,
      String lozinka,
      String primarnaAdresa,
      String sekundarnaAdresa,
      String brojTelefona,
      int id,
      int dan,
      int mesec,
      int godina,
      int sat,
      int minut,
      String pictures) async {
    getUser();
    isLoading = true;
    int flag = 0;
    for (var i = 0; i < users.length; i++) {
      if (users[i].email == mejl) {
        flag = 1;
        isLoading = false;
      }
    }
    String _publicKey = prefs.getString("publicKey");
    String _privateKey2 = prefs.getString("privateKey");
    String kljucevi = _privateKey2+"|"+ _publicKey;
    notifyListeners();
    if (flag == 0) {
      try{
        await _client.sendTransaction(
            _credentials,
            Transaction.callContract(
                contract: _contract,
                function: _createUser,
                maxGas: 6721975,
                parameters: [
                  ime,
                  prezime,
                  mejl,
                  lozinka,
                  primarnaAdresa,
                  sekundarnaAdresa,
                  brojTelefona,
                  kljucevi
                ]));
      }
      catch(e) {
        return 0;
      }

      var idPost = new BigInt.from(id);
      var dan2 = new BigInt.from(dan);
      var mesec2 = new BigInt.from(mesec);
      var godina2 = new BigInt.from(godina);
      var sat2 = new BigInt.from(sat);
      var minut2 = new BigInt.from(minut);

      try{
        await _client.sendTransaction(
            _credentials,
            Transaction.callContract(
                maxGas: 6721975,
                contract: _contract,
                function: _createDate,
                parameters: [
                  idPost,
                  dan2,
                  mesec2,
                  godina2,
                  sat2,
                  minut2,
                  pictures
                ]));
      }
      catch(e) {
        return 0;
      }

      await getDate();
      await getUser();
      return 1;
    }
  }

  String getProfilePicture(int id){
    for(var user in dates){
      if(user.id == id)
        return user.pictures;
    }
  }

  Future<int> editPicture(String picture) async {
    var prefs = await SharedPreferences.getInstance();
    var id = new BigInt.from(prefs.getInt("id"));
    try {
      await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              maxGas: 6721975,
              function: _editPicture,
              parameters: [
                id,
                picture
              ]));
    } catch (err) {
      return 0;
    }

    await getUser();
    await getDate();
    return 1;
  }

  Future<int> editUser(
      String ime,
      String prezime,
      String mejl,
      String lozinka,
      String primarnaAdresa,
      String sekundarnaAdresa,
      String brojTelefona) async {
    isLoading = true;
    notifyListeners();
    var prefs = await SharedPreferences.getInstance();
    var id = new BigInt.from(prefs.getInt("id"));
    String _publicKey = prefs.getString("publicKey");
    String _privateKey2 = prefs.getString("privateKey");
    String kljucevi = _privateKey2+"|"+ _publicKey;
    try {
      await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              maxGas: 6721975,
              function: _editUser,
              parameters: [
                id,
                ime,
                prezime,
                mejl,
                lozinka,
                primarnaAdresa,
                sekundarnaAdresa,
                brojTelefona,
                kljucevi
              ]));
    } catch (err) {
      return 0;
    }

    getUser();
    return 1;
  }

  deleteUser(int id) async {
    _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            maxGas: 6721975,
            contract: _contract,
            function: _deleteUser,
            parameters: [BigInt.from(id)]));
    await getUser();
  }
}

class User {
  int id;
  String email;
  String password;
  String firstname;
  String lastname;
  String primaryAddress;
  String secondaryAddress;
  String phone;
  String keys;

  User(
      {this.id,
        this.email,
        this.password,
        this.firstname,
        this.lastname,
        this.primaryAddress,
        this.secondaryAddress,
        this.phone,
        this.keys});
}

class Date {
  int id;
  int day;
  int month;
  int year;
  int hour;
  int minut;
  String pictures;

  Date(
      {this.id,
        this.day,
        this.month,
        this.year,
        this.hour,
        this.minut,
        this.pictures});
}