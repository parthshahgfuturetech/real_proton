import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/shared_preference.dart';
import '../../utils/widgets.dart';
import '../create_your_pin_screen/password_reset_successfully_screen.dart';

class ConfirmYourPinController extends GetxController {
  var confirmPin = ''.obs;
  final int pinLength = 4;

  Future<String?> getSavedPin() async {
    return SharedPreferencesUtil.getString(SharedPreferenceKey.createPin);
  }

  Future<void> verifyPin() async {
    final savedPin = await getSavedPin();

    // Debugging prints
    print("Entered PIN: ${confirmPin.value}");
    print("Saved PIN: $savedPin");

    if (confirmPin.value.length == pinLength) {
      if (confirmPin.value == savedPin) {
        CustomWidgets.showSuccess(
            context: Get.context!, message: "Success");

        Future.delayed(Duration(seconds: 2), () => Get.off(PasswordResetSuccessfullyScreen()));
      } else {
        CustomWidgets.showError(
            context: Get.context!, message: "PINs do not match!");

        confirmPin.value = "";
      }
    }
  }

  void addDigit(String digit) {
    if (confirmPin.value.length < pinLength) {
      confirmPin.value += digit;
      if (confirmPin.value.length == pinLength) {
        verifyPin();
      }
    }
  }

  void deleteDigit() {
    if (confirmPin.value.isNotEmpty) {
      confirmPin.value = confirmPin.value.substring(0, confirmPin.value.length - 1);
    }
  }
}
