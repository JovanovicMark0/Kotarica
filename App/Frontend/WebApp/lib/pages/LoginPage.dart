import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/RegistrationPage.dart';
import 'package:flutter_app/pages/HomePage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/UserModel.dart';
import '../utility/GetSize.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final double maxContainerWidth = 600;
  var list;
  var loading = true;
  SharedPreferences prefs;
  int idPrefs;
  String emailPrefs = "";
  String sifraPrefs = "";
  final myControllerEmail = TextEditingController();
  final myControllerPass = TextEditingController();
  bool _obscureText = true;

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  konekcija() async {
    await getSharedPrefs();
  }

  Future<String> checkUser(email, pass) async {
    return await list.checkUser(email, pass);
  }

  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      this.konekcija().then((result) async {
        var pk = prefs.getString("privateKey") ?? -1;
        idPrefs = prefs.getInt("id") ?? -1;
        emailPrefs = prefs.getString("email") ?? "None---";
        sifraPrefs = prefs.getString("password") ?? "None";
        if (pk != -1 && emailPrefs != "None---") {
          list = Provider.of<UserModel>(context, listen: false);
          await list.initiateSetup();
          String res;
          res = await checkUser(emailPrefs, sifraPrefs);
          if (res == "true")
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomePage()));
          else {
            setState(() {
              loading = false;
            });
          }
        }
        else {
          setState(() {
            loading = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    @override
    void dispose() {
      myControllerEmail.dispose();
      myControllerPass.dispose();
      //super.dipsose();
    }

    final emailField = TextField(
      controller: myControllerEmail,
      textAlign: TextAlign.center,
      style: TextStyle(decorationColor: Colors.white, color: Colors.white),
      decoration: InputDecoration(
          focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
          hintText: 'e-mail',
          hintStyle: TextStyle(color: Colors.white)),
    );

    final passField = TextField(
        controller: myControllerPass,
        obscureText: _obscureText,
        textAlign: TextAlign.center,
        style: TextStyle(decorationColor: Colors.white, color: Colors.white),
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
            hintText: 'password',
            hintStyle: TextStyle(color: Colors.white)));

    final loginButton = Material(
      color: Color(0xff59081b),
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        minWidth: GetSize.getMaxWidth(context),
        padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
        onPressed: () async {
          setState(() {
            loading = true;
          });
          list = Provider.of<UserModel>(context, listen: false);
          await list.initiateSetup();
          String res;
          await checkUser(myControllerEmail.text, myControllerPass.text)
              .then((result) {
            setState(() {
              if (result is String)
                res = result.toString(); //use toString to convert as String

            });
          });
          if (res == "true") {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomePage()));
          } else if (res == "WrongEmail") {
            setState(() {
              loading = false;
            });
            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      content: Container(
                          height: GetSize.getMaxWidth(context) > 575 ? 40 : 60,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      "Korisnik sa ovim imejlom ne postoji. "),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      "Dodirnite bilo gde van belog prozora kako biste se vratili nazad."),
                                ),
                              ])));
                });
          } else if (res == "WrongPass") {
            setState(() {
              loading = false;
            });
            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("Lozinka je neispravno uneta."),
                  );
                });
          }
        },
        child: Center(
          child: Text(
            'Uloguj se',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    final registrationButton = Material(
      color: Color(0xff59081b),
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        minWidth: GetSize.getMaxWidth(context),
        padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrationPage()),
          );
        },
        child: Center(
          child: Text(
            'Registruj se',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    final nastaviKaoGostButton = Material(
      color: Color(0xff59081b),
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        minWidth: GetSize.getMaxWidth(context),
        padding: EdgeInsets.fromLTRB(5.0, 15.0, 15.0, 15.0),
        onPressed: () {
          prefs.setInt("id", -1);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
        child: Center(
          child: Text(
            'Nastavi kao gost',
            //textScaleFactor: 0.8,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    // ignore: unused_element
    void _toggle() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    Container container1 = Container(
        margin: EdgeInsets.only(top: 10, bottom: 30),
        width: GetSize.getMaxWidth(context) *
            0.8, // staviti da bude zavisno od telefona
        //height: GetSize.getMaxHeight(context) * 0.6, // isto
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
              SizedBox(
                height: GetSize.getMaxHeight(context) * 0.03,
              ),
              new Text(
                "Imaš nalog?",
                textScaleFactor: 1,
                style: TextStyle(color: Colors.white),
              ),
              emailField,
              Column(
                children: [
                  passField,
                  new TextButton(onPressed: _toggle, child: new Icon(_obscureText? Icons.visibility : Icons.visibility_off_outlined, color: Colors.white,)),
                ],
              ),
              SizedBox(
                height: GetSize.getMaxHeight(context) * 0.03,
              ),
              loginButton,
              SizedBox(
                height: GetSize.getMaxHeight(context) * 0.03,
              ),
              new Text(
                "Nemaš nalog?",
                textScaleFactor: 1,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: GetSize.getMaxHeight(context) * 0.02,
              ),
              registrationButton,
              SizedBox(
                height: GetSize.getMaxHeight(context) * 0.02,
              ),
              nastaviKaoGostButton,
            ],
          ),
        ));

    Container container2 = Container(
      //margin: EdgeInsets.only(top: 10, bottom: 20),
        width: 400, // staviti da bude zavisno od telefona
        //height: GetSize.getMaxHeight(context) * 0.6, // isto
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
              SizedBox(
                height: GetSize.getMaxHeight(context) * 0.03,
              ),
              new Text(
                "Imaš nalog?",
                textScaleFactor: 1,
                style: TextStyle(color: Colors.white),
              ),
              emailField,
              Column(
                children: [
                  passField,
                  new TextButton(onPressed: _toggle, child: new Icon(_obscureText? Icons.visibility : Icons.visibility_off_outlined, color: Colors.white,)),
                ],
              ),

              SizedBox(
                height: GetSize.getMaxHeight(context) * 0.03,
              ),
              loginButton,
              SizedBox(
                height: GetSize.getMaxHeight(context) * 0.03,
              ),
              new Text(
                "Nemaš nalog?",
                textScaleFactor: 1,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: GetSize.getMaxHeight(context) * 0.02,
              ),
              registrationButton,
              SizedBox(
                height: GetSize.getMaxHeight(context) * 0.02,
              ),
              nastaviKaoGostButton,
            ],
          ),
        ));

    return Scaffold(
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
          color: Color(0xffd5f5e7),
          width: GetSize.getMaxWidth(context),
          height: GetSize.getMaxHeight(context) * 1,
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
                  height:
                  200, //GetSize.getMaxWidth(context) < maxContainerWidth ? 100 : 200, //2 * GetSize.getMaxHeight(context) / 8,
                  child: Image.asset(
                    'images/logo.png',
                    fit: BoxFit.fitHeight,
                  ),
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
        ), //home: MyHomePage(title: 'Flutter Demo Home Page')
      ),
    );
  }
}
