import 'package:http/http.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class EstablishConnection{
  String rpcURL = "http://127.0.0.1:7545";
  String wsURL = "ws://127.0.0.1:7545/";
  String privateKey = "5f0b2a8654b34ec1a5a799c35bab342cec6542170aceaea0490eb8c56dec1c80";
  //Credentials fromHex = EthPrivateKey.fromHex("672b8663f47c10bb713554f5e71711a55d2d0ba3c4934d20f6cb9037803e3737");

  Web3Client client;
  Credentials credentials;
  EtherAmount balance;
  EthereumAddress address;

  Future<void> establish_connection() async {
    print("*****SHLJOOOONKARY*******");
    client = Web3Client(rpcURL, Client(), socketConnector: (){
      return IOWebSocketChannel.connect(wsURL).cast<String>();
    });
    if(client == null)
        print("*****JESTE NULLLLLLLL*******");
    credentials = await client.credentialsFromPrivateKey(privateKey);
    address = await credentials.extractAddress();
    print(address);
  }

  Future<String> getInformation() async{
    String sAddress = "ACCOUNT ADDRESS: ";
    String sPrivateKey = "PRIVATE KEY: ";
    String sCurrentEther = "CURRENT BALANCE (ETH): ";
    if(client == null){
      print("\n\n\n********* JESTE NULL ************\n");
    }
    balance = await client.getBalance(await credentials.extractAddress());

    print("\n[EVO ME: " + EthereumAddress.addressByteLength.toString());

    sAddress += EthereumAddress.addressByteLength.toString();
    sPrivateKey += privateKey;
        //privateKeyBytesToPublic(_convertKeyToInt(privateKey)).toString();
    sCurrentEther += EtherUnit.ether.toString();

    return sAddress + "\n" + sPrivateKey + "\n" + sCurrentEther + "\n";
  }
/*
  Uint8List _convertKeyToInt(String value){
    List<int> list = privateKey.codeUnits;
    Uint8List bytes = Uint8List.fromList(list);
    return bytes;
  }


  // ignore: non_constant_identifier_names
  EthereumConnection(){
    print("-------------------------");
    establish_connection();
  }
*/
}