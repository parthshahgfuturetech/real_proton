import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';

class BlockChainController extends GetxController {
  late Web3Client _client;
  // var coins = <Crypto>[].obs;  // List of coins
  var isLoading = true.obs;  // Loading state
  var errorMessage = ''.obs;  // Error message

  final String _rpcUrl = "https://alfajores-forno.celo-testnet.org";
  final String _contractAddress = "0xa7458C9c4f9Ff22c38bf3001F2D499C22C4711cB";
  final String _userAddress = "0xe0Bebdfe468F2737E5eBaC7c9e55fed0Cfd253D7";

  var tokenPrice = "".obs;
  var userBalance = "".obs;
  var totalSupply = "".obs;
  var identityRegistry = "".obs;

  late DeployedContract _contract;
  late ContractFunction _tokenPrice;
  late ContractFunction _balanceOf;
  late ContractFunction _totalSupply;
   String network ="";
  @override
  void onInit() {
    super.onInit();
    _client = Web3Client(_rpcUrl, Client());
    loadContract();
    // updateNetwork();

  }
  final String apiKey = 'df5d9724-c1c8-49fc-841b-58ab33a7acee';  // Replace with your CoinMarketCap API key

  RxString selectedNetwork = ''.obs; // Default network

  void updateNetwork(String network) {
    selectedNetwork.value = network;
    print("Network updated in BlockChainController: ${selectedNetwork.value}");
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

      tokenPrice.value = price[0].toString();
      userBalance.value = balance[0].toString();
      totalSupply.value = supply[0].toString();
      // identityRegistry.value = registry[0].toString();
    } catch (e) {
      print("Error fetching data: $e");
    }
  }


  Future<void> fetchCryptoPrices() async {
    try {
      isLoading(true);  // Start loading
      errorMessage('');  // Reset error message

      var url = Uri.parse(
        "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?start=1&limit=5000&convert=USD",
      );

      var response = await http.get(
        url,
        headers: {
          'X-CMC_PRO_API_KEY': apiKey,
          "Accept": "application/json",
        },
      );

      // if (response.statusCode == 200) {
      //   Payload payload = Payload.fromJson(json.decode(response.body));
      //   coins.value = payload.data;  // Update the coins list
      // } else {
      //   errorMessage('Failed to load data');  // Set error message
      // }
    } catch (e) {
      errorMessage('Error: $e');  // Catch and display any error
    } finally {
      isLoading(false);  // Stop loading
    }
  }
}
