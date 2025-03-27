import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/modules/api_services/api_services.dart';
import 'package:real_proton/modules/complete_and_fail/complete_and_fail_screen.dart';
import 'package:real_proton/utils/apis.dart';
import 'package:real_proton/utils/widgets.dart';

class SaleController extends GetxController {
  RxString selectedCurrency = 'USDT'.obs, selectedToken = 'RP'.obs;
  RxDouble usdtBalance = 123.00.obs,
      rpBalance = 125.00.obs,
      amount = 0.00.obs,rePrice = 0.0.obs;
  RxBool isDropdownOpen = false.obs,
        isLoading = false.obs,
      isShowButton = false.obs;
  final ApiService apiServiceClass = ApiService();
  final Logger _logger = Logger();
  final TextEditingController textController = TextEditingController();
  final List<String> currencies = ['USDT', 'USDC', 'USD'].obs;
  final ActionSliderController actionController = ActionSliderController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void calculate(String value) {
    if (value.isNotEmpty) {
      final double? number = double.tryParse(value);
      if (number != null) {
        amount.value = (number / rePrice.value);
      } else {
        amount.value = 0.0;
      }
    } else {
      amount.value = 0.0;
    }
  }

  Future<void> stripeApiCall() async{
    try{

      isLoading.value = true;

      final data = {
        "amount": textController.text,
        "walletAddress": profileController.walletAddress.value,
        "currency": "usd",
        "rpAmount": amount.value,
        "chainId":"67d136eca768a1161ead69bb",
      };

      final response = await apiServiceClass.post(Get.context!,
          ApiUtils.stripeAPi,data: data);

      if(response.statusCode == 200){
        _logger.i("Api successful and Stripe api is Step 1");
        final paymentIntent = response.data['data']['client_secret'];
        final idString = response.data['data']['id'];

        try {
          await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent,
              customFlow: true,
              merchantDisplayName: 'Demo Merchant',
            ),
          );

          _logger.i("Api successful and Stripe api is Step 2");

          await Stripe.instance.presentPaymentSheet().then((val) async {
            textController.clear();
            amount.value=0;
            // await Future.delayed(Duration(milliseconds: 300)); // Give time for UI update
            Future.delayed(const Duration(milliseconds: 50), () {
              stripeSuccessApi(idString);();
            });

          });

        } catch (e) {
          if (e is StripeException) {
            _logger.e("StripeException: ${e.error.message}");
          } else {
            _logger.e("Unexpected error: $e");
          }
        }

      }else{
        _logger.e("Unexpected error: Stripe Error");
      }

    }catch(e){
      isLoading.value = false;
      _logger.e("Unexpected error: Stripe Error");
    }finally{
      isLoading.value = false;
    }
  }

  Future<void> stripeSuccessApi(String id) async {
    isLoading.value = true;
    try{
      final data = {
        "id":id,
        "payment_method":"pm_card_visa",
      };

      final response = await apiServiceClass.post(Get.context!,
          ApiUtils.stripeSuccessAPi,data: data);

      if(response.statusCode == 200){
        final responseJson = response.data;

        print("stripeSuccessApi==> ${responseJson}");

        showSuccessScreen(responseJson);
        _logger.i("Api Successful");
      }else{
        isLoading.value = false;
        _logger.i("Error in api");
      }

    }catch(e){
      isLoading.value = false;
      _logger.i("Error $e");
    }finally{
      isLoading.value = false;
    }
  }

  void showSuccessScreen(dynamic responseJson) {
    if (responseJson != null && responseJson is Map<String, dynamic>) {
      Get.to(() => CompleteAndFailScreen(responseJson: responseJson));
    } else {
      print("Error: responseJson is null or not a valid Map");
    }
  }

  void selectCurrency(String currency) {
    selectedCurrency.value = currency;
    isDropdownOpen.value = false;
  }


}
