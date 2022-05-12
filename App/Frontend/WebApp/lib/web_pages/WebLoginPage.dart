import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/RegistrationPage.dart';
import 'package:flutter_app/pages/HomePage.dart';
import 'package:provider/provider.dart';
import '../models/UserModel.dart';
import '../utility/GetSize.dart';


class WebLoginPage extends StatefulWidget {
  static const routeName = '/login';
  @override
  State<StatefulWidget> createState() {
    return _WebLoginPageState();
  }
}

class _WebLoginPageState extends State<WebLoginPage> {
  final double maxContainerWidth = 600;
  var list;
  var loading = true;

  konekcija() async {
    list = await Provider.of<UserModel>(context, listen: false);
  }

  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      this.konekcija().then((result) {
        setState(() {
          loading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final myControllerEmail = TextEditingController();
    final myControllerPass = TextEditingController();
    bool _obscureText = true;
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
        obscureText: true,
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
        onPressed: () {
          String ans =
          list.checkUser(myControllerEmail.text, myControllerPass.text);
          print(ans.toString());
          if (ans.toString() == "true") {
            //uspesan login
            //MaterialPageRoute(builder: (context) => HomePage());

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomePage()));
          } else if (ans.toString() == "WrongEmail") {
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
                                      "Korisnik sa ovim e-mail-om ne postoji. "),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      "Dodirnite bilo gde van belog prozora kako biste se vratili nazad."),
                                ),
                              ])));
                });
          } else if (ans.toString() == "WrongPass") {
            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("Netacna lozinka"),
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
              emailField,
              passField,
              //new TextButton(onPressed: _toggle, child: new Text(_obscureText? "Show" : "Hide")),
              SizedBox(
                height: GetSize.getMaxHeight(context) * 0.03,
              ),
              loginButton,
              SizedBox(
                height: GetSize.getMaxHeight(context) * 0.03,
              ),
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
              emailField,
              passField,
              //new TextButton(onPressed: _toggle, child: new Text(_obscureText? "Show" : "Hide")),
              SizedBox(
                height: GetSize.getMaxHeight(context) * 0.03,
              ),
              loginButton,
              SizedBox(
                height: GetSize.getMaxHeight(context) * 0.03,
              ),
            ],
          ),
        ));

    return Scaffold(
      body: loading ? Center(
        child: CircularProgressIndicator(
            backgroundColor: Colors.black,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red)),
      )
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
                  height: 100, //GetSize.getMaxWidth(context) < maxContainerWidth ? 100 : 200, //2 * GetSize.getMaxHeight(context) / 8,
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
