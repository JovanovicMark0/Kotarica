import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_app/utility/ThemeManager.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';
// modeli
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/utility/IconStepperClass.dart';
import 'package:provider/provider.dart';
import 'LoginPage.dart';

import 'package:http/http.dart' as http;


String _rpcUrl;
String response;

class RegistrationPage extends StatefulWidget {
  static TextEditingController email = TextEditingController();
  static TextEditingController ime = TextEditingController();
  static TextEditingController prezime = TextEditingController();
  static TextEditingController lozinka = TextEditingController();
  static TextEditingController grad1 = TextEditingController();
  static TextEditingController ulicaBroj1 = TextEditingController();
  static TextEditingController postanskiBroj1 = TextEditingController();
  static TextEditingController grad2 = TextEditingController();
  static TextEditingController ulicaBroj2 = TextEditingController();
  static TextEditingController postanskiBroj2 = TextEditingController();
  static TextEditingController sekundarnaAdresa = TextEditingController();
  static TextEditingController brojTelefona = TextEditingController();
  static Widget imageButton;

  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }

  static Container getRegistrationButton() {
    return registrationButton;
  }
}

Container registrationButton;
bool pkIsFalse = false;

class _RegistrationPageState extends State<RegistrationPage> {
  var list;
  var prefs;
  bool slikaU = false;
  void initState() {
    initiateSetup();
    super.initState();

    imageButton();

    Future.delayed(Duration.zero, () {
      setState(() {
        loading = false;
        showDialog<int>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return alertPK();
            }).then((val) {
          if (val == 1) {
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        });
      });
    });
  }

  /*
   _image != null
        ? Image.file(
      _image,
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      fit: BoxFit.cover,
    )
        :
   */


  void imageButton(){
    RegistrationPage.imageButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xff59071a), // background
        onPrimary: Colors.white, // foreground
      ),
      onPressed: () => pickImage(false),
      child: slikaU == false
          ? Image.asset(
        'images/empty.png',
        fit: BoxFit.fitHeight,
      )
          : Image.network(
        "http://147.91.204.116:11128/ipfs/" + messageURL,
        fit: BoxFit.fitHeight,
      ),
    );
  }


  konekcija() async {
    list = Provider.of<UserModel>(context, listen: false);
    await list.initiateSetup();
  }

  //----------------------------------------------------------------------------------
  Future<void> initiateSetup() async {
    response = await rootBundle.loadString('assets/config.json');
    Map<String, dynamic> config = jsonDecode(response);
    _rpcUrl = "http://${config['ip']}:3000";
  }

  String slika = "";

  static final uploadEndPoint = 'http://147.91.204.116:11123/upload';
  Future<File> file;
  String status = '';
  String base64Image;
  String messageURL = "";
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  File _image;
  String message = '';
  String porukaProvera = "";
  //replace the url by your url
  // your rest api url 'http://your_ip_adress/project_path' ///adresa racunara
  bool loading = false;

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
      porukaProvera = "Molimo proverite još jednom tačnost unetih podataka.";
    });
    if (respons.statusCode == 200) {
      imageButton();
      setState(() {
        message = 'Uspešno dodata fotografija.';
        messageURL = slika;
        slikaU = true;
        slika = respons.body;
      });

      return;
    } else {
      setState(() {
        message = 'Fotografija nije uspešno dodata, molimo pokušajte ponovo.';
        messageURL = "";
        slikaU = false;
      });
    }
  }


// ----------------------------------------------------------------------------------
  TextEditingController pkController = new TextEditingController();
  TextEditingController publicKeyController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // final key = encrypt.Key.fromUtf8('jendvatricetpetsessedosadevdesje');
  // final iv = encrypt.IV.fromLength(16);
  AlertDialog alertViseInfo() {
    return AlertDialog(
      content: Container(
        child: RichText(
          text: new TextSpan(
            // Note: Styles for TextSpans must be explicitly defined.
            // Child text spans will inherit styles from parent
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              new TextSpan(text: 'Novčanik za kriptovalute', style: new TextStyle(fontWeight: FontWeight.bold)),
              new TextSpan(text: ' omogućava svojim korisnicima da čuvaju i preuzimaju svoja digitalna sredstva(Bitcoin, Ethereum,..)\n\n'),

              new TextSpan(text: 'Privatni ključ', style: new TextStyle(fontWeight: FontWeight.bold)),
              new TextSpan(text: ' Vam omogućava pristup sredstvima, kao i potpisivanje transakcija. Sastoji se od 64 karaktera.\n\n'),

              new TextSpan(text: 'Javni ključ', style: new TextStyle(fontWeight: FontWeight.bold)),
              new TextSpan(text: ' Vašeg novčanika omogućava prenos sredstava do Vas. Sastoji se od 40 karaktera.'),
            ],
          ),
        ),
      ),
    );
  }
  AlertDialog alertPK() {
    return AlertDialog(
      content: Container(
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: pkController,
                          maxLength: 64,
                          decoration: InputDecoration(
                              hintText: 'Privatni ključ'
                          ),
                        ),
                        TextField(
                          controller: publicKeyController,
                          maxLength: 40,
                          decoration: InputDecoration(
                              hintText: 'Javni ključ'
                          ),
                        ),
                        maybeIsWrong
                            ? Text(
                            "Došlo je do greške prilikom povezivanja Vašeg novčanika. Molimo Vas unesite opet. Mogući problem predstavlja da nemate dovoljno sredstava na Vašem računu.",
                            style: TextStyle(color: Colors.red))
                            : Container(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shadowColor: Colors.white,
                          ),
                          child: Text(
                            "Saznajte više >",
                            style: TextStyle(color: Themes.BACKGROUND_COLOR),
                          ),
                          onPressed: () async {
                            showDialog<int>(
                                context: context,
                                builder: (BuildContext context) {
                                  return alertViseInfo();
                                });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left:8),
                          child: OutlinedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                              foregroundColor: MaterialStateProperty.all(Themes.BACKGROUND_COLOR),
                            ),
                            child: Text(
                              "Nazad",
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Themes.BACKGROUND_COLOR, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          child: Text(
                            "Pošalji",
                          ),
                          onPressed: () async {
                            // final encrypter = encrypt.Encrypter(encrypt.AES(key));
                            // final encrypted = encrypter.encrypt(pkController.text, iv: iv);
                            // final decrypted = encrypter.decrypt(encrypted, iv: iv);
                            // print(encrypted);
                            // print(decrypted);
                            if (pkController.text.length == 64 && publicKeyController.text.length==40) {
                              prefs = await SharedPreferences.getInstance();
                              prefs.setString("privateKey", pkController.text);
                              prefs.setString("publicKey", publicKeyController.text);
                              //print(pkController.text);
                              Navigator.of(context).pop(1);
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final double maxContainerWidth = 600;
  var maybeIsWrong = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);


    ElevatedButton slikaDugmePrazno = ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xff59071a), // background
        onPrimary: Colors.white, // foreground
      ),
      onPressed: () => pickImage(false),
      child: Image.asset(
        'images/empty.png',
        fit: BoxFit.fitHeight,
      )
    );

    ElevatedButton slikaDugmePuno = ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xff59071a), // background
        onPrimary: Colors.white, // foreground
      ),
      onPressed: () => pickImage(false),
      child: Image.network(
        "http://147.91.204.116:11128/ipfs/" + slika,
        fit: BoxFit.fitHeight,
      ),
    );

    RegistrationPage.imageButton = slikaU ? slikaDugmePuno : slikaDugmePrazno;
    void resetTextFields() {
      RegistrationPage.ime.text = "";
      RegistrationPage.prezime.text = "";
      RegistrationPage.email.text = "";
      RegistrationPage.lozinka.text = "";
      RegistrationPage.grad1.text = "";
      RegistrationPage.grad2.text = "";
      RegistrationPage.postanskiBroj1.text = "";
      RegistrationPage.postanskiBroj2.text = "";
      RegistrationPage.ulicaBroj1.text = "";
      RegistrationPage.ulicaBroj2.text = "";
      RegistrationPage.sekundarnaAdresa.text = "";
      RegistrationPage.brojTelefona.text = "";
    }

    registrationButton = Container(
      width: 105,
      child: Material(
        color: Color(0xff59081b),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(3.0),
          child: MaterialButton(
            minWidth: GetSize.getMaxWidth(context),
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
            onPressed: () async {
              setState(() {
                loading = true;
              });

              String sekundarnaAdresa = RegistrationPage.grad1.text +
                  "|" +
                  RegistrationPage.ulicaBroj1.text +
                  "|" +
                  RegistrationPage.postanskiBroj1.text;
              String primarnaAdresa = RegistrationPage.grad2.text +
                  "|" +
                  RegistrationPage.ulicaBroj2.text +
                  "|" +
                  RegistrationPage.postanskiBroj2.text;
              if (slika == "") {
                slika = "QmTwCcmKj5DFX3z28NQ3azfRsh1Zu4JczUXz8iUC9AcLB1";
              }
              await konekcija();
              var res = await list.addUser(
                  RegistrationPage.ime.text,
                  RegistrationPage.prezime.text,
                  RegistrationPage.email.text,
                  RegistrationPage.lozinka.text,
                  primarnaAdresa,
                  sekundarnaAdresa,
                  RegistrationPage.brojTelefona.text,
                  list.users.length,
                  DateTime.now().day,
                  DateTime.now().month,
                  DateTime.now().year,
                  DateTime.now().hour,
                  DateTime.now().minute,
                  slika);
              if (res == 1) {
                maybeIsWrong = false;
                prefs.setString("email", RegistrationPage.email.text);
                prefs.setString("password", RegistrationPage.lozinka.text);
                resetTextFields();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              } else if (res == 0) {
                setState(() {
                  loading = false;
                });
                maybeIsWrong = true;
                showDialog<int>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return alertPK();
                    });
              }
            },
            child: Center(
              child: Text(
                'Registrujte se',
                textScaleFactor: 0.8,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Container container1 = Container(
      // margin: EdgeInsets.only(top: 0.5),
        width: GetSize.getMaxWidth(context) * 0.7,
        //height: GetSize.getMaxHeight(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), topLeft: Radius.circular(25)),
          color: Color(0xff5f968e),
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
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    message,
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      inherit: false,
                      color: Color(0xff59071a),
                    ),
                  ),
                  Text(
                    porukaProvera,
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(inherit: false, color: Color(0xff59071a)),
                  ),
                ],
              ), //END IMAGE UPLOAD\
              IconStepperDemo(),
            ],
          ),
        ));

    Container container2 = Container(
      // margin: EdgeInsets.only(top: 0.5),
        width: 500,
        //height: GetSize.getMaxHeight(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Color(0xff5f968e),
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
              Text(
                message,
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  inherit: false,
                  color: Color(0xff59071a),
                ),
              ),
              Text(
                porukaProvera,
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(inherit: false, color: Color(0xff59071a)),
              ), //END IMAGE UPLOAD\
              IconStepperDemo(),
              //registrationButton
            ],
          ),
        ));

    return Scaffold(
      body: loading
          ? Container(
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
          : SingleChildScrollView(
          child: Container(
            color: Themes.LIGHT_BACKGROUND_COLOR,
            width: GetSize.getMaxWidth(context),
            height: GetSize.getMaxHeight(context),
            child: FittedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  GetSize.getMaxWidth(context) < maxContainerWidth
                      ? container1
                      : container2,
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ) //home: MyHomePage(title: 'Flutter Demo Home Page')
      ),
    );
  }
}
/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utility/GetSize.dart';

class RegistrationPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  void initState() {
    super.initState();
  }

  final nameField = TextField(
    cursorColor: Colors.white,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 20.0),
      hintText: 'password',
    ),
  );

  final surnameField = TextField(
    style: TextStyle(color: Colors.red),
    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 20.0),
      hintText: 'password',
    ),
  );

  final numberField = TextField(
    cursorColor: Colors.white,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 20.0),
      hintText: 'password',
    ),
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
            color: Themes.LIGHT_BACKGROUND_COLOR,
            width: GetSize.getMaxWidth(context),
            height: GetSize.getMaxHeight(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                SizedBox(
                  height: GetSize.getMaxWidth(context)*0.3,
                  child: Image.asset('images/logo.png', fit: BoxFit.fitHeight),
                ),
                Container(
                  // margin: EdgeInsets.only(top: 0.5),
                    width: GetSize.getMaxWidth(context) * 0.8, // staviti da bude zavisno od telefona
                    height: GetSize.getMaxHeight(context) * 0.7, // isto
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xff5f968e)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(35),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: GetSize.getMaxHeight(context)*0.03,),
                          new Text("Imaš nalog? ",textScaleFactor: 1),
                          //new ShowHide(),
                          SizedBox(height: GetSize.getMaxHeight(context)*0.03,),
                          new Text(" Nemaš nalog? ", textScaleFactor: 1),
                          SizedBox(height: GetSize.getMaxHeight(context)*0.02,),
                          SizedBox(height: GetSize.getMaxHeight(context)*0.02,),
                        ],
                      ),
                    )
                ),
              ],
            ),
          )//home: MyHomePage(title: 'Flutter Demo Home Page')
      ),
    );
  }
}*/
