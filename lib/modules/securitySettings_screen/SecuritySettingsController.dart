import 'package:get/get.dart';

class SecuritySettingsController extends GetxController {
  var isBiometricEnabled = false.obs; // Default switch state

  void toggleBiometric() {
    isBiometricEnabled.value = !isBiometricEnabled.value;
  }
}
