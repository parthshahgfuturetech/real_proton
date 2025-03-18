import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/complete_and_fail/complete_screen.dart';
import 'package:real_proton/modules/forgot_password_screen/reset_password/reset_password_controller.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/strings.dart';
import 'package:real_proton/utils/theme.dart';
import 'package:real_proton/utils/widgets.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final ThemeController themeController = Get.find();
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          isDarkMode ? Colors.black : ColorUtils.scaffoldBackGroundLight,
      appBar: buildAppBar(isDarkMode),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(
          () {
            bool isValid = controller.hasUppercase.value &&
                controller.hasNumber.value &&
                controller.hasSymbol.value &&
                controller.hasMinLength.value &&
                controller.password.value == controller.confirmPassword.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringUtils.reset_password,
                  style: TextStyle(
                    fontSize: 24,
                    color: isDarkMode
                        ? ColorUtils.whiteColor
                        : ColorUtils.blackColor,
                  ),
                ),
                Text(
                  StringUtils.reset_password_sub_title2,
                  style: TextStyle(
                    color: isDarkMode
                        ? ColorUtils.darkModeGrey2
                        : ColorUtils.textFieldBorderColorDark,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                CustomWidgets.customTextField(
                  controller: controller.newPassordConroller,
                  hintText: "Create New Password",
                  isDarkMode: isDarkMode,
                  isPassword: true,
                  isPasswordVisible: controller.isPasswordShow,
                  onTogglePassword: () => controller.passwordShow(),
                  onChangeValue: controller.validatePassword,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 10),
                CustomWidgets.customTextField(
                  controller: controller.confirmPassordConroller,
                  hintText: "Confirm New Password",
                  isDarkMode: isDarkMode,
                  isPassword: true,
                  isPasswordVisible: controller.isConfirmPasswordShow,
                  onTogglePassword: () => controller.confirmPasswordShow(),
                  onChangeValue: (value) {
                    controller.confirmPassword.value = value;
                  },
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 20),
                buildPasswordStrengthIndicator(controller, isDarkMode),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildValidationItem(
                        "At least 1 uppercase", controller.hasUppercase.value),
                    buildValidationItem(
                        "At least 1 number", controller.hasNumber.value),
                    buildValidationItem(
                        "At least 1 symbol", controller.hasSymbol.value),
                    buildValidationItem(
                        "At least 8 characters", controller.hasMinLength.value),
                  ],
                ),
                const Spacer(),
                buildSendButton(isValid,isDarkMode),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildNewAndConfirmPassword({
    required bool isDarkMode,
    required String title,
    required void Function(String) onChange,
    required TextEditingController textcontroller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: textcontroller,
          textInputAction: textcontroller == controller.newPassordConroller
              ? TextInputAction.next : TextInputAction.done,
          cursorColor:
              isDarkMode ? ColorUtils.whiteColor : ColorUtils.blackColor,
          onChanged: onChange,
          style: TextStyle(
            color: isDarkMode ? ColorUtils.whiteColor : ColorUtils.blackColor,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDarkMode
                    ? ColorUtils.textFieldBorderColorDark
                    : ColorUtils.textFieldBorderColorLight,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorUtils.loginButton),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSendButton(bool isValid, bool isDarkMode) {
    return ElevatedButton(
      onPressed: isValid ? () {
        Get.to(()=>const CompleteScreen(name: "",));
      } : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorUtils.loginButton,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      child: Center(
        child: Text(
          StringUtils.changePassword,
          style: TextStyle(
            fontSize: 18,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildPasswordNewButton(bool isValid) {
    return ElevatedButton(
      onPressed: isValid ? () => print("Password Changed") : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isValid ? Colors.orange : Colors.grey,
      ),
      child: const Text("Change Password"),
    );
  }

  AppBar buildAppBar(bool isDarkMode) {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          color: isDarkMode
              ? ColorUtils.appbarHorizontalLineDark
              : ColorUtils.appbarHorizontalLineLight,
          height: 1.5,
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isDarkMode
                ? ImageUtils.lendingPageLogoDark
                : ImageUtils.lendingPageLogoLight,
            height: 40,
          ),
        ],
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 18,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        onPressed: () {
          Get.back();
          Get.back();
        },
      ),
      centerTitle: true,
      backgroundColor:
          isDarkMode ? ColorUtils.appbarBackgroundDark : Colors.white,
      iconTheme: IconThemeData(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  Widget buildPasswordStrengthIndicator(
      ResetPasswordController controller, bool isDarkMode) {
      int strength = 0;
      if (controller.hasUppercase.value) strength++;
      if (controller.hasNumber.value) strength++;
      if (controller.hasSymbol.value) strength++;
      if (controller.hasMinLength.value) strength++;

      String getStrengthText() {
        if (strength == 4) {
          return "Strong";
        } else if (strength == 3) {
          return "Medium";
        } else {
          return "Weak";
        }
      }

      Color getStrengthColor() {
        if (strength == 4) {
          return Colors.green;
        } else if (strength == 3) {
          return Colors.orange;
        } else {
          return Colors.red;
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 5),
              buildStrengthStep(1, strength >= 1 ? getStrengthColor() : Colors.grey),
              const SizedBox(width: 5),
              buildStrengthStep(2, strength >= 2 ? getStrengthColor() : Colors.grey),
              const SizedBox(width: 5),
              buildStrengthStep(3, strength >= 3 ? getStrengthColor() : Colors.grey),
              const SizedBox(width: 5),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            getStrengthText(),
            style: TextStyle(
              color: isDarkMode ? ColorUtils.whiteColor : ColorUtils.appbarBackgroundDark,
              fontSize: 12,
              fontFamily: "Switzer",
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );

  }

  Widget buildStrengthStep(int stepNumber, Color color) {
    return Expanded(
      child: Container(
        height: 5,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget buildValidationItem(String text, bool isValid) {
    return Row(
      children: [
        Image.asset(
          isValid ?  ImageUtils.strongPassword: ImageUtils.weekPassword,
          fit: BoxFit.fill,
          height: 21,
          width: 21,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontFamily: "Switzer",
            fontWeight: FontWeight.w400,
            color: ColorUtils.forgotPasswordTextLight,
          ),
        ),
      ],
    );
  }
}
