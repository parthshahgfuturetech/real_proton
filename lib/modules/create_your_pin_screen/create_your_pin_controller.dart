import 'package:get/get.dart';
import '../../utils/shared_preference.dart';
import '../confirm_your-pin/confirm_your_pin.dart';

class CreateYourPinController extends GetxController {
  var pin = ''.obs;
  final int pinLength = 4;

  void addDigit(String digit) {
    if (pin.value.length < pinLength) {
      pin.value += digit;
      if (pin.value.length == pinLength) {
        savePin();
      }
    }
  }

  void deleteDigit() {
    if (pin.value.isNotEmpty) {
      pin.value = pin.value.substring(0, pin.value.length - 1);
    }
  }

  Future<void> savePin() async {
    await SharedPreferencesUtil.setString('createPin', pin.value);
    Get.to(() => ConfirmYourPin());
  }
}
