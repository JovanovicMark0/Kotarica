import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart';


void main() {
}



class MyHomePage {
}


Future<DeployedContract> loadContract() async {
  String abiCode = await rootBundle.loadString("assets/abi.json");
  String contractAddress = "0xa77F5C5F01d6f90c7b6B57e12F4B16c1e8AA4957";

  final contract = DeployedContract(ContractAbi.fromJson(abiCode, "MetaCoin"),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<String> submit(String functionName, List<dynamic> args) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(
      "e056e29af7d3c12debb026b9d6e11c4bfe5526f051bb51f736125e61630943f1");

  DeployedContract contract = await loadContract();

  final ethFunction = contract.function(functionName);

  var ethClient;
  var result = await ethClient.sendTransaction(
    credentials,
    Transaction.callContract(
      contract: contract,
      function: ethFunction,
      parameters: args,
    ),
  );
  return result;
}

Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
  final contract = await loadContract();
  final ethFunction = contract.function(functionName);
  var ethClient;
  final data = await ethClient.call(
      contract: contract, function: ethFunction, params: args);
  return data;
}

Future<String> sendCoind(String targetAddressHex, int amount) async {
  EthereumAddress address = EthereumAddress.fromHex(targetAddressHex);
  // uint in smart contract means BigInt for us
  var bigAmount = BigInt.from(amount);
  // sendCoin transaction
  var response = await submit("sendCoin", [address, bigAmount]);
  // hash of the transaction
  return response;
}

Future<List<dynamic>> getBalance(String targetAddressHex) async {
  EthereumAddress address = EthereumAddress.fromHex(targetAddressHex);
  // getBalance transaction
  List<dynamic> result = await query("getBalance", [address]);
  // returns list of results, in this case a list with only the balance
  return result;
}

