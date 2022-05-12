import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/utility/GetSize.dart';

// modeli
import 'package:flutter_app/models/UserModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'WebLoginPage.dart';

import 'package:http/http.dart' as http;

class WebRegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebRegistrationPageState();
  }
}

class _WebRegistrationPageState extends State<WebRegistrationPage> {
  TextEditingController email = TextEditingController();
  TextEditingController ime = TextEditingController();
  TextEditingController prezime = TextEditingController();
  TextEditingController lozinka = TextEditingController();
  TextEditingController primarnaAdresa = TextEditingController();
  TextEditingController sekundarnaAdresa = TextEditingController();
  TextEditingController brojTelefona = TextEditingController();
  void initState() {
    super.initState();
  }

  //----------------------------------------------------------------------------------
  static final String uploadEndPoint =
      'http://localhost/image_test/upload_image/';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      tmpFile = image;
    });
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  void upload(String fileName) {
    base64Image = base64Encode(tmpFile.readAsBytesSync());
    http.post(uploadEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    }).then((result) {
      print(result.statusCode);
      print(result.body);
      setStatus(result.statusCode == 200
          ? result.body
          : Text(
              errMessage,
              style: TextStyle(color: Colors.white),
            ));
    }).catchError((error) {
      setStatus(error.toString());
    });
  }

  void startUpload() {
    _getImage();
    setStatus('Uploading Image...');
    //print(tmpFile.path); Dobija dobru putanju do slike
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName);
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        print(snapshot.connectionState == ConnectionState.done);
        print(snapshot.data.toString());
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }
// ----------------------------------------------------------------------------------

  final double maxContainerWidth = 600;

  @override
  Widget build(BuildContext context) {
    var list = Provider.of<UserModel>(context);
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
        //hintText: 'ime',
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
        //hintText: 'prezime',
      ),
    );

    final emailField = TextField(
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
        //hintText: 'imejl adresa',
      ),
    );

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
        //hintText: 'lozinka',
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
        //hintText: 'adresa ',
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
        //hintText: 'email',
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
        //hintText: 'kontakt telefon',
      ),
    );

    final registrationButton = Material(
      color: Color(0xff59081b),
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        minWidth: GetSize.getMaxWidth(context),
        padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
        onPressed: () {
          list.addUser(ime.text, prezime.text, email.text, lozinka.text,
              primarnaAdresa.text, sekundarnaAdresa.text, brojTelefona.text);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => WebLoginPage()));
        },
        child: Center(
          child: Text(
            'Registruj se',
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

    Container container1 = Container(
        // margin: EdgeInsets.only(top: 0.5),
        width: GetSize.getMaxWidth(context) * 0.8,
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
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  /* SizedBox(
                    height: 5.0,
                  ),*/
                  showImage(),
                  /*SizedBox(
                    height: 5.0,
                  ),*/
                  OutlineButton(
                    onPressed: startUpload,
                    child: Text('Upload Image'),
                  ),
                  /*SizedBox(
                    height: 5.0,
                  ),*/
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
              imeField,
              Text("Ime",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
              prezimeField,
              Text("Prezime",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
              emailField,
              Text("E-mail",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
              sifraField,
              Text("Lozinka",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
              dostavaField,
              Text("Primarna adresa",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
              preuzimanjeField,
              Text("Sekundarna adresa",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
              Text("*Primer ispravno popunjene adrese:",
                  textScaleFactor: 0.8, style: TextStyle(color: Colors.white)),
              Text("Dr Zorana Đinđića 45-34000-Kragujevac",
                  textScaleFactor: 0.8, style: TextStyle(color: Colors.white)),
              kontaktTelefonField,
              Text("Mobilni kontakt telefon",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
              SizedBox(
                height: GetSize.getMaxHeight(context) * 0.04,
              ),
              registrationButton
            ],
          ),
        ));

    Container container2 = Container(
        // margin: EdgeInsets.only(top: 0.5),
        width: maxContainerWidth,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  showImage(),
                  SizedBox(
                    height: 20.0,
                  ),
                  OutlineButton(
                    onPressed: startUpload,
                    child: Text('Upload Image'),
                  ),
                  SizedBox(
                    height: 20.0,
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
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
              imeField,
              Text("Ime",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
              prezimeField,
              Text("Prezime",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
              emailField,
              Text("E-mail",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
              sifraField,
              Text("Lozinka",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
              dostavaField,
              Text("Primarna adresa",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
              preuzimanjeField,
              Text("Sekundarna adresa",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
              Text("*Primer ispravno popunjene adrese:",
                  textScaleFactor: 0.8, style: TextStyle(color: Colors.white)),
              Text("Dr Zorana Đinđića 45-34000-Kragujevac",
                  textScaleFactor: 0.8, style: TextStyle(color: Colors.white)),
              kontaktTelefonField,
              Text("Mobilni kontakt telefon",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
              SizedBox(
                height: GetSize.getMaxHeight(context) * 0.04,
              ),
              registrationButton
            ],
          ),
        ));

    return Scaffold(
      body: list.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
              color: Color(0xffd5f5e7),
              width: GetSize.getMaxWidth(context),
              height: GetSize.getMaxHeight(context) * 1.3,
              child: FittedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        height: 2 * GetSize.getMaxHeight(context) / 8,
                        child: Image.asset(
                          'images/logo.png',
                          fit: BoxFit.fitHeight,
                        )),
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
            color: Color(0xffd5f5e7),
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
