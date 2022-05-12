import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_app/models/PostModel.dart';
import 'package:flutter_app/utility/ThemeManager.dart';
import 'package:flutter_app/widgets/NavigationBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../utility/GetSize.dart';
import '../widgets/NavigationBar.dart';
import 'GalleryPage.dart';
import 'HomePage.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';

import 'package:http/http.dart' as http;

class AddNewAuctionPage extends StatefulWidget {
  static const routeName = '/addNewPost';
  @override
  _AddNewPostAuctionPageState createState() => _AddNewPostAuctionPageState();
}

enum Price { fiksna, licitacija }
enum Payment { pouzecem, kriptovalute, sve }

String _rpcUrl;
String response;

class _AddNewPostAuctionPageState<V> extends State<AddNewAuctionPage> {
  var screenHeight;
  var screenWidth;

  //id slika dodati
  TextEditingController naziv = TextEditingController();
  TextEditingController opis = TextEditingController();
  TextEditingController pocetnacena = TextEditingController();
  TextEditingController krajnjacena = TextEditingController();
  TextEditingController licitacija = TextEditingController();
  var kategorija;
  var potkategorija;
  var tipOglasa = "Oglas";
  var nacinPlacanja;
  var categories = [];
  var subcategories = [];
  var loading = true;
  var categoriesJSON;
  List<String> slike = [];
  //var cenaFiksno;
  //var cenaLicitacija;
  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    await konekcija();
    loading = false;
  }

  konekcija() async {
    var temp = await rootBundle.loadString('assets/categories.json');
    categoriesJSON = jsonDecode(temp);
    categories.clear();
    for (int i = 1; i <= categoriesJSON.length; i++) {
      categories.add(categoriesJSON["$i"]["Category"]);
    }
  }

  fillSubcategories() {
    for (int i = 1; i <= categoriesJSON.length; i++) {
      if (categoriesJSON["$i"]["Category"] == kategorija) {
        var _lista = categoriesJSON["$i"]["subcategories"];
        for (int j = 0; j < _lista.length; j++) {
          subcategories.add(_lista[j]);
        }
        break;
      }
    }
  }

  @override
  void initState() {
    initiateSetup();
    Future.delayed(Duration.zero, () {
      this.getSharedPrefs().then((value) {
        setState(() {
          id = prefs.getInt("id");
        });
      });
    });
  }

  Future<void> initiateSetup() async {
    response = await rootBundle.loadString('assets/config.json');
    Map<String, dynamic> config = jsonDecode(response);
    _rpcUrl = "http://${config['ip']}:3000";
  }

  Price _price = null;
  Payment _payment = null;

  static final uploadEndPoint = 'http://147.91.204.116:11123/upload';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Greška pri otpremanju slike';

  File _image;
  String message = '';
  List<File> f = List();

  List<Asset> imagesAsset = List<Asset>();
  //replace the url by your url
  // your rest api url 'http://your_ip_adress/project_path' ///adresa racunara
  // bool loading1 = false;
  Future<void> pickImages() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        //enableCamera: true,
        selectedAssets: imagesAsset,
      );
    } on Exception catch (e) {
      print(e);
    }
    //asset to image
    for (int i = 0; i < resultList.length; i++) {
      var path =
          await FlutterAbsolutePath.getAbsolutePath(resultList[i].identifier);
      f.add(File(path));
    }

    for (int i = 0; i < f.length; i++) {
      upload(f[i]);
    }

    setState(() {
      imagesAsset = resultList;
    });
  }
/*
  Future<File> AssetToFile(Asset asset) async {
    final byteData = await asset.getByteData();
    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final image = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
    return image;
  }*/

  upload(File file) async {
    if (file == null) return;
    setState(() {
      loading = true;
    });
    Map<String, String> headers = {
      "Accept": "multipart/form-data",
    };
    var uri = Uri.parse(uploadEndPoint);
    var length = await file.length();
    http.MultipartRequest request = new http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(
        // replace file with your field name exampe: image
        http.MultipartFile('avatar', file.openRead(), length,
            filename: 'test.png'),
      );
    var respons = await http.Response.fromStream(await request.send());
    slike.add(respons.body);
    setState(() {
      loading = false;
    });
    if (respons.statusCode == 200) {
      setState(() {
        message = 'Uspešno dodate slike.';
      });
      return;
    } else
      setState(() {
        message = 'Slike nisu uspešno dodate, molimo pokušajte ponovo.';
      });
  }

//------------------------------------------

  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  @override
  Widget build(BuildContext context) {
    screenHeight = GetSize.getMaxHeight(context);
    screenWidth = GetSize.getMaxWidth(context);

    var list = Provider.of<PostModel>(context);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    //bool categoryIsExpanded = false;
    //Material navBar = NavigationBar.navigationBar(context);

    Row nazivProizvoda() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: GetSize.getMaxWidth(context) * 0.5,
            child: TextFormField(
              controller: naziv,
              style: TextStyle(
                fontSize: GetSize.getMaxHeight(context) * 0.02,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10),
                  borderSide: new BorderSide(),
                ),
                labelText: "Naziv proizvoda",
                labelStyle: TextStyle(
                  color: Color(0xff59081b),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Row pocetnaCena() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: GetSize.getMaxWidth(context) * 0.5,
            child: TextFormField(
              controller: pocetnacena,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: GetSize.getMaxHeight(context) * 0.02,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10),
                  borderSide: new BorderSide(),
                ),
                labelText: "Početna cena",
                labelStyle: TextStyle(
                  color: Color(0xff59081b),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Row krajnjaCena() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: GetSize.getMaxWidth(context) * 0.5,
            child: TextFormField(
              controller: krajnjacena,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: GetSize.getMaxHeight(context) * 0.02,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10),
                  borderSide: new BorderSide(),
                ),
                labelText: "Krajnja cena",
                labelStyle: TextStyle(
                  color: Color(0xff59081b),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Row trajanjeLicitacije() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: GetSize.getMaxWidth(context) * 0.5,
            child: TextFormField(
              controller: licitacija,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: GetSize.getMaxHeight(context) * 0.02,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10),
                  borderSide: new BorderSide(),
                ),
                labelText: "Trajanje licitacije",
                labelStyle: TextStyle(
                  color: Color(0xff59081b),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Row opisProizvoda() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: GetSize.getMaxWidth(context) * 0.7,
            child: TextFormField(
              maxLines: 8,
              controller: opis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10),
                  borderSide: new BorderSide(),
                ),
                labelText: "Opis proizvoda",
                labelStyle: TextStyle(
                  color: Color(0xff59081b),
                ),
              ),
            ),
          ),
        ],
      );
    }

    void refreshData() {
      PostModel;
    }

    onGoBack(dynamic value) {
      refreshData();
      setState(() {});
    }

    void navigateHomePage() {
      Route route = MaterialPageRoute(builder: (context) => NavigationBar());
      Navigator.pushReplacement(context, route).then(onGoBack);
    }

    bool kategorijaJeIzabrana = false;
    bool potkategorijaJeIzabrana = false;
    Column kategorije() {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(4.0),
            child: DropdownButton<String>(
                hint: Text("Kategorija"),
                value: kategorija,
                items: [
                  for (int i = 0; i < categories.length; i++)
                    DropdownMenuItem<String>(
                        value: categories[i],
                        child: Center(
                          child: Text(categories[i]),
                        )),
                ],
                onChanged: (_value) => {
                      setState(() {
                        potkategorija = null;
                        subcategories.clear();
                        kategorijaJeIzabrana = true;
                        kategorija = _value;
                        fillSubcategories();
                      })
                    }),
          ),
        ],
      );
    }

    Column potkategorije() {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(4.0),
            child: DropdownButton<String>(
                hint: Text("Potkategorija"),
                value: potkategorija,
                items: [
                  for (int i = 0; i < subcategories.length; i++)
                    DropdownMenuItem<String>(
                        value: subcategories[i], child: Text(subcategories[i])),
                ],
                onChanged: (_value) => {
                      setState(() {
                        potkategorijaJeIzabrana = true;
                        potkategorija = _value;
                      })
                    }),
          ),
        ],
      );
    }

    /*final addButton = Material(
      color: Color(0xff59081b),
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        minWidth: GetSize.getMaxWidth(context),
        padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
        onPressed: () {
          /*list.addPoster(naziv.text, opis.text, kategorija, potkategorija,
              tipOglasa.toString(), nacinPlacanja.toString());
          navigateHomePage;*/
          //Navigator.push(
          //context,
          //MaterialPageRoute(builder: (context) => NavigationBar()));
          // (context as Element).reassemble();
        },
        child: Center(
          child: Text(
            'Dodaj Lictiaciju',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );*/

    return loading
        ? Container(
            width: screenWidth,
            height: screenHeight,
            color: Themes.LIGHT_BACKGROUND_COLOR,
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
                      style:
                          TextStyle(inherit: false, color: Color(0xff59071a)),
                    )),
                CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Color(0xff59071a)),
                ),
              ],
            )))
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("Dodavanje licitacije"),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Color(0xff59071a),
            ),
            body: Container(
              child: Column(
                children: [
                  Expanded(
                    child: Stepper(
                      controlsBuilder: (BuildContext context,
                          {VoidCallback onStepContinue,
                          VoidCallback onStepCancel}) {
                        return Row(children: <Widget>[
                          Container(
                            width: 50,
                          )
                        ]);
                      },
                      type: stepperType,
                      physics: ScrollPhysics(),
                      currentStep: _currentStep,
                      onStepTapped: (step) => tapped(step),
                      onStepContinue: continued,
                      onStepCancel: cancel,
                      steps: <Step>[
                        Step(
                          title: new Text("Osnovne informacije"),
                          content: Column(children: <Widget>[
                            nazivProizvoda(),
                            kategorije(),
                            potkategorije(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 50),
                                  child: ElevatedButton(
                                    child: Icon(Icons.double_arrow_outlined),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xff59071a), // background
                                      onPrimary: Colors.white, // foreground
                                    ),
                                    onPressed: continued,
                                  ),
                                )
                              ],
                            )
                            /*Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 50),
                                  child: ElevatedButton(
                                    child: Text("Sledeći korak"),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xff59071a), // background
                                      onPrimary: Colors.white, // foreground
                                    ),
                                    onPressed: continued,
                                  ),
                                )
                              ],
                            )*/
                          ]),
                          isActive: _currentStep >= 0,
                          state: _currentStep >= 0
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                        Step(
                          title: new Text("Dodatne informacije"),
                          content: Column(children: <Widget>[
                            opisProizvoda(),
                            SizedBox(
                              height: 5.0,
                            ),
                            pocetnaCena(),
                            SizedBox(
                              height: 5.0,
                            ),
                            krajnjaCena(),
                            SizedBox(
                              height: 5.0,
                            ),
                            trajanjeLicitacije(),
                            SizedBox(
                              height: 5.0,
                            ),
                            /*showImage(),
                        OutlineButton(
                          onPressed: startUpload,
                          child: Text('Upload Image'),
                        ),*/
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: Color(0xff59071a),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 25),
                              padding: EdgeInsets.only(right: 50),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xff59071a), // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                child: Text("Izaberite slike"),
                                onPressed: pickImages,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 25),
                              padding: EdgeInsets.only(right: 50),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xff59071a), // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                child: Text("Prikaži slike"),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GalleryPage(a: slike)));
                                },
                              ),
                            ),
                            Text(
                              status,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                                fontSize: 20.0,
                              ),
                            ),
                            /*Row(children: <Widget>[
                              Container(
                                child: ElevatedButton(
                                  child: Text("Prethodni korak"),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white, // background
                                    onPrimary: Color(0xff59071a), // foreground
                                  ),
                                  onPressed: cancel,
                                ),
                                margin: EdgeInsets.only(top: 50, right: 50),
                              ),
                            ]),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 50),
                                  child: ElevatedButton(
                                    child: Text("Sledeći korak"),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xff59071a), // background
                                      onPrimary: Colors.white, // foreground
                                    ),
                                    onPressed: continued,
                                  ),
                                ),
                              ],
                            )*/
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: ElevatedButton(
                                    child: Transform.rotate(
                                      child: Icon(Icons.double_arrow_outlined),
                                      angle: 180 * 3.1415926535 / 180,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white, // background
                                      onPrimary:
                                      Color(0xff59071a), // foreground
                                    ),
                                    onPressed: cancel,
                                  ),
                                  margin: EdgeInsets.only(top: 50, right: 25),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 50),
                                  child: ElevatedButton(
                                    child: Icon(Icons.double_arrow_outlined),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xff59071a), // background
                                      onPrimary: Colors.white, // foreground
                                    ),
                                    onPressed: continued,
                                  ),
                                )
                              ],
                            ),
                          ]),
                          isActive: _currentStep >= 0,
                          state: _currentStep >= 1
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                        Step(
                          title: new Text("Plaćanje"),
                          content: Column(children: <Widget>[
                            /*ListTile(
                              title: const Text(
                                'Pouzećem',
                                textScaleFactor: 0.8,
                              ),
                              leading: Radio<Payment>(
                                activeColor: Colors.black,
                                value: Payment.pouzecem,
                                groupValue: _payment,
                                onChanged: (Payment value) {
                                  setState(() {
                                    nacinPlacanja = value;
                                    _payment = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text(
                                'Kriptovalutama',
                                textScaleFactor: 0.8,
                              ),
                              leading: Radio<Payment>(
                                activeColor: Colors.black,
                                value: Payment.kriptovalute,
                                groupValue: _payment,
                                onChanged: (Payment value) {
                                  setState(() {
                                    nacinPlacanja = value;
                                    _payment = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text(
                                'Sve',
                                textScaleFactor: 0.8,
                              ),
                              leading: Radio<Payment>(
                                activeColor: Colors.black,
                                value: Payment.sve,
                                groupValue: _payment,
                                onChanged: (Payment value) {
                                  setState(() {
                                    nacinPlacanja = value;
                                    _payment = value;
                                  });
                                },
                              ),
                            ),*/
                            Container(
                                //margin: EdgeInsets.only(top: 50),
                                padding: EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
                                decoration: BoxDecoration(
                                    color: Themes.BACKGROUND_COLOR,
                                    border: Border.all(
                                      color: Themes.BACKGROUND_COLOR,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20),)),
                                child: Text("Jedina opcija isplate za licitaciju je plaćanje pouzećem. Klikom na 'Dodaj licitaciju' saglasni ste sa opcijom da korisnici mogu da plaćaju pouzećem.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    )
                                )

                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: ElevatedButton(
                                      child: Transform.rotate(
                                        child:
                                        Icon(Icons.double_arrow_outlined),
                                        angle: 180 * 3.1415926535 / 180,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white, // background
                                        onPrimary:
                                        Color(0xff59071a), // foreground
                                      ),
                                      onPressed: cancel,
                                    ),
                                    margin: EdgeInsets.only(top: 50, right: 10),
                                  ),
                                  Container(
                                    child: ElevatedButton(
                                      child: Transform.rotate(
                                        child:
                                          Icon(Icons.add_to_photos_outlined),
                                        angle: 180 * 3.1415926535 / 180,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xff59071a), // background
                                        onPrimary: Colors.white, // foreground
                                      ),
                                      onPressed: () async {
                                        if (!checkError()) {
                                          setState(() => {loading = true});
                                          if (slike.length == 0) {
                                            slike.add(
                                                "QmTwCcmKj5DFX3z28NQ3azfRsh1Zu4JczUXz8iUC9AcLB1");
                                          }
                                          await list.addPoster(
                                              naziv.text,
                                              opis.text,
                                              kategorija,
                                              potkategorija,
                                              pocetnacena.text +
                                                  "|" +
                                                  krajnjacena.text,
                                              licitacija.text,
                                              "Payment.pouzecem",
                                              list.posters.length,
                                              DateTime.now().day,
                                              DateTime.now().month,
                                              DateTime.now().year,
                                              DateTime.now().hour,
                                              DateTime.now().minute,
                                              slike,
                                              id,
                                              prefs.getString("firstname") +
                                                  "|" +
                                                  prefs.getString("lastname") +
                                                  "|" +
                                                  prefs.getString(
                                                      "secondaryAddress"));
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NavigationBar()));
                                        }
                                      },
                                    ),
                                    margin: EdgeInsets.only(top: 50, right: 50),
                                  ),
                            ]),
                          ]),
                          isActive: _currentStep >= 0,
                          state: _currentStep >= 2
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                        /*Step(
                    title: new Text("Završi dodavanje oglasa"),
                    content: Column(
                      children: <Widget>[],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 3
                        ? StepState.complete
                        : StepState.disabled,
                  )*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  bool checkError() {
    bool hasError = false;
    String str = "";
    if (_currentStep == 0) {
      if (naziv.text == "") {
        hasError = true;
        str += "Polje za naziv proizvoda ne sme biti prazno.\n";
      }
      if (!naziv.text.contains(RegExp(r"[A-Za-z0-9-,. ]+"))) {
        hasError = true;
        str +=
            "Polje za naziv proizvoda može sadržati samo slova, cifre, zapetu, tačku i crticu.\n";
      }
      if (kategorija == null) {
        hasError = true;
        str += "Polje za kategoriju proizvoda ne sme biti prazno.\n";
      }
      if (potkategorija == null) {
        hasError = true;
        str += "Polje za potkategoriju proizvoda ne sme biti prazno.\n";
      }
    }
    if (_currentStep == 1) {
      if (opis.text == "") {
        hasError = true;
        str += "Polje za cenu proizvoda ne sme biti prazno.\n";
      }
      if (pocetnacena.text == "") {
        hasError = true;
        str += "Polje za cenu proizvoda ne sme biti prazno.\n";
      }
      if (!pocetnacena.text.contains(RegExp(r'[0-9]+'))) {
        hasError = true;
        str += "Polje za početnu cenu proizvoda mora sadržati samo cifre.\n";
      }
      if (krajnjacena.text == "") {
        hasError = true;
        str += "Polje za krajnju cenu proizvoda ne sme biti prazno.\n";
      }
      if (!krajnjacena.text.contains(RegExp(r'[0-9]+'))) {
        hasError = true;
        str += "Polje za krajnju cenu proizvoda mora sadržati samo cifre.\n";
      }
      if (licitacija.text == "") {
        hasError = true;
        str += "Polje za trajanje licitacije ne sme biti prazno.\n";
      }
      if (int.parse(pocetnacena.text) > int.parse(krajnjacena.text)) {
        hasError = true;
        str += "Početna cena licitacije mora da bude manja od krajnje.\n";
      }
      int trajanjeLicitacijeTren = int.parse(licitacija.text);
      if (trajanjeLicitacijeTren < 3 || trajanjeLicitacijeTren > 10) {
        hasError = true;
        str += "Licitacija mora trajati između 3 i 10 dana.\n";
      }
    }/*
    if (_currentStep == 2) {
      if (nacinPlacanja == null) {
        hasError = true;
        str += "Obavezno je odabrati način plaćanja.\n";
      }
    }*/
    if (hasError) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Neispravan unos"),
          content: Text(
            str,
            style: TextStyle(color: Colors.redAccent, height: 1.5),
          ),
          actions: [
            TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Themes.BACKGROUND_COLOR,
                ),
                onPressed: () => Navigator.pop(context),
                child: Text("U redu"))
          ],
        ),
      );
    }
    return hasError;
  }

  continued() {
    if (!checkError())
      _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
