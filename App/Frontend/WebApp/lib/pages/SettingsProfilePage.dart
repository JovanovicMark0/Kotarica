import 'dart:convert';
import 'dart:io';
import 'package:custom_switch/custom_switch.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/utility/GetSize.dart';

// modeli
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/utility/ThemeManager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/GetSize.dart';
import '../utility/GetSize.dart';
import 'LoginPage.dart';

import 'package:http/http.dart' as http;

class SettingsProfilenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsProfilenPageState();
  }
}

String _rpcUrl;
String response;
var prefs;

class _SettingsProfilenPageState extends State<SettingsProfilenPage> {
  var list;
  TextEditingController email = TextEditingController();
  TextEditingController ime = TextEditingController();
  TextEditingController prezime = TextEditingController();
  TextEditingController lozinka = TextEditingController();
  TextEditingController primarnaAdresa = TextEditingController();
  TextEditingController sekundarnaAdresa = TextEditingController();
  TextEditingController brojTelefona = TextEditingController();
  bool loading = true;
  SharedPreferences prefs;
  int idPrefs = -1;
  String emailPrefs = "";
  String imePrefs = "";
  String sifraPrefs = "";
  String prezimePrefs = "";
  String telefonPrefs = "";
  String adresaPrefs = "";
  String sekundarnaAdresaPrefs = "";
  Map<String, dynamic> config;
  String uploadEndPoint;

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    var response = await rootBundle.loadString('assets/config.json');
    config = jsonDecode(response);
    uploadEndPoint = 'http://147.91.204.116:11123/upload';
    list = Provider.of<UserModel>(context , listen: false);
    await list.initiateSetup();
    slika = list.getProfilePicture(prefs.getInt("id"));
  }

  initState() {
    super.initState();
    initiateSetup();
    Future.delayed(Duration.zero, () {
      this.getSharedPrefs().then((result) {
        setState(() {
          idPrefs = prefs.getInt("id");
          emailPrefs = prefs.getString("email");
          imePrefs = prefs.getString("firstname");
          sifraPrefs = prefs.getString("password");
          prezimePrefs = prefs.getString("lastname");
          telefonPrefs = prefs.getString("phone");
          adresaPrefs = prefs.getString("primaryAddress");
          sekundarnaAdresaPrefs = prefs.getString("secondaryAddress");
          loading = false;
        });
      });
    });
  }

  //----------------------------------------------------------------------------------
  Future<void> initiateSetup() async {
    response = await rootBundle.loadString('assets/config.json');
    Map<String, dynamic> config = jsonDecode(response);
    _rpcUrl = "http://${config['ip']}:3000";
  }

  String slika = "";

  Future<File> file;
  String status = '';
  String base64Image;
  bool slikaU = false;
  String messageURL = "";
  File tmpFile;
  String errMessage = 'Greška pri izboru slike';

  String message = '';
  String porukaProvera = "";
  //replace the url by your url
  // your rest api url 'http://your_ip_adress/project_path' ///adresa racunara

  var uploadFilesCount;
  pickImage(bool multiple) async {
    var uri = Uri.parse(uploadEndPoint);
    if (!multiple) //1 file
    {
      FilePickerResult result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        PlatformFile file = result.files.first;
        setState(() {});
        await upload(uri, file, multiple);
      }
    } else //Multiple files
    {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'tiff'],
      );
      if (result != null) {
        uploadFilesCount = result.files.length;
        for (var i in result.files) {
          await upload(uri, i, multiple);
        }
      }
    }
  }

  upload(Uri uri, PlatformFile file, bool multiple) async {
    setState(() {
      loading = true;
    });
    if (file == null) return;

    if (!['jpg', 'jpeg', 'png', 'tiff'].contains(file.extension)) return;
    setState(() {
      loading = true;
    });
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
    setState(() {
      loading = false;
      porukaProvera = "";
    });
    if (respons.statusCode == 200) {
      setState(() {
        message = 'Uspešno dodata fotografija.';
        messageURL = slika;
        slika = respons.body;
        slikaU = true;
      });
    } else {
      setState(() {
        message = 'Fotografija nije uspešno dodata, molimo pokušajte ponovo.';
        messageURL = "";
        slikaU = false;
      });
    }
    setState(() {
      loading = false;
    });
  }

// ----------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    final imeField = TextField(
      controller: ime,
      textAlign: TextAlign.center,
      style: TextStyle(decorationColor: Colors.white, color: Colors.white),
      decoration: InputDecoration(
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
        hintText: imePrefs,
      ),
    );

    final prezimeField = TextField(
      controller: prezime,
      textAlign: TextAlign.center,
      style: TextStyle(decorationColor: Colors.white, color: Colors.white),
      decoration: InputDecoration(
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
        hintText: prezimePrefs,
      ),
    );

    /*final emailField = TextField(
      controller: email,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(decorationColor: Colors.white, color: Colors.white),
      decoration: InputDecoration(
        focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
        hintText: current.email,
      ),
    );*/

    final sifraField = TextField(
      controller: lozinka,
      textAlign: TextAlign.center,
      style: TextStyle(decorationColor: Colors.white, color: Colors.white),
      obscureText: true,
      decoration: InputDecoration(
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
        hintText: "Unesite novu lozinku",
      ),
    );

    final dostavaField = TextField(
      controller: primarnaAdresa,
      textAlign: TextAlign.center, // uraditi regex
      style: TextStyle(decorationColor: Colors.white, color: Colors.white),
      decoration: InputDecoration(
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
        hintText: adresaPrefs,
      ),
    );

    final preuzimanjeField = TextField(
      controller: sekundarnaAdresa,
      textAlign: TextAlign.center,
      style: TextStyle(decorationColor: Colors.white, color: Colors.white),
      decoration: InputDecoration(
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
        hintText: sekundarnaAdresaPrefs,
      ),
    );

    final kontaktTelefonField = TextField(
      controller: brojTelefona,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.phone,
      style: TextStyle(decorationColor: Colors.white, color: Colors.white),
      decoration: InputDecoration(
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
        hintText: telefonPrefs,
      ),
    );

    final deleteButton = Material(
      color: Themes.BACKGROUND_COLOR,
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        minWidth: GetSize.getMaxWidth(context),
        padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
        onPressed: () async {
          await list.deleteUser(idPrefs);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Center(
          child: Text(
            'Obriši nalog',
            textScaleFactor: 0.8,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    final saveButton = Material(
      color: Themes.BACKGROUND_COLOR,
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        minWidth: GetSize.getMaxWidth(context),
        padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
        onPressed: () async {
          setState(() => loading = true);
          email.text = emailPrefs;
          if (ime.text == "") ime.text = imePrefs;
          if (prezime.text == "") prezime.text = prezimePrefs;
          if (lozinka.text == "") lozinka.text = sifraPrefs;
          if (primarnaAdresa.text == "") primarnaAdresa.text = adresaPrefs;
          if (sekundarnaAdresa.text == "")
            sekundarnaAdresa.text = sekundarnaAdresaPrefs;
          if (brojTelefona.text == "") brojTelefona.text = telefonPrefs;
          var rez = await list.editUser(
              ime.text,
              prezime.text,
              email.text,
              lozinka.text,
              primarnaAdresa.text,
              sekundarnaAdresa.text,
              brojTelefona.text);
          if(slika != null && slika != "")
            var rez2 = await list.editPicture(slika);

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Center(
          child: Text(
            'Sačuvaj promene',
            textScaleFactor: 0.8,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Podešavanje"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff59071a),
      ),
      body: loading
          ? Container(
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
          : SingleChildScrollView(
              child: Container(
              color: Themes.LIGHT_BACKGROUND_COLOR,
              width: GetSize.getMaxWidth(context),
              height: GetSize.getMaxHeight(context)*1.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300, //GetSize.getMaxWidth(context) * 0.3,
                    child:
                        Image.asset('images/logo.png', fit: BoxFit.fitHeight),
                  ),
                  Container(
                      // margin: EdgeInsets.only(top: 0.5),
                      width: GetSize.getMaxWidth(context) * 0.8 < 600
                          ? GetSize.getMaxWidth(context) * 0.8
                          : 600,
                      height: 1100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Themes.DARK_BACKGROUND_COLOR,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 7,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(35),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Center(
                                  child: Column(children: [
                                    CustomSwitch(
                                      activeColor: Colors.green,
                                      value: false,
                                      onChanged: (value) {
                                        setState(() {
                                          Themes.switchTheme();
                                        });
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        "Noćni režim",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                  ]),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: CircleAvatar(
                                          backgroundImage: slika == "QmTwCcmKj5DFX3z28NQ3azfRsh1Zu4JczUXz8iUC9AcLB1" ? AssetImage(
                                            'images/empty.png',
                                          ) : NetworkImage(
                                            "http://147.91.204.116:11128/ipfs/$slika",
                                          ),
                                          radius:
                                              GetSize.getMaxHeight(context) *
                                                  0.1,
                                        ),
                                      ),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          child: slikaU
                                              ? Text(
                                                  "Slika uspešno učitana.",
                                                  style: TextStyle(
                                                    color: Color(0xff59071a),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16.0,
                                                  ),
                                                )
                                              : Text(
                                                  "Izaberite sliku za profil.",
                                                  style: TextStyle(
                                                    color: Color(0xff59071a),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16.0,
                                                  )))
                                    ]),
                                SizedBox(
                                  height: 20.0,
                                ),
                                ElevatedButton(
                                  onPressed: () => pickImage(false),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.black54,
                                    padding: EdgeInsets.fromLTRB(
                                        GetSize.getMaxWidth(context) * 0.015,
                                        GetSize.getMaxWidth(context) * 0.01,
                                        GetSize.getMaxWidth(context) * 0.015,
                                        GetSize.getMaxWidth(context) * 0.01),
                                  ),
                                  child: Text('Izaberite sliku'),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                /*Text(
                                  status,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.0,
                                  ),
                                ),*/
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                            imeField,
                            Text("Ime",
                                textScaleFactor: 1.2,
                                style: TextStyle(color: Colors.white)),
                            prezimeField,
                            Text("Prezime",
                                textScaleFactor: 1.2,
                                style: TextStyle(color: Colors.white)),
                            /* emailField,
                          Text("E-mail",
                              textScaleFactor: 1.2,
                              style: TextStyle(color: Colors.white)),*/
                            sifraField,
                            Text("Lozinka",
                                textScaleFactor: 1.2,
                                style: TextStyle(color: Colors.white)),
                            preuzimanjeField,
                            Text("Primarna adresa",
                                textScaleFactor: 1.2,
                                style: TextStyle(color: Colors.white)),
                            dostavaField,
                            Text("Sekundarna adresa",
                                textScaleFactor: 1.2,
                                style: TextStyle(color: Colors.white)),
                            kontaktTelefonField,
                            Text("Mobilni kontakt telefon",
                                textScaleFactor: 1.2,
                                style: TextStyle(color: Colors.white)),
                            SizedBox(
                              height: GetSize.getMaxHeight(context) * 0.04,
                            ),
                            saveButton,
                            SizedBox(
                              height: GetSize.getMaxHeight(context) * 0.04,
                            ),
                            deleteButton,
                          ],
                        ),
                      )),
                ],
              ),
            ) //home: MyHomePage(title: 'Flutter Demo Home Page')
              ),
    );
  }
}
