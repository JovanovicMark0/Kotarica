import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/utility/GetSize.dart';

//import 'HomePage.dart';
//import 'ProfilePage.dart';
// modeli
import 'package:flutter_app/models/PostModel.dart';
import 'package:flutter_app/utility/ThemeManager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../utility/GetSize.dart';
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
  //id slika dodati
  TextEditingController _controllerNaziv = TextEditingController();
  TextEditingController _controllerOpis = TextEditingController();
  TextEditingController _controllerCena = TextEditingController();
  var kategorija;
  var potkategorija;
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
  //static final String uploadEndPoint = _rpcUrl + "/upload";
  static final uploadEndPoint = 'http://147.91.204.116:11123/upload';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Greška pri otpremanju slike';

  File _image;
  String message = '';
  List<File> f = List();

  //replace the url by your url
  // your rest api url 'http://your_ip_adress/project_path' ///adresa racunara
  // bool loading1 = false;
  var uploadFilesCount;
  Future<void> pickImage() async {
    bool multiple = true;
    var uri = Uri.parse(uploadEndPoint);
    if (!multiple) //1 file
    {
      FilePickerResult result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        PlatformFile file = result.files.first;

        await upload(uri, file, multiple);
      }
      setState(() {
        loading = false;
      });
    } else //Multiple files
    {
      FilePickerResult result = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.image);
      if (result != null) {
        uploadFilesCount = result.files.length;
        if (uploadFilesCount > 10) {
          setState(() {
            message = "";
            status =
                "Prekoračen limit izabranih slika. Najviše može biti izabrano 10 slika.";
          });
        } else {
          bool izabraoVeliku = false;
          for (var i in result.files) {
            int sizeInBytes = i.bytes.lengthInBytes;
            double sizeInMb = sizeInBytes / (1024 * 1024);
            if (sizeInMb > 10) {
              setState(() {
                message = "";
                status =
                    "Zasebna slika može biti veličine do 10MB. Molimo izaberite slike koje su manje od 10MB veličine.";
              });
              izabraoVeliku = true;
              break;
            }
          }
          if (!izabraoVeliku) {
            for (var i in result.files) await upload(uri, i, multiple);
            setState(() {
              status = "";
            });
          }
        }
      }
    }
    setState(() {
      loading = false;
    });
  }

  String slika = "";
  upload(Uri uri, PlatformFile file, bool multiple) async {
    setState(() {
      loading = true;
    });
    if (file == null) return;

    Map<String, String> headers = {
      "Accept": "multipart/form-data",
    };
    var length = uploadFilesCount;
    http.MultipartRequest request = new http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(
          // replace file with your field name exampe: image
          http.MultipartFile.fromBytes('avatar', file.bytes,
              filename: file.name));

    var respons = await http.Response.fromStream(await request.send());

    if (respons.statusCode == 200) {
      message =
          'Uspešno dodate slike. \nNapomena: Ponovnim klikom na "Izaberite slike" prvobitni izbor slika će biti poništen.';


      slike.add(respons.body);
      return;
    } else {
      message = 'Slike nisu uspešno dodate, molimo pokušajte ponovo.';

    }
  }

//------------------------------------------
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  @override
  Widget build(BuildContext context) {
    var screenHeight = GetSize.getMaxHeight(context);
    var screenWidth = GetSize.getMaxWidth(context);
    var list = Provider.of<PostModel>(context);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

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

    bool checkError() {
      bool hasError = false;
      String str = "";
      /*
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
        str += "Polje za cenu proizvoda ne sme biti prazno.\n";
      }
      if (int.parse(pocetnacena.text) > int.parse(krajnjacena.text)) {
        hasError = true;
        str += "Početna cena licitacije mora da bude manja od krajnje.\n";
      }
    */

      if (nacinPlacanja == null) {
        hasError = true;
        str += "Obavezno je odabrati način plaćanja.\n";
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
              title: Text(
                "Dodavanje oglasa",
                style: TextStyle(
                  height: 2,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              //automaticallyImplyLeading: false,
              centerTitle: true,
              elevation: 0,
              backgroundColor: Color(0xff59071a),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: GetSize.getMaxWidth(context) * 0.8,
                    margin: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Osnovne informcije",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        nazivProizvoda(),
                        kategorije(),
                        potkategorije(),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    width: GetSize.getMaxWidth(context) * 0.8,
                    margin: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dodatne informacije",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            cena(),
                            Container(
                                child: Text(
                              "  Cenu uneti u dinarima.",
                              style: TextStyle(
                                color: Color(0xff59071a),
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0,
                              ),
                            )),
                            SizedBox(
                              height: 10.0,
                            ),
                            opisProizvoda(),
                            SizedBox(
                              height: 10.0,
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
                                onPressed: pickImage,
                              ),
                            ),
                            Container(
                              child: message != ""
                                  ? Text(
                                      message,
                                      style: TextStyle(
                                        color: Color(0xff59071a),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.0,
                                      ),
                                    )
                                  : status == ""
                                      ? Text(
                                          "Klikom na dugme 'Izaberite slike' odaberite do 10 fotografija, pri tome vodite računa da veličina zasebne fotografije ne prelazi 10MB.",
                                          style: TextStyle(
                                            color: Colors.green[400],
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0,
                                          ),
                                        )
                                      : Text(
                                          status,
                                          style: TextStyle(
                                            color: Color(0xff59071a),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0,
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
                                child: Text("Izabrane slike"),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GalleryPage(a: slike)));
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                      margin: EdgeInsets.only(top: 30),
                      width: GetSize.getMaxWidth(context) * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Način plaćanja",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                            ),
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                  title: const Text(
                                    'Pouzećem',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
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
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
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
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
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
                              ]),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 50, right: 50),
                    child: ElevatedButton(
                      child: Text("Dodaj oglas"),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff59071a), // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () async {
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
                                prefs.getString("secondaryAddress"));
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      },
                    ),
                  ),
                ],
              ),
            ),
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

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
