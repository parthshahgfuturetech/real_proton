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
      amount = 0.00.obs;
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
    double rpAmount = CustomWidgets.weiToRP(blockChainController.tokenPrice.value);
    if (value.isNotEmpty) {
      final double? number = double.tryParse(value);
      if (number != null) {
        amount.value = (number / rpAmount);
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
      };

      final response = await apiServiceClass.post(Get.context!,
          ApiUtils.stripeAPi,data: data);

      if(response.statusCode == 200){
        _logger.i("Api successful and Stripe api is Step 1");
        final paymentIntent = response.data['payment']['client_secret'];

        try {
          await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent,
              customFlow: true,
              merchantDisplayName: 'Demo Merchant',
            ),
          );

          _logger.i("Api successful and Stripe api is Step 2");

          await Stripe.instance.presentPaymentSheet();
          await Stripe.instance.confirmPaymentSheetPayment();

          showSuccessScreen();
          _logger.i("Payment successful!");

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

  void showSuccessScreen() {
    Get.to(() => CompleteAndFailScreen());

    Future.delayed(Duration(seconds: 3), () {
      Get.back();
    });
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: Get.context!,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      Text("Payment Successfull"),
                    ],
                  ),
                ],
              ),
            ));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        // paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: Get.context!,
          builder: (_) => const AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }


  void selectCurrency(String currency) {
    selectedCurrency.value = currency;
    isDropdownOpen.value = false;
  }


}
