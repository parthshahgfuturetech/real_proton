import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_proton/modules/api_services/api_services.dart';
import 'package:real_proton/utils/apis.dart';

class WalletController extends GetxController {
  var isBalanceShow = false.obs,
      isTransactionHistoryShow = false.obs,
      isLoading = false.obs;
  var selectedNetwork = 'Ethereum'.obs;
  var copyString = "0xgbg...vbhgj".obs;
  var assets = [].obs;
  final Logger _logger = Logger();
  final ApiService apiService = ApiService();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAssetsData();
  }

  final List<Map<String, String>> networks = [
    {'name': 'Ethereum', 'icon': 'assets/images/stroke-rounded-1.png'},
    {'name': 'BSC', 'icon': 'assets/images/stroke-rounded-2.png'},
    {'name': 'Polygon', 'icon': 'assets/images/stroke-rounded-3.png'},
    {'name': 'Arbitrum', 'icon': 'assets/images/stroke-rounded-4.png'},
    {'name': 'Celo', 'icon': 'assets/images/stroke-rounded-5.png'},
    {'name': 'Avalanche', 'icon': 'assets/images/stroke-rounded-6.png'},
  ];

  String buildSortImages(String assetsId) {
    switch (assetsId) {
      case 'RPN_B7ZRVRFH_0GK9':
        return 'assets/images/logo-withoutborder.png';
      case 'ETH_TEST5':
        return 'assets/images/stroke-rounded-1.png';
      case 'BSC':
        return 'assets/images/stroke-rounded-2.png';
      case 'POLYGON':
        return 'assets/images/stroke-rounded-3.png';
      case 'CELO_ALF':
        return 'assets/images/stroke-rounded-5.png';
      case 'ARBITRUM':
        return 'assets/images/image3.png';
      case 'USDT_B7ZRVRFH_4YOH':
        return 'assets/images/USDT-crypto-icon.png';
      case 'USDC_B7ZRVRFH_4YOH':
        return 'assets/images/USDC-crypto-icon.png';
      case 'USDCDUMMY_B7ZRVRFH_F99R':
        return 'assets/images/USDC-crypto-icon.png';
      case 'USDDUMMY_B7ZRVRFH_K71G':
        return 'assets/images/image3.png';
      default:
        return 'assets/images/default.png';
    }
  }

  String buildSortNames(String assetsId) {
    switch (assetsId) {
      case 'RPN_B7ZRVRFH_0GK9':
        return 'RP';
      case 'ETH_TEST5':
        return 'ETH';
      case 'BSC':
        return 'BSC';
      case 'POLYGON':
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
      default:
        return 'UnKnowName';
    }
  }

  Future<void> fetchAssetsData() async {
    isLoading.value = true;
    try {
      final response =
          await apiService.get(Get.context!, ApiUtils.walletAssetsData);

      if (response.statusCode == 200) {
        assets.addAll(response.data['vault']['assets']);
        _logger.i("Api Successfully");
      } else {
        isLoading.value = false;
        _logger.i("Error in Api:-");
      }
    } catch (e) {
      isLoading.value = false;
      _logger.i("Error in Api:-");
    } finally {
      isLoading.value = false;
      _logger.i("Error in Api:-finally");
    }
  }
}
