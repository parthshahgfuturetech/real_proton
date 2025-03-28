import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:real_proton/firebase_options.dart';
import 'package:real_proton/modules/blockChain/blockChain_controller.dart';
import 'package:real_proton/modules/botton_bar_options/bottom_bar/bottomBarController.dart';
import 'package:real_proton/modules/botton_bar_options/bottom_bar/bottom_bar.dart';
import 'package:real_proton/modules/botton_bar_options/profile/profile_controller.dart';
import 'package:real_proton/modules/botton_bar_options/sale/sale_controller.dart';
import 'package:real_proton/modules/botton_bar_options/wallet/transfer_fund__screen/transfer_fund_controller.dart';
import 'package:real_proton/modules/botton_bar_options/wallet/wallet_controller.dart';
import 'package:real_proton/modules/complete_and_fail/complete_and_fail_controller.dart';
import 'package:real_proton/modules/forgot_password_screen/reset_password/reset_password.dart';
import 'package:real_proton/modules/lending_screen/lending_screen.dart';
import 'package:real_proton/modules/login_screen/login_controller.dart';
import 'package:real_proton/modules/property_details/property_details_controller.dart';
import 'package:real_proton/modules/signUp_screen/signUp_controller.dart';
import 'package:real_proton/utils/shared_preference.dart';
import 'package:real_proton/utils/strings.dart';
import 'package:real_proton/utils/theme.dart';
import 'package:real_proton/utils/widgets.dart';

import 'SplashScreen.dart';
import 'modules/confirm_your-pin/confirm_your_pin.dart';
import 'modules/create_your_pin_screen/create_your_pin_screen.dart';
import 'modules/create_your_pin_screen/password_reset_successfully_screen.dart';
import 'modules/reset_your_pin/reset_your_otp.dart';
import 'modules/reset_your_pin/reset_your_pin.dart';
import 'modules/securitySettings_screen/security_settings_screen.dart';

final BottomBarController bottomBarController = Get.put(BottomBarController());
final ProfileController profileController = Get.put(ProfileController());
final SaleController saleController = Get.put(SaleController());
final CompleteAndFailController completeAndFailController =
    Get.put(CompleteAndFailController());
final WalletController walletController = Get.put(WalletController());
final TransferFundsController transferFundController =
    Get.put(TransferFundsController());
final PropertyDetailsController propertyDetailsController =
    Get.put(PropertyDetailsController());
final BlockChainController blockChainController = Get.put(BlockChainController());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = StringUtils.publishableKey;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  CustomWidgets.monitorNetwork();
  await SharedPreferencesUtil.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final themeController = Get.put(ThemeController());

  // Get.put(ThemeController());
  await themeController.loadThemeMode(); // Load theme before app starts

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeController.themeMode.value,
          home: SplashScreen(),  // Ensures the correct start screen

        );
      },
    );
  }


}


