import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_proton/modules/api_services/api_services.dart';
import 'package:real_proton/utils/apis.dart';
import 'package:real_proton/utils/widgets.dart';

class ChangePasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  RxBool isFormValid = false.obs,
      isPasswordShow = false.obs,
      isConfirmPasswordShow = false.obs,
      isLoading = false.obs,
      hasUppercase = false.obs,
      hasNumber = false.obs,
      hasSymbol = false.obs,
      hasMinLength = false.obs;
  RxString password = ''.obs;
  final ApiService apiServiceClass = ApiService();
  final Logger _logger = Logger();

  @override
  void onInit() {
    super.onInit();
    currentPasswordController.addListener(validateForm);
    newPasswordController.addListener(validateForm);
    confirmPasswordController.addListener(validateForm);
  }

  void validateForm() {
    isFormValid.value = currentPasswordController.text.isNotEmpty &&
        newPasswordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  void updatePassword(BuildContext context) {
    if (newPasswordController.text == currentPasswordController.text) {
      CustomWidgets.showError(
          context: context,
          message: "Current Password And New Password is Same");
      return;
    } else {
      Get.snackbar('Error', 'Passwords do not match');
    }
  }

  void passwordShow() {
    isPasswordShow.value = !isPasswordShow.value;
  }

  void confirmPasswordShow() {
    isConfirmPasswordShow.value = !isConfirmPasswordShow.value;
  }

  void validatePassword(String value) {
    password.value = value;
    hasUppercase.value = value.contains(RegExp(r'[A-Z]'));
    hasNumber.value = value.contains(RegExp(r'[0-9]'));
    hasSymbol.value = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    hasMinLength.value = value.length >= 8;
  }

  Future<void> apiChangePassword(BuildContext context) async {
    try {
      FocusScope.of(context).unfocus();
      if (newPasswordController.text == currentPasswordController.text) {
        CustomWidgets.showError(
            context: context,
            message:
                "Current Password and New Password should not be the same!");
        return;
      }
      if (newPasswordController.text != confirmPasswordController.text) {
        CustomWidgets.showError(
            context: context,
            message: "Current Password and Confirm Password do not match!");
        return;
      }
      final data = {
        "oldPassword": currentPasswordController.text.trim(),
        "newPassword": newPasswordController.text.trim(),
      };
      isLoading.value = true;
      final response = await apiServiceClass
          .post(Get.context!, ApiUtils.changePassword, data: data);
      if (response.statusCode == 200) {
        CustomWidgets.showSuccess(
            context: context, message: "Change Password successful");
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        Get.back();
      } else {
        isLoading.value = false;
        throw ApiException("Failed to fetch properties.");
      }
    } catch (e) {
      isLoading.value = false;
      _logger.i("Error :--${e.toString()}");
      CustomWidgets.showError(context: Get.context!, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
