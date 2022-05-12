import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter_app/utility/GetSize.dart';

//import 'HomePage.dart';
//import 'ProfilePage.dart';
// modeli
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

class AddNewPostPage extends StatefulWidget {
  //QmTwCcmKj5DFX3z28NQ3azfRsh1Zu4JczUXz8iUC9AcLB1
  static const routeName = '/addNewPost';
  @override
  _AddNewPostPageState createState() => _AddNewPostPageState();
}

enum Price { fiksna, licitacija }
enum Payment { pouzecem, kriptovalute, sve }

String _rpcUrl;
String response;

class _AddNewPostPageState<V> extends State<AddNewPostPage> {
  var screenHeight;
  var screenWidth;

  //id slika dodati
  TextEditingController _controllerNaziv = TextEditingController();
  TextEditingController _controllerOpis = TextEditingController();
  TextEditingController _controllerCena = TextEditingController();
  String kategorija;
  String potkategorija;
  var tipOglasa = "Oglas";
  var nacinPlacanja;
  var categories = [];
  var subcategories = [];
  int idVlasnika;
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

  //Price _price = Price.fiksna;
  //Payment _payment = Payment.pouzecem;
  Price _price = null;
  Payment _payment = null;

//------------------------------------------ upload image
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
    slike.clear();
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
    //Material navBar = NavigationBar.NavigationBar(context);

    Row nazivProizvoda() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: GetSize.getMaxWidth(context) * 0.5,
            child: TextFormField(
              controller: _controllerNaziv,
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

    Row cena() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: GetSize.getMaxWidth(context) * 0.5,
            child: TextFormField(
              controller: _controllerCena,
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
                labelText: "Cena prozivoda",
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
              controller: _controllerOpis,
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

    return loading
        ? Container(
            width: screenWidth,
            height: screenHeight,
            color: Color(0xffD5F5E7),
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
              title: Text("Dodavanje oglasa"),
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
                          ]),
                          isActive: _currentStep >= 0,
                          state: _currentStep >= 0
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                        Step(
                          title: new Text("Dodatne informacije"),
                          content: Column(children: <Widget>[
                            cena(),
                            SizedBox(
                              height: 5.0,
                            ),
                            opisProizvoda(),
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
                                child: Text("Izabrane slike"),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GalleryPage(a: slike)));
                                },
                              ),
                            ),
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
                            /*Row(
                              children: <Widget>[

                              ],
                            )*/
                          ]),
                          isActive: _currentStep >= 0,
                          state: _currentStep >= 1
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                        Step(
                          title: new Text("Plaćanje"),
                          content: Column(children: <Widget>[
                            ListTile(
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
                                        primary:
                                            Color(0xff59071a), // background
                                        onPrimary: Colors
                                            .white, // foreground// foreground
                                      ),
                                      onPressed: () async {
                                        if (!checkError()) {
                                          setState(() => {loading = true});
                                          if (slike.length == 0) {
                                            slike.add(
                                                "QmTwCcmKj5DFX3z28NQ3azfRsh1Zu4JczUXz8iUC9AcLB1");
                                          }
                                          await list.addPoster(
                                              _controllerNaziv.text,
                                              _controllerOpis.text,
                                              kategorija,
                                              potkategorija,
                                              _controllerCena.text,
                                              tipOglasa.toString(),
                                              nacinPlacanja.toString(),
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
                            children: <Widget>[
                              addButton,
                            ],
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
            /*floatingActionButton: FloatingActionButton( // ako hocemo da se prebaci u vertikalni stepper ali onda ima overflow
        child: Icon(Icons.list),
        onPressed: switchStepsType,
      ),*/
            /*floatingActionButton: FloatingActionButton(
              child: Text(
                "Dodaj",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Color(0xff59071a),
              onPressed: () {
                if (slike.length == 0) {
                  slike.add("QmTwCcmKj5DFX3z28NQ3azfRsh1Zu4JczUXz8iUC9AcLB1");
                }
                list.addPoster(
                    _controllerNaziv.text,
                    _controllerOpis.text,
                    kategorija,
                    potkategorija,
                    _controllerCena.text,
                    tipOglasa.toString(),
                    nacinPlacanja.toString(),
                    list.posters.length,
                    DateTime.now().day,
                    DateTime.now().month,
                    DateTime.now().year,
                    DateTime.now().hour,
                    DateTime.now().minute,
                    slike,
                    id);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NavigationBar()));
              },
            ),*/
          );

    /*return ChangeNotifierProvider(
        create: (context) => PostModel(),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Dodavanje oglasa"),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Color(0xff59071a),
          ),
          body: list.isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                 child: Stack(
                    children: <Widget>[
                      Container(
                        height: GetSize.getMaxHeight(context) * 1.3,
                        decoration: BoxDecoration(
                          color: Color(0xffd5f5e7),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                showImage(),
                                OutlineButton(
                                  onPressed: startUpload,
                                  child: Text('Upload Image'),
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
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              child: Row(
                                children: [
                                 // Text("Naziv proizvoda: "),
                                  nazivProizvoda(),
                                ],
                              ),
                            ),
                            Container(
                              child: Center(
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  color: Color(0xff59071a),
                                  child: Text("Kategorija",
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () =>
                                      _showMultiSelectCategory(context),
                                ),
                              ),
                            ),
                            Container(
                              child: Center(
                                child: RaisedButton(
                                  color: Color(0xff59071a),
                                  child: Text("Podkategorija",
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () =>
                                      _showMultiSelectSubcategory(context),
                                ),
                              ),
                            ),
                            Container(
                              //height: GetSize.getMaxHeight(context),
                              child: Row(
                                children: [
                                  opisProizvoda(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  cena(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Nacin placanja:",
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                ListTile(
                                  title: const Text(
                                    'Pouzecem',
                                    textScaleFactor: 0.8,
                                  ),
                                  leading: Radio<Payment>(
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
                                    value: Payment.sve,
                                    groupValue: _payment,
                                    onChanged: (Payment value) {
                                      setState(() {
                                        nacinPlacanja = value;
                                        _payment = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            addButton,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          //bottomNavigationBar: navBar,
        ));*/
  }
  /*switchStepsType() {// ako hocemo da se prebaci u vertikalni stepper ali onda ima overflow
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }*/

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  bool checkError() {
    bool hasError = false;
    String str = "";
    if (_currentStep == 0) {
      if (_controllerNaziv.text == "") {
        hasError = true;
        str += "Polje za naziv proizvoda ne sme biti prazno.\n";
      }
      if (!_controllerNaziv.text.contains(RegExp(r"[A-Za-z0-9-,. ]+"))) {
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
      if (_controllerCena.text == "") {
        hasError = true;
        str += "Polje za cenu proizvoda ne sme biti prazno.\n";
      }
      if (!_controllerCena.text.contains(RegExp(r'[0-9]+'))) {
        hasError = true;
        str += "Polje za cenu proizvoda mora sadržati samo cifre.\n";
      }
      if (_controllerOpis.text == "") {
        hasError = true;
        str += "Polje za opis proizvoda ne sme biti prazno.\n";
      }
    }
    if (_currentStep == 2) {
      if (nacinPlacanja == null) {
        hasError = true;
        str += "Obavezno je odabrati način plaćanja.\n";
      }
    }
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
