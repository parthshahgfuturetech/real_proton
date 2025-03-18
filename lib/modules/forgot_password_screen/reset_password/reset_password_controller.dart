import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  var password = ''.obs;
  var confirmPassword = ''.obs;
  RxBool hasUppercase = false.obs,
   hasNumber = false.obs,
   hasSymbol = false.obs,
   hasMinLength = false.obs,
  isPasswordShow = false.obs,
  isConfirmPasswordShow = false.obs;
  final TextEditingController newPassordConroller = TextEditingController();
  final TextEditingController confirmPassordConroller = TextEditingController();

  void validatePassword(String value) {
    password.value = value;
    hasUppercase.value = value.contains(RegExp(r'[A-Z]'));
    hasNumber.value = value.contains(RegExp(r'[0-9]'));
    hasSymbol.value = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    hasMinLength.value = value.length >= 8;
  }

  void passwordShow(){
    isPasswordShow.value = !isPasswordShow.value;
  }

  void confirmPasswordShow(){
    isConfirmPasswordShow.value = !isConfirmPasswordShow.value;
  }
}