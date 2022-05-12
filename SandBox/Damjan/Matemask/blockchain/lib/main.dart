import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Blockchain'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _currentSliderValue = 20;
  Client httpClient;
  Web3Client ethClient;
  bool data = false;

  final myAddress = "0x099B4eb278200174f79b3A2Bb7E13f39917Ffa94";

  var myData;
  String txHash;

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(
        "https://rinkeby.infura.io/v3/5d30bd85426b45f7afa1ee8f846d2915",
        httpClient);
    getBalance(myAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Wrap(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 200.0),
          ElevatedButton(
            onPressed: () => getBalance(myAddress),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.012,
                  MediaQuery.of(context).size.width * 0.01,
                  MediaQuery.of(context).size.width * 0.012,
                  MediaQuery.of(context).size.width * 0.01),
            ),
            child: Text('refresh'),
          ),
          ElevatedButton(
            onPressed: () => sendCoin(),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.012,
                  MediaQuery.of(context).size.width * 0.01,
                  MediaQuery.of(context).size.width * 0.012,
                  MediaQuery.of(context).size.width * 0.01),
            ),
            child: Text('deposit'),
          ),
          ElevatedButton(
            onPressed: () => withdrawCoin(),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.012,
                  MediaQuery.of(context).size.width * 0.01,
                  MediaQuery.of(context).size.width * 0.012,
                  MediaQuery.of(context).size.width * 0.01),
            ),
            child: Text('withdraw'),
          ),
        ],
      ),
      Slider(
          value: _currentSliderValue,
          min: 0,
          max: 100,
          divisions: 5,
          label: _currentSliderValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
              print(_currentSliderValue);
            });
          }),
      SizedBox(height: 100.0),
      Center(
        child: Container(
          child: Text("Zelimo promenimo za $_currentSliderValue"),
        ),
      ),
      SizedBox(height: 100.0),
      Center(
        child: Container(
          child: Text("$myData"),
        ),
      ),
    ]));
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    String contractAddress = "0x05f687cEF15B17F1afA04e6416F5A4BD5624b56F";

    final contract = DeployedContract(ContractAbi.fromJson(abi, "Contract"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();

    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);

    return result;
  }

  Future<void> getBalance(String myAddress) async {
    //EthereumAddress address = EthereumAddress.fromHex(myAddress);

    List<dynamic> result = await query("getBalance", []);

    myData = result[0];
    data = true;

    setState(() {});
  }

  Future<String> sendCoin() async {
    var bigAmount = BigInt.from(_currentSliderValue);

    var response = await submit("depositBalance", [bigAmount]);
    print("Deposited");
    txHash = response;
    setState(() {
      print(txHash);
    });
    return response;
  }

  Future<String> withdrawCoin() async {
    var bigAmount = BigInt.from(_currentSliderValue);

    var response = await submit("withdrawBalance", [bigAmount]);
    print("Deposited");
    txHash = response;
    setState(() {
      print(txHash);
    });
    return response;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(
        "83b1cd465b35253c039361fdaccf2d2c2c347ff96774ae85e912a2d583910b78");

    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract, function: ethFunction, parameters: args),
        fetchChainIdFromNetworkId: true);

    return result;
  }
}
