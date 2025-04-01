import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/api_services/api_services.dart';
import 'package:real_proton/modules/forgot_password_screen/send_email_box.dart';
import 'package:real_proton/utils/apis.dart';
import 'package:real_proton/utils/widgets.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final RxString errorText = ''.obs;
  var isLoading = false.obs;
  final ApiService apiServiceClass = ApiService();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (Get.isBottomSheetOpen!) {
      Get.back();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  bool validateEmail(BuildContext context) {
    final email = emailController.text.trim();
    if (emailController.text.trim().isEmpty ||
        !GetUtils.isEmail(emailController.text.trim())) {
      CustomWidgets.showError(
          context: context, message: "A valid email address is required");
      return false;
    }
    if (email.isEmpty) {
      errorText.value = "Email address cannot be empty.";
      return false;
    } else if (!GetUtils.isEmail(email)) {
      errorText.value = "Enter a valid email address.";
      return false;
    }
    errorText.value = '';
    return true;
  }

  Future<void> forgotPassword(BuildContext context) async {
    final data = {
      "email": emailController.text.trim(),
    };
    FocusScope.of(context).unfocus();
      isLoading.value = true;
    try{
      final response = await apiServiceClass.post(context, ApiUtils.forgotPasswordAPi,data: data);

      if (response != null && response.statusCode == 200) {
        CustomWidgets.showSuccess(
            context: context, message: "Email send Successfully");
        Future.delayed(Duration(seconds: 2),(){
          buildShowDialogBox(context);
        });
      } else {
        isLoading.value = false;
        CustomWidgets.showError(
            context: context,
            message: response.data['message'] ?? "Email send failed");
      }
    }catch(e){
      isLoading.value = false;
      CustomWidgets.showError(
          context: context, message: "An error occurred: $e");
    }finally{
      isLoading.value = false;
    }

  }

  void buildShowDialogBox(BuildContext context) {
    String email = emailController.text.trim();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black12.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: EmailSentScreen(email: email),
        );
      },
    );
  }


}
