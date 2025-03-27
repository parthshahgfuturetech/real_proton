import 'dart:convert';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/modules/api_services/api_services.dart';
import 'package:real_proton/utils/apis.dart';
import 'package:real_proton/utils/strings.dart';
import 'package:real_proton/utils/widgets.dart';

class WalletController extends GetxController {
  RxBool isBalanceShow = false.obs,
      isTransactionHistoryShow = false.obs,
      isLoading = false.obs;
  RxString selectedNetwork = 'isEmpty'.obs,selected = ''.obs;
  RxDouble rpPrice= 0.0.obs,totalValue = 0.0.obs;
  RxList assets = [].obs;
  final Logger _logger = Logger();
  final ApiService apiService = ApiService();

  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //   fetchAssetsData();
  // }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    fetchChainData();
    fetchAssetsData();
  }

  final List<Map<String, String>> networks = <Map<String, String>>[].obs;

  String buildSortImages(String assetsId) {
    switch (assetsId) {
      case 'RP_B6TVQTHS_W0V6':
        return 'assets/images/logo-withoutborder.png';
      case 'ETH-OPT_SEPOLIA':
        return 'assets/images/stroke-rounded-1.png';
      case 'BNB_TEST':
        return 'assets/images/stroke-rounded-2.png';
      case 'AMOY_POLYGON_TEST':
        return 'assets/images/stroke-rounded-3.png';
      case 'CELO_ALF':
        return 'assets/images/stroke-rounded-5.png';
      case 'ARBITRUM':
        return 'assets/images/logo-withoutborder.png';
      case 'USDT_B7ZRVRFH_4YOH':
        return 'assets/images/USDT-crypto-icon.png';
      case 'USDC_B7ZRVRFH_4YOH':
        return 'assets/images/USDC-crypto-icon.png';
      case 'USDCDUMMY_B7ZRVRFH_F99R':
        return 'assets/images/USDC-crypto-icon.png';
      case 'USDDUMMY_B7ZRVRFH_K71G':
        return 'assets/images/logo-withoutborder.png';
      case 'AVAXTEST':
        return 'assets/images/stroke-rounded-6.png';
      default:
        return 'assets/images/logo-withoutborder.png';
    }
  }

  String buildSortNames(String assetsId) {
    switch (assetsId) {
      case 'RP_B6TVQTHS_W0V6':
        return 'RP';
      case 'ETH-OPT_SEPOLIA':
        return 'ETH';
      case 'BNB_TEST':
        return 'BSC';
      case 'AMOY_POLYGON_TEST':
        return 'POLYGON';
      case 'CELO_ALF':
        return 'CELO';
      case 'ARBITRUM':
        return 'ARBITRUM';
      case 'USDT_B7ZRVRFH_4YOH':
        return 'USDT';
      case 'USDC_B7ZRVRFH_4YOH':
        return 'USDC';
      case 'USDCDUMMY_B7ZRVRFH_F99R':
        return 'USDC';
      case 'USDDUMMY_B7ZRVRFH_K71G':
        return 'USDD';
      case 'AVAXTEST':
        return 'AVAXTEST';
      default:
        return 'UnKnowName';
    }
  }

  String buildSortPrice2(double balance,String id) {
    rpPrice.value = CustomWidgets.weiToRP(blockChainController.tokenPrice.value);
    switch (id) {
      case 'RP_B6TVQTHS_W0V6':
        return (rpPrice.value * balance).toStringAsFixed(2);
      case 'ETH-OPT_SEPOLIA':
        return 'ETH';
      case 'BNB_TEST':
        return 'BSC';
      case 'AMOY_POLYGON_TEST':
        return 'POLYGON';
      case 'CELO_ALF':
        return 'CELO';
      case 'ARBITRUM':
        return 'ARBITRUM';
      case 'USDT_B7ZRVRFH_4YOH':
        return 'USDT';
      case 'USDC_B7ZRVRFH_4YOH':
        return (1*balance).toStringAsFixed(2);
      case 'USDCDUMMY_B7ZRVRFH_F99R':
        return (1*balance).toStringAsFixed(2);
      case 'USDDUMMY_B7ZRVRFH_K71G':
        return (1*balance).toStringAsFixed(2);
      case 'AVAXTEST':
        return (0*balance).toStringAsFixed(2);
      default:
        return 'UnKnowName';
    }
  }

  double calculateTotalPrice() {
    double total = 0.0;

    for (var asset in walletController.assets) {
      String id = asset['id'];
      double balance = double.tryParse(asset['balance'].toString()) ?? 0.0;

      String priceString = buildSortPrice2(balance, id);
      double price = double.tryParse(priceString) ?? 0.0;

      total += price;
    }

    return total;
  }

  void updateTotalBalance() {
    totalValue.value = calculateTotalPrice();
  }


  String buildSortPrice1(String id) {
    switch (id) {
      case 'RP_B6TVQTHS_W0V6':
        return rpPrice.value.toStringAsFixed(2);
      case 'ETH-OPT_SEPOLIA':
        return 'ETH';
      case 'BNB_TEST':
        return 'BSC';
      case 'AMOY_POLYGON_TEST':
        return 'POLYGON';
      case 'CELO_ALF':
        return 'CELO';
      case 'ARBITRUM':
        return 'ARBITRUM';
      case 'USDT_B7ZRVRFH_4YOH':
        return 'USDT';
      case 'USDC_B7ZRVRFH_4YOH':
        return (1).toStringAsFixed(2);
      case 'USDCDUMMY_B7ZRVRFH_F99R':
        return (1).toStringAsFixed(2);
      case 'USDDUMMY_B7ZRVRFH_K71G':
        return (1).toStringAsFixed(2);
      case 'AVAXTEST':
        return (0).toStringAsFixed(2);
      default:
        return 'UnKnowName';
    }
  }

  Future<void> fetchChainData() async{
    isLoading.value = true;
    try{
      final response = await apiService.get(Get.context!, ApiUtils.chainDataApi);

      if(response.statusCode == 200){
        final responseJson = response.data['data'];
        String decryptedText = CustomWidgets.decryptOpenSSL(responseJson, StringUtils.secretKey);
        final List<dynamic> decryptedData = jsonDecode(decryptedText);

        if (decryptedData.isNotEmpty) {
          networks.assignAll(decryptedData.map((item) => {
            'name': item['chainName'].toString(),
            'icon': item['iconUrl'].toString()
          }));

          selectedNetwork.value = networks.firstOrNull?['name'] ?? selectedNetwork.value;
        }

      }else{
        isLoading.value = false;
      }

    }catch(e){
      _logger.i("Error:-$e");
      isLoading.value = false;
    }finally{
      isLoading.value = false;
    }
  }

  Future<void> fetchAssetsData() async {
    isLoading.value = true;
    try {
      final response =
          await apiService.get(Get.context!, ApiUtils.walletAssetsData);

      if (response.statusCode == 200) {

        final responseJson = response.data['vault'];
        String decryptedText = CustomWidgets.decryptOpenSSL(responseJson, StringUtils.secretKey);
        final Map<String, dynamic> decryptedData = jsonDecode(decryptedText);

        assets.addAll(decryptedData['assets']);
        _logger.i("Api Successfully${decryptedData['assets']}");
        updateTotalBalance();
      } else {
        isLoading.value = false;
        _logger.i("Error in Api:-");
      }
    } catch (e) {
      isLoading.value = false;
      _logger.i("Error in Api:-$e");
    } finally {
      isLoading.value = false;
    }
  }
}
