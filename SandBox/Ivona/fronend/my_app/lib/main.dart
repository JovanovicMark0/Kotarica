
import 'package:flutter/material.dart';
import 'package:my_app/series.dart';
import 'package:uuid/uuid.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Demo App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Flutter Login'),
    );
  }
}

class MyHomePage extends StatefulWidget{
  MyHomePage({Key key, this.title}) : super(key: key);

  String rpcURL = "http://127.0.0.1:7545";
  String wsUrl = "http://127.0.0.1:7545/";
   void sendEther(){
    Web3Client client = Web3Client(rpcURL, Client(), socketConnector: (){return IOWebSocketChannel.connect(wsUrl).cast<String>();});

    String privateKey = "00333ab3994f8006f9bce1fbbe3f3c725b92a32026c4e6735f6631af0ae6ee06";
    //Credentials credentials = await client.credentialsFromPrivateKey(privateKey);
   // EthereumAddress ownAddress = await credentials.extractAddress();
   // client.sendTransaction(credentials, Transaction(from:ownAddress));
  }

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  TextStyle style = TextStyle(
      fontFamily: 'AkayaKanadaka',
      fontSize: 20.0
  );

  @override
  Widget build(BuildContext context) {
    bool _obscureText = true;
    final emailField = TextField(
      style: style,
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        hintText: 'Email',
      ),
    );


    final passField = TextField(
      style: style,
      obscureText: _obscureText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        hintText: 'Password',
      ),
    );

    final loginButton = Material(
      color: Color(0xFF000000),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Series()),);
        },
        child: Center(
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Colors.blue[50],
              fontFamily: 'AkayaKanadaka',
            ),
          ),
        ),
      ),
    );

    void _toogle(){
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.deepPurple[50],
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  child: Image.asset('images/image.png', fit: BoxFit.contain),
                ),
                SizedBox(height: 50.0),
                emailField,
                SizedBox(height: 30.0),
                passField,
                new FlatButton(onPressed: _toogle, child: new Text(_obscureText ? "Show":"Hide")),
                SizedBox(height: 40.0),
                loginButton,
                SizedBox(height: 20.0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class Series extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SeriesState();
}

class _SeriesState extends State<Series> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        excludeHeaderSemantics: true,
        backgroundColor: Colors.deepPurple[900],
      ),
      body: Center(
        child:Text(""),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pop(context);
        },
        child: Text(" Go Back!",),
      ),
    );
  }
}