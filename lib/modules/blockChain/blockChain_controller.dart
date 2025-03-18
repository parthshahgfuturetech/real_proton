import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';

class BlockChainController extends GetxController {
  late Web3Client _client;

  // Blockchain config
  final String _rpcUrl = "https://alfajores-forno.celo-testnet.org";
  final String _contractAddress = "0xa7458C9c4f9Ff22c38bf3001F2D499C22C4711cB";
  final String _userAddress = "0xe0Bebdfe468F2737E5eBaC7c9e55fed0Cfd253D7";

  // Observables (Reactive variables)
  var tokenPrice = "".obs;
  var userBalance = "".obs;
  var totalSupply = "".obs;
  var identityRegistry = "".obs;

  late DeployedContract _contract;
  late ContractFunction _tokenPrice;
  late ContractFunction _balanceOf;
  late ContractFunction _totalSupply;

  @override
  void onInit() {
    super.onInit();
    _client = Web3Client(_rpcUrl, Client());
    loadContract();
  }

  Future<void> loadContract() async {
    try {
      // Load ABI
      String abiString = await rootBundle.loadString('assets/jsonFile/ABI.json');
      var abiJson = jsonDecode(abiString);

      _contract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(abiJson), "TokenContract"),
        EthereumAddress.fromHex(_contractAddress),
      );

      _tokenPrice = _contract.function("gettokenPrice");
      _balanceOf = _contract.function("balanceOf");
      _totalSupply = _contract.function("totalSupply");

      fetchData();
    } catch (e) {
      print("Error loading contract: $e");
    }
  }

  Future<void> fetchData() async {
    try {
      final price = await _client.call(
        contract: _contract,
        function: _tokenPrice,
        params: [],
      );

      final balance = await _client.call(
        contract: _contract,
        function: _balanceOf,
        params: [EthereumAddress.fromHex(_userAddress)],
      );

      final supply = await _client.call(
        contract: _contract,
        function: _totalSupply,
        params: [],
      );

      // Update UI using GetX reactive state
      tokenPrice.value = price[0].toString();
      userBalance.value = balance[0].toString();
      totalSupply.value = supply[0].toString();
      // identityRegistry.value = registry[0].toString();
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
}
