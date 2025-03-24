import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_proton/modules/api_services/api_services.dart';
import 'package:real_proton/utils/apis.dart';
import 'package:real_proton/utils/graphql.dart';
import 'package:real_proton/utils/strings.dart';
import 'package:real_proton/utils/widgets.dart';

class HistoryController extends GetxController {
  var activeTab = 0.obs;
  var isSuccessAndFailSellAndBuy = false.obs;
  var errorMessage = "".obs;
  var isLoading = true.obs;
  var transactions = [].obs;
  final Logger _logger = Logger();
  final ApiService apiService = ApiService();
  final lockInHistory = [
    {
      "amount": "150 RP",
      "date": "23 Dec 2024, 10:15 PM",
      "unlockIn": "90 Days"
    },
    {
      "amount": "150 RP",
      "date": "30 Jul 2024, 10:15 PM",
      "unlockIn": "85 Days"
    },
    {
      "amount": "150 RP",
      "date": "30 Jul 2024, 10:15 PM",
      "unlockIn": "76 Days"
    },
    {
      "amount": "150 RP",
      "date": "30 Jul 2024, 10:15 PM",
      "unlockIn": "10 Days"
    },
    {
      "amount": "150 RP",
      "date": "26 Sep 2024, 10:15 PM",
      "unlockIn": "03 Days"
    },
  ];
  var transactionType = ["All"].obs;
  var method = [""].obs;
  var status = [""].obs;
  var blockchain = [""].obs;
  var paymentStatus = [""].obs;
  var paymentOpenAndComplete = [""].obs;

  @override
  void onInit() {
    super.onInit();
    // if(activeTab.value ==0){
    //   fetchTransactionData();
    // }else{
      fetchFiatData();
    // }
  }

  void toggleSelection(RxList<String> selectedList, String value) {
    if (value == "All") {
      selectedList.assignAll(["All"]);
    } else {
      if (selectedList.contains(value)) {
        if(selectedList.contains("Incoming") || selectedList.contains("Outgoing")){
          selectedList.clear();
          selectedList.add("All");
        }else{
          selectedList.clear();
          selectedList.add("");
        }
      } else {
        selectedList.assignAll([value]);
      }
    }
    selectedList.refresh();
  }

  Future<void> fetchFiatData() async {
    try {
      isLoading.value = true;
      transactions.clear();

      final data = {
        "payment_status": paymentStatus[0].toLowerCase(),
        "limit":10,
        // "page":1
      };

      final response = await apiService.get(Get.context!, ApiUtils.fiatData, queryParameters: data);
      if(response.statusCode == 200){
        final responseJson = response.data['data'];
        String decryptedText =
        CustomWidgets.decryptOpenSSL(responseJson, StringUtils.secretKey);
        final Map<String, dynamic> decryptedData = jsonDecode(decryptedText);
        transactions.addAll(decryptedData['data']);
        _logger.i("-=-=>${decryptedData['data']}");
      }else{
        isLoading.value = false;
        transactions.clear();
        _logger.e("Failed to fetch data: ${response.statusCode}");
      }

    } catch (e) {
      isLoading.value = false;
      _logger.i("error message fiat Api :->$e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTransactionData() async {
    try {
      isLoading.value = true;
      transactions.clear();
      final data = {
        "transactionType": transactionType[0].toLowerCase(),
        "limit": 20,
        "assetId": method[0].toLowerCase(),
        "status": status[0].toUpperCase(),
        "feeCurrency": blockchain[0].toLowerCase(),
      };

      final response = await apiService.get(
          Get.context!, "https://api.realproton.com/v1/transaction/all",
          queryParameters: data);

      if (response.statusCode == 200) {

        final responseJson = response.data['data'];
        String decryptedText = CustomWidgets.decryptOpenSSL(responseJson, StringUtils.secretKey);
        final Map<String, dynamic> decryptedData = jsonDecode(decryptedText);

        transactions.addAll(decryptedData['data']);
        _logger.i("Response Data: ${decryptedData}");
      } else {
        isLoading.value = false;
        transactions.clear();
        _logger.e("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      isLoading.value = false;
      _logger.i("error message :->$e");
    } finally {
      isLoading.value = false;
    }
  }
}
