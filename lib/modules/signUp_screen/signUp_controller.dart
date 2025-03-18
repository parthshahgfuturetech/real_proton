
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_proton/modules/api_services/api_services.dart';
import 'package:real_proton/modules/complete_and_fail/complete_screen.dart';
import 'package:real_proton/modules/login_screen/login_screen.dart';
import 'package:real_proton/utils/apis.dart';
import 'package:real_proton/utils/widgets.dart';

class SignupController extends GetxController {
  RxInt currentStep = 1.obs;
  RxString selectedOption = ''.obs,
      varifationsId = ''.obs,
      email = ''.obs, password = ''.obs,
   confirmPassword = ''.obs,
      mobileNumber = ''.obs,
      selectedNetwork = ''.obs;
  RxBool isMenuOpen = false.obs,
      isCodeSend = false.obs,
      isLoading = false.obs,
      isGoogleLogin = false.obs,
      isPasswordShow = false.obs,
      isConfirmPasswordShow = false.obs,
   hasUppercase = false.obs,
   hasNumber = false.obs,
   hasSymbol = false.obs,
   hasMinLength = false.obs;
  final FocusNode focusNode = FocusNode();
  final Logger _logger = Logger();
  final ApiService apiServiceClass = ApiService();
  ValueNotifier<String> countryCode = ValueNotifier("+1");
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailOtpController = TextEditingController();
  final mobileOtpController = TextEditingController();

  void passwordShow(){
    isPasswordShow.value = !isPasswordShow.value;
  }

  void confirmPasswordShow(){
    isConfirmPasswordShow.value = !isConfirmPasswordShow.value;
  }

  void validatePassword(String value) {
    password.value = value;
    hasUppercase.value = value.contains(RegExp(r'[A-Z]'));
    hasNumber.value = value.contains(RegExp(r'[0-9]'));
    hasSymbol.value = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    hasMinLength.value = value.length >= 8;
  }

  // Future<void> deviceInfo1() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //   print('Android version ${androidInfo.version.release}');
  //   print('Android Id ${androidInfo.id}');
  //   print('Android Devices ${androidInfo.device}');
  //   print('Android Model ${androidInfo.model}');
  //   print('Android brand ${androidInfo.brand}');
  //   print('Android host ${androidInfo.host}');
  // }

  final List<Map<String, String>> networks = [
    {
      'name': 'Non Us',
    },
    {
      'name': 'Accredited',
    },
    {
      'name': 'Institutional',
    },
  ];

  void showSuccessScreen(BuildContext context) {
    Get.to(() => CompleteScreen(name: firstNameController.text,));

    Future.delayed(Duration(seconds: 3), () {
      Get.offAll(LoginScreen());
    });
  }

  bool _validateInputs(BuildContext context) {
    if (firstNameController.text.trim().isEmpty) {
      CustomWidgets.showInfo(
          context: context, message: "First name is required");
      return false;
    }

    if (lastNameController.text.trim().isEmpty) {
      CustomWidgets.showInfo(
          context: context, message: "Last name is required");
      return false;
    }

    if (emailController.text.trim().isEmpty ||
        !GetUtils.isEmail(emailController.text.trim())) {
      CustomWidgets.showError(
          context: context, message: "A valid email address is required");
      return false;
    }

    if (mobileController.text.trim().isEmpty ||
        mobileController.text.trim().length < 10) {
      CustomWidgets.showError(
          context: context, message: "A valid mobile number is required");
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      CustomWidgets.showError(
          context: context, message: "Password is required");
      return false;
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      CustomWidgets.showError(
          context: context, message: "Passwords do not match");
      return false;
    }

    return true;
  }

  Future<void> signUp(BuildContext context) async {

    if (!_validateInputs(context)) return;
    final data = {
      "email": emailController.text.trim(),
      "mobileNumber": "${countryCode.value}${mobileController.text.trim()}",
      "password": passwordController.text.trim(),
      "acceptedTerms": true,
      "firstName": firstNameController.text.trim(),
      "lastName": lastNameController.text.trim(),
      "countryCode": countryCode.value,
    };
    FocusScope.of(context).unfocus();
    isLoading.value = true;
    try {
      final response =
          await apiServiceClass.post(context, ApiUtils.signUpAPi, data: data);

      if (response != null && response.statusCode == 200) {
        showSuccessScreen(context);
        CustomWidgets.showSuccess(
            context: context, message: "Signup successful");
      } else {
        CustomWidgets.showError(
            context: context,
            message: response.data['message'] ?? "Signup failed");
      }
    } catch (e) {
      CustomWidgets.showError(
          context: context, message: "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

}
