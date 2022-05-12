import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/utility/SignalRHelper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_app/utility/FilterSortControllers.dart';

import '../pages/HomePage.dart';
import 'PurchaseModel.dart';
import 'UserModel.dart';

class PostModel extends ChangeNotifier {
  // int postersCount = 0;

  List<Poster> posters = [];
  List<Date> dates = [];
  List<Picture> pictures = [];
  bool isLoading;
  String _rpcUrl; // HHTTP://192.168.0.11:7545
  String _wsUrl; // ws://192.168.1.110:7545/

  String _privateKey;

  Web3Client _client;

  String _abiCode;
  EthereumAddress _contractAddress;
  EthereumAddress _ownAddress;
  DeployedContract _contract;
  Credentials _credentials;

  ContractFunction
  _posterCount; // varijable iz ugovora Contracts/UsersContracts.sol
  ContractFunction _posters;
  ContractFunction _createPoster;
  ContractFunction _getPictures;
  ContractFunction _getFirstPicture;
  ContractEvent _PosterCreated;
  ContractFunction
  _dateCount; // varijable iz ugovora Contracts/UsersContracts.sol
  ContractFunction _dates;
  ContractFunction _createDate;
  ContractEvent _DateCreated;

  // BID
  ContractFunction _addNewBid;
  ContractFunction _getCurrentBid;
  ContractFunction _deletePoster;

  ContractFunction
  _pictureCount; // varijable iz ugovora Contracts/UsersContracts.sol
  ContractFunction _pictures;
  ContractFunction _addPicture;
  int typeOfSort;
  // SORT
  // 0 == prvo najnovije
  // 1 == prvo najstarije
  // 2 == prvo najjeftinije
  // 3 == prvo najskuplje
  // 4 == A-Z
  // 5 == Z-A

  PostModel() {
    // constructor
    isLoading = true;
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
    if (prefsPk != -1) _privateKey = prefsPk;
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
    await rootBundle.loadString("src/abis/PosterContract.json");

    var jsonAbi = jsonDecode(abiStringFile);

    // SERVER
    // final response = await http.get(Uri.http('147.91.204.116:11120', 'PosterContract.json'));
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
    if (prefsPk != -1) {
      _credentials = await _client.credentialsFromPrivateKey(_privateKey);
      _ownAddress = await _credentials.extractAddress();
    }
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "PosterContract"), _contractAddress);
    _posterCount = _contract.function("postersCount");
    _posters = _contract.function("posters");
    _createPoster = _contract.function("createPoster");
    _PosterCreated = _contract.event("PosterCreated");
    _dateCount = _contract.function("dateCount");
    _dates = _contract.function("dates");
    _createDate = _contract.function("createDate");
    _DateCreated = _contract.event("DateCreated");
    _pictureCount = _contract.function("pictureCount");
    _pictures = _contract.function("mainpictures");
    _getPictures = _contract.function("getPictures");
    _addPicture = _contract.function("addPicture");
    _addNewBid = _contract.function("addNewBid");
    _getCurrentBid = _contract.function("getCurrentBid");
    _deletePoster = _contract.function("deletePoster");

    await getPoster();
    await getDate();
    await getImages();
  }

  getPoster() async {
    BigInt totalPostersBigInt = (await _client
        .call(contract: _contract, function: _posterCount, params: []))[0];

    int totalPosters = totalPostersBigInt.toInt();
    posters.clear();
    FilterSort.mostExpensiveItem = -1;
    FilterSort.cheapestItem = 10000000000000000;
    for (var i = 0; i < totalPosters; i++) {
      var temp = await _client.call(
          contract: _contract, function: _posters, params: [BigInt.from(i)]);
      int deletedFlag = temp[11].toInt();
      posters.add(Poster(
          id: (temp[0]).toInt(),
          name: temp[1],
          description: temp[2],
          category: temp[3],
          subcategory: temp[4],
          price: temp[5],
          typeofPoster: temp[6],
          wayOfPayment: temp[7],
          additionalInfo: temp[8],
          currentBid: temp[9],
          currentBidder: temp[10],
          deleted: deletedFlag));
      var cena = temp[5].split("|")[0];
      if (int.parse(cena) > FilterSort.mostExpensiveItem) {
        FilterSort.mostExpensiveItem = int.parse(cena);
      }
      if (int.parse(cena) < FilterSort.cheapestItem) {
        FilterSort.cheapestItem = int.parse(cena);
      }
    }
    if (FilterSort.mostExpensiveItem == -1) {
      FilterSort.mostExpensiveItem = 0;
      FilterSort.cheapestItem = 0;
    }

    // SORT
    // 0 == prvo najnovije
    // 1 == prvo najstarije
    // 2 == prvo najjeftinije
    // 3 == prvo najskuplje
    // 4 == A-Z
    // 5 == Z-A
    // typeOfSort = FilterSort.sort;
    switch (FilterSort.sort) {
      case 0:
        {}
        break;

      case 1:
        {
          posters = sortNewest(posters);
        }
        break;

      case 2:
        {
          posters = sortCheapest(posters);
        }
        break;

      case 3:
        {
          posters = sortExpensiveFirst(posters);
        }
        break;

      case 4:
        {
          posters = sortA_Z(posters);
        }
        break;

      case 5:
        {
          posters = sortZ_A(posters);
        }
        break;
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
          idOwner: (temp[6]).toInt()));
    }
  }

  getImages() async {
    BigInt totalImagesBigInt = (await _client
        .call(contract: _contract, function: _pictureCount, params: []))[0];

    int totalImages = totalImagesBigInt.toInt();
    pictures.clear();
    List<String> temp2;
    for (var i = 0; i < totalImages; i++) {
      var temp = await _client.call(
          contract: _contract,
          function: _getPictures,
          params: [BigInt.from(i)]);

      List<String> temp2 = [];

      for (int j = 0; j < temp[0].length; j++) {
        temp2.add(temp[0][j].toString());
      }

      pictures.add(Picture(id: i, pics: temp2));
    }

    isLoading = false;
    notifyListeners();
  }

  Poster getByID(int idPost) {
    for (var i = 0; i < posters.length; i++) {
      if (posters[i].id == i) return posters[i];
    }
    return null;
  }

  addPoster(
      String nazivProizvoda,
      String opis,
      String kategorija,
      String potkategorija,
      String cena,
      String tipOglasa,
      String nacinPlacanja,
      int id,
      int dan,
      int mesec,
      int godina,
      int sat,
      int minut,
      List<String> pictures,
      int idVlasnika,
      String dodatneInfo) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _createPoster,
            maxGas: 6721975,
            parameters: [
              nazivProizvoda,
              opis,
              kategorija,
              potkategorija,
              cena,
              tipOglasa,
              nacinPlacanja,
              dodatneInfo
            ]));
    var idPost = new BigInt.from(id);
    var dan2 = new BigInt.from(dan);
    var mesec2 = new BigInt.from(mesec);
    var godina2 = new BigInt.from(godina);
    var sat2 = new BigInt.from(sat);
    var minut2 = new BigInt.from(minut);
    var idVlasnika2 = new BigInt.from(idVlasnika);
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
              idVlasnika2
            ]));

    for (var i = 0; i < pictures.length; i++) {
      await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              maxGas: 6721975,
              contract: _contract,
              function: _addPicture,
              parameters: [idPost, pictures[i]]));
    }

    await getPoster();
    await getDate();
    await getImages();
  }

  int noPosts() {
    int k = 0;
    for (var i = 0; i < posters.length; i++) {
      if (posters[i].deleted == 1) continue;
      k++;
    }
    return k;
  }

  int k = 0;
  //flag==1 sve postere
  //flag==0 postere za wishlistu

  int noFilteredPosts() {
    int k = 0;
    for (var i = 0; i < posters.length; i++) {
      if (posters[i].deleted == 1) continue;
      if (posters[i]
          .name
          .toLowerCase()
          .contains(FilterSort.pretraga.text.toLowerCase()) ||
          FilterSort.pretraga.text == "") {
        // Pretraga po naslov
        if (FilterSort.grad == "Sve" ||
            FilterSort.grad == posters[i].additionalInfo.split("|")[2]) {
          if (FilterSort.nacinPlacanja == 0 ||
              (FilterSort.nacinPlacanja == 1 &&
                  posters[i].wayOfPayment == "Payment.pouzecem") ||
              (FilterSort.nacinPlacanja == 2 &&
                  posters[i].wayOfPayment == "Payment.kriptovalute")) {
            if (FilterSort.kategorija == "Kategorija" ||
                posters[i].category == FilterSort.kategorija) {
              if (FilterSort.potkategorija == "Potkategorija" ||
                  posters[i].subcategory == FilterSort.potkategorija) {
                if (FilterSort.minPrice <=
                    int.parse(posters[i].price.split("|")[0]) &&
                    FilterSort.maxPrice >=
                        int.parse(posters[i].price.split("|")[0])) {
                  k++;
                }
              }
            }
          }
        }
      }
    }
    return k;
  }

  static int lastIndex = 0;
  Future<List> loadFilteredPosts(
      startIndex, screenWidth, screenHeight, context) async {
    if (startIndex == 0) lastIndex = startIndex;
    List lista = [];
    int k = 0;
    lista.clear();
    for (var i = lastIndex;
    k != FilterSort.brojObjavaPoStrani && i < posters.length;
    i++) {
      if (posters[i].deleted == 1) continue;
      if (posters[i]
          .name
          .toLowerCase()
          .contains(FilterSort.pretraga.text.toLowerCase()) ||
          FilterSort.pretraga.text == "") {
        // Pretraga po naslov
        if (FilterSort.grad == "Sve" ||
            FilterSort.grad == posters[i].additionalInfo.split("|")[2]) {
          if (FilterSort.tipOglasa == 0 ||
              (FilterSort.tipOglasa == 1 &&
                  posters[i].typeofPoster == "Oglas") ||
              (FilterSort.tipOglasa == 2 &&
                  posters[i].typeofPoster != "Oglas")) {
            if (FilterSort.nacinPlacanja == 0 ||
                (FilterSort.nacinPlacanja == 1 &&
                    posters[i].wayOfPayment == "Payment.pouzecem") ||
                (FilterSort.nacinPlacanja == 2 &&
                    posters[i].wayOfPayment == "Payment.kriptovalute")) {
              if (FilterSort.kategorija == "Kategorija" ||
                  posters[i].category == FilterSort.kategorija) {
                if (FilterSort.potkategorija == "Potkategorija" ||
                    posters[i].subcategory == FilterSort.potkategorija) {
                  if (FilterSort.minPrice <=
                      int.parse(posters[i].price.split("|")[0]) &&
                      FilterSort.maxPrice >=
                          int.parse(posters[i].price.split("|")[0])) {
                    k++;
                    lista.add(new Oglas(
                        idOglasa: posters[i].id,
                        naslov: posters[i].name,
                        poslednjaPonuda: posters[i].currentBid,
                        kupiOdmah: posters[i].price,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        tip: posters[i].typeofPoster,
                        context: context,
                        dodatneInfo: posters[i].additionalInfo));
                    lastIndex = i + 1;
                  }
                }
              }
            }
          }
        }
      }
    }
    return lista;
  }

  Future<List> loadPosts(
      startIndex, flag, lista2, screenWidth, screenHeight, context) async {
    List lista = [];
    k = 0;
    int end;
    if ((startIndex + FilterSort.brojObjavaPoStrani) > posters.length) {
      end = posters.length;
    } else
      end = startIndex + FilterSort.brojObjavaPoStrani;

    if (flag == 1) {
      //SVI POSTOVI
      for (var i = startIndex;
      k != FilterSort.brojObjavaPoStrani && i < posters.length;
      i++) {
        if (posters[i].deleted == 1) continue;
        if (posters[i].typeofPoster != "Oglas") {
          // Aukcije
          var krajnjiDatum = DateTime(dates[i].year, dates[i].month,
              dates[i].day, dates[i].hour, dates[i].minut)
              .add(new Duration(days: int.parse(posters[i].typeofPoster)));
          if (krajnjiDatum.isBefore(DateTime.now())) {
            //isteklo vreme, poslati informacije kupcu i prodavcu
            if (posters[i].currentBidder != "-1") {
              var purchaseModel =
              Provider.of<PurchaseModel>(context, listen: false);
              var userModel = Provider.of<UserModel>(context, listen: false);
              var kupac = await userModel
                  .getUserById(int.parse(posters[i].currentBidder));
              var prodavac = await userModel.getUserById(dates[i].idOwner);
              await purchaseModel.initiateSetup();
              String kupacPK = await userModel.getPKS(kupac.id);
              String prodavacPK = await userModel.getPKS(prodavac.id);
              await purchaseModel.buy(
                  int.parse(posters[i].currentBidder),
                  posters[i].id,
                  DateTime.now(),
                  kupacPK.split("|")[1],
                  prodavacPK.split("|")[1],
                  -1);
              var signalR = Provider.of<SignalR>(context, listen: false);

              await signalR.initSignalR();
              await signalR.startConnection();
              await signalR.sendMessage(
                  kupac.email, prodavac.email, "#@#${posters[i].id}@#@");
              var adresaLista = kupac.primaryAddress.split("|");
              var adresa =
                  adresaLista[1] + " " + adresaLista[0] + " " + adresaLista[2];
              await signalR.sendMessage(kupac.email, prodavac.email,
                  "Ime i prezime: ${kupac.firstname} ${kupac.lastname} \nAdresa: $adresa\nBroj telefona: ${kupac.phone}");
            }
            deletePoster(posters[i].id); // brise ga
            continue; // da ne prikazuje
          }
        }
        k++;

        lista.add(new Oglas(
            idOglasa: posters[i].id,
            naslov: posters[i].name,
            poslednjaPonuda: posters[i].currentBid,
            kupiOdmah: posters[i].price,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            tip: posters[i].typeofPoster,
            context: context,
            dodatneInfo: posters[i].additionalInfo));
      }
    } else {
      for (var i = 0; i < posters.length; i++) {
        if (posters[i].deleted == 1) continue;
        if (lista2.contains(posters[i].id)) {
          k++;
          lista.add(new Oglas(
              idOglasa: posters[i].id,
              naslov: posters[i].name,
              poslednjaPonuda: posters[i].currentBid,
              kupiOdmah: posters[i].price,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              tip: posters[i].typeofPoster,
              context: context,
              dodatneInfo: posters[i].additionalInfo));
        }
      }
    }
    return lista;
  }

  Future<List> loadPosts3(lista2, screenWidth, screenHeight, context) async {
    List lista = [];
    for (var i = 0; i < lista2.length; i++) {
      lista.add(new Oglas(
          idOglasa: lista2[i].id,
          naslov: lista2[i].name,
          poslednjaPonuda: lista2[i].currentBid,
          kupiOdmah: lista2[i].price,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          tip: lista2[i].typeofPoster,
          context: context,
          dodatneInfo: lista2[i].additionalInfo));
    }
    return lista;
  }

  List<dynamic> getPostList(int id) {
    List lista = [];
    //print("u funckicji id je: $id");
    for (var i = 0; i < dates.length; i++) {
      //print("u funckicji id posta je: ${posters[i].id}");
      if (dates[i].idOwner == id) {
        lista.add(Poster(
            id: posters[i].id,
            name: posters[i].name,
            description: posters[i].description,
            category: posters[i].category,
            subcategory: posters[i].subcategory,
            price: posters[i].price,
            currentBid: posters[i].currentBid,
            typeofPoster: posters[i].typeofPoster,
            wayOfPayment: posters[i].wayOfPayment,
            additionalInfo: posters[i].additionalInfo,
            currentBidder: posters[i].currentBidder));
      }
    }
    return lista;
  }

  String getNameById(int id) {
    for (var i = 0; i < posters.length; i++) {
      if (posters[i].id == id) {
        return posters[i].name;
      }
    }
    return null;
  }

  List<dynamic> loadPosts2(lista) {
    List lista = [];
    for (var i = 0; i < posters.length; i++) {
      lista.add(Poster(
          id: posters[i].id,
          name: posters[i].name,
          description: posters[i].description,
          category: posters[i].category,
          subcategory: posters[i].subcategory,
          price: posters[i].price,
          currentBid: posters[i].currentBid,
          typeofPoster: posters[i].typeofPoster,
          wayOfPayment: posters[i].wayOfPayment,
          additionalInfo: posters[i].additionalInfo,
          currentBidder: posters[i].currentBidder));
    }
    return lista;
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
          idOwner: dates[i].idOwner));
    }
    return lista;
  }

  int getPostOwner(int idPost) {
    int idVlasnika;
    List<dynamic> lista = loadDates([]);
    for (var i = 0; i < lista.length; i++) {
      if (lista[i].id == idPost) {
        idVlasnika = lista[i].idOwner;
      }
    }
    return idVlasnika;
  }

  String getThumbnail(id) {
    for (int i = 0; i < pictures.length; i++) {
      if (pictures[i].id == id) {
        return pictures[i].pics[0];
      }
    }
    return null;
  }

  // List<Poster> sortValue()
  // {
  //   List<Date> lista = loadPosts2([]])([]);
  // }

  List<String> getPictures(id) {
    for (int i = 0; i < pictures.length; i++) {
      if (pictures[i].id == id) {
        return pictures[i].pics;
      }
    }
    return null;
  }

  List<Poster> sortNewest(List<Poster> lista) {
    if (lista.length != 0) lista = lista.reversed.toList();
    return lista;
  }

  List<Poster> sortCheapest(List<Poster> lista) {
    for (int i = 0; i < lista.length - 1; i++) {
      for (int j = i + 1; j < lista.length; j++) {
        if (int.parse(lista[i].price.split("|")[0]) >
            int.parse(lista[j].price.split("|")[0])) {
          Poster temp = lista[i];
          lista[i] = lista[j];
          lista[j] = temp;
        }
      }
    }
    return lista;
  }

  List<Poster> sortExpensiveFirst(List<Poster> lista) {
    for (int i = 0; i < lista.length - 1; i++) {
      for (int j = i + 1; j < lista.length; j++) {
        if (int.parse(lista[i].price.split("|")[0]) <
            int.parse(lista[j].price.split("|")[0])) {
          Poster temp = lista[i];
          lista[i] = lista[j];
          lista[j] = temp;
        }
      }
    }
    return lista;
  }

  List<Poster> sortA_Z(List<Poster> lista) {
    for (int i = 0; i < lista.length - 1; i++) {
      for (int j = i + 1; j < lista.length; j++) {
        if (lista[i].name.compareTo(lista[j].name) == 1) {
          Poster temp = lista[i];
          lista[i] = lista[j];
          lista[j] = temp;
        }
      }
    }

    return lista;
  }

  List<Poster> sortZ_A(List<Poster> lista) {
    for (int i = 0; i < lista.length - 1; i++) {
      for (int j = i + 1; j < lista.length; j++) {
        if (lista[i].name.compareTo(lista[j].name) == -1) {
          Poster temp = lista[i];
          lista[i] = lista[j];
          lista[j] = temp;
        }
      }
    }

    return lista;
  }

  Future<bool> addNewBid(int idPost, String newBid, String newBidder) async {
    var oldBid = posters[idPost].currentBid;
    String staraPonuda = "";
    for (int i = 0; i < posters[idPost].currentBid.length; i++) {
      if ([
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
      ].contains(posters[idPost].currentBid[i]))
        staraPonuda += posters[idPost].currentBid[i];
    }
    var id = new BigInt.from(idPost);
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            maxGas: 6721975,
            contract: _contract,
            function: _addNewBid,
            parameters: [id, newBid, newBidder]));

    var newBidFromDB = (await _client.call(
        contract: _contract,
        function: _getCurrentBid,
        params: [BigInt.from(idPost)]))[0];
    String novaPonuda = "";
    for (int i = 0; i < newBidFromDB.length; i++) {
      if ([
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
      ].contains(newBidFromDB[i])) novaPonuda += newBidFromDB[i];
    }
    if (int.parse(staraPonuda) >= int.parse(novaPonuda)) return false;
    await getPoster();
    return true;
  }

  deletePoster(int id) async {
    _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            maxGas: 6721975,
            contract: _contract,
            function: _deletePoster,
            parameters: [BigInt.from(id)]));
    await getPoster();
  }
}

class Poster {
  int id;
  String name;
  String description;
  String category;
  String subcategory;
  String typeofPoster;
  String wayOfPayment;
  String price;
  String additionalInfo;
  String currentBid;
  String currentBidder;
  int deleted;

  Poster(
      {this.id,
        this.name,
        this.description,
        this.category,
        this.subcategory,
        this.typeofPoster,
        this.wayOfPayment,
        this.price,
        this.additionalInfo,
        this.currentBid,
        this.currentBidder,
        this.deleted});
}

class Date {
  int idOwner;
  int id;
  int day;
  int month;
  int year;
  int hour;
  int minut;
  Date(
      {this.id,
        this.day,
        this.month,
        this.year,
        this.hour,
        this.minut,
        this.idOwner});
}

class Picture {
  int id;
  List<String> pics;
  Picture({this.id, this.pics});
}
