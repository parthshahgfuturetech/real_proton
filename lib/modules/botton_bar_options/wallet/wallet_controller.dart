import 'dart:convert';
import 'package:flutter/material.dart';
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
      isLoading = false.obs,isSuccessAndFail = false.obs;
  RxString selectedNetwork = 'isEmpty'.obs,selected = ''.obs,
      walletAddress = ''.obs, remarks = ''.obs;
  RxDouble rpPrice= 0.0.obs,totalValue = 0.0.obs,
      transferAmount = 0.0.obs,maxBalance = 125.00.obs;
  RxList assets = [].obs;
  TextEditingController textController = TextEditingController();
  final Logger _logger = Logger();
  final ApiService apiService = ApiService();
  var chainId;
  var balance=0.0;
  var assetId="";
  bool chainFound = false;
  bool walletFound = false;

  // @override
  // void onReady() {
  //   // TODO: implement onReady
  //   super.onReady();
  //   fetchChainData();
  //   fetchAssetsData();
  // }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    rpPrice.value =
        CustomWidgets.weiToRP(blockChainController.tokenPrice.value);
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
        return '0.0';
    }
  }

  double calculateTotalPrice() {
    double total = 0.0;

    for (var asset in assets) {
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
            'icon': item['iconUrl'].toString(),
            'id':item['_id'].toString()

          }));
          chainId=networks.firstOrNull?['id']?? "";
          selectedNetwork.value = networks.firstOrNull?['name'] ?? selectedNetwork.value;
          chainId = networks.firstOrNull?['id'] ?? "";

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

  void fetchAssetsData() async {
    isLoading.value = true;
    // assets.clear();
    try {
      final response = await apiService.get(Get.context!, ApiUtils.walletAssetsData);

      if (response.statusCode == 200) {
        final responseJson = response.data['vault'];
        String decryptedText = CustomWidgets.decryptOpenSSL(responseJson, StringUtils.secretKey);
        final Map<String, dynamic> decryptedData = jsonDecode(decryptedText);

        assets.assignAll(decryptedData['assets'] ?? []);
        _logger.i("fetchAssetsData Api Successfully${decryptedData['assets']}");
        await Future.delayed(Duration(seconds: 1), () {
          updateTotalBalance();
        });
      } else {
        _logger.i("Error in API");
      }
    } catch (e) {
      _logger.i("Error in API: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }


  Future<void> getAllAddressApi({required String walletsAddress}) async{
    isLoading.value = true;

    try{

      final response = await apiService.get(Get.context!,ApiUtils.allWalletsApi);

      if(response.statusCode == 200){
        final responseJson = response.data['data'];
        String decryptedText = CustomWidgets.decryptOpenSSL(responseJson, StringUtils.secretKey);
        final List<dynamic> decryptedData = jsonDecode(decryptedText);
             var getData=decryptedData[0]['chains'][0]['chainId'];
             print("getAllAddressApi-getData-----> $getData");
             print("getAllAddressApi-decryptedData-----> $decryptedData");
        // decryptedData[0]['chains'][0]['isWhitelisted']
        for (var data in decryptedData) {
          if (data['walletAddress'] == walletsAddress) {
            print('Wallet Address found:---- $walletsAddress');
            walletFound = true;
            if (data['chains'] != null && data['chains'] is List && data['chains'].isNotEmpty) {
              bool isWhitelisted = data['chains'][0]['isWhitelisted'] ?? false; // Default to false if null

              if (isWhitelisted) {
                print("Whitelisted: Yes");
                transferTokenApi(walletsAddress);

              } else {
                CustomWidgets.showInfo(context: Get.context!, message: "wallet Address not whitlisted ");

              }
            } else {
              print("⚠️ No chains data available");
            }
            break;
          }
        }

        if (!walletFound) {
          CustomWidgets.showInfo(context: Get.context!, message: "Wallet Address not found");
        }

        for (var data in decryptedData) {
          var chains = data['chains'];
          if (chains != null) {
            for (var chain in chains) {
              if (chain['chainId'] == chainId) {
                print('Chain ID found:----- $chainId');
                chainFound = true;
                break;
              }
            }
            if (chainFound) break;
          }
        }

        if (!chainFound) {
          CustomWidgets.showInfo(context: Get.context!, message: "Chain ID not found");
        }
        print("-=-=>$decryptedData");

      }else{
        isLoading.value = false;
        _logger.i("Error");
      }
    }catch(e){
      _logger.i("Error:-$e");
      isLoading.value = false;
    }finally{
      isLoading.value = false;
    }
  }

  void transferTokenApi(String walletsAddress) async {
    isLoading.value = true;
    // assets.clear();

    try {
      final data = {
        "amount": textController.text,  // Ensure correct usage
        "note": "${remarks.value}",
        "assetId": "$assetId",
        "externalAddress": "$walletsAddress",
        "sourceVaultId": profileController.vaultId
      };

      _logger.i("API Request: POST ${ApiUtils.tranferTokenApi}");
      _logger.i("Request Body: ${jsonEncode(data)}");

      final response = await apiService.post(Get.context!, ApiUtils.tranferTokenApi, data: data);
      _logger.i("Raw Response: ${response.toString()}");

      if (response.statusCode == 200 && response.data != null) {
        _logger.i("API Response Data: ${jsonEncode(response.data)}");

        try {
          final responseJson = response.data['vault'];
          if (responseJson != null) {
            String decryptedText = CustomWidgets.decryptOpenSSL(responseJson, StringUtils.secretKey);
            final Map<String, dynamic> decryptedData = jsonDecode(decryptedText);

            if (decryptedData.containsKey('assets')) {
              assets.addAll(decryptedData['assets']);
              _logger.i("fetchAssetsData API Successful: ${decryptedData['assets']}");
            } else {
              _logger.w("Decrypted response missing 'assets' key");
            }
          } else {
            _logger.w("Response JSON is null");
          }
        } catch (decryptionError) {
          _logger.e("Decryption Error: $decryptionError");
        }
      } else {
        _logger.e("Error in API Response: ${response.statusCode} - ${response.data}");
      }
    } catch (e, stackTrace) {
      _logger.e("Exception in API: $e\nStackTrace: $stackTrace");
    } finally {
      isLoading.value = false;
      update();
    }
  }






  void logoutUser() {

    assets.value = [];
    _logger.i("User logged out. Cleared asset data.");
  }

  double calculateTotalAmount(TextEditingController controller, String assetPrice) {
    print("controller----$controller $assetPrice");
    double inputValue = double.tryParse(controller.text) ?? 0.0;
    double assetValue = double.tryParse(assetPrice) ?? 0.0;
    return inputValue * assetValue;
  }

}
