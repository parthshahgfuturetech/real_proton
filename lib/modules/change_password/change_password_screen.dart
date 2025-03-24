import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/change_password/change_password_controller.dart';
import 'package:real_proton/modules/forgot_password_screen/forgot_password_screen.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/strings.dart';
import 'package:real_proton/utils/theme.dart';
import 'package:real_proton/utils/widgets.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final ChangePasswordController controller =
      Get.put(ChangePasswordController());
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor:
            isDarkMode ? Colors.black : ColorUtils.scaffoldBackGroundLight,
        appBar: buildAppBar(isDarkMode),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CustomWidgets.customTextField(
                                controller: controller.currentPasswordController,
                                hintText: "Enter Your Current Password",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Switzer",
                                  color: isDarkMode
                                      ? ColorUtils.indicaterGreyLight
                                      : ColorUtils.appbarHorizontalLineDark,
                                ),
                                textInputAction: TextInputAction.next,
                                isDarkMode: isDarkMode),
                            buildForgotPassword(isDarkMode),
                            CustomWidgets.customTextField(
                              controller: controller.newPasswordController,
                              isDarkMode: isDarkMode,
                              hintText: "Enter Your New Password",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Switzer",
                                color: isDarkMode
                                    ? ColorUtils.indicaterGreyLight
                                    : ColorUtils.appbarHorizontalLineDark,
                              ),
                              isPassword: true,
                              isPasswordVisible: controller.isPasswordShow,
                              onTogglePassword: () => controller.passwordShow(),
                              onChangeValue: controller.validatePassword,
                            ),
                            CustomWidgets.customTextField(
                              controller: controller.confirmPasswordController,
                              isDarkMode: isDarkMode,
                              hintText: "Confirm Your New Password",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Switzer",
                                color: isDarkMode
                                    ? ColorUtils.indicaterGreyLight
                                    : ColorUtils.appbarHorizontalLineDark,
                              ),
                              isPassword: true,
                              isPasswordVisible: controller.isConfirmPasswordShow,
                              onTogglePassword: () => controller.confirmPasswordShow(),
                            ),
                            const SizedBox(height: 10),
                            buildPasswordStrengthIndicator(isDarkMode),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildValidationItem("At least 1 uppercase",
                                    controller.hasUppercase.value, isDarkMode),
                                buildValidationItem(
                                    "At least 1 number", controller.hasNumber.value, isDarkMode),
                                buildValidationItem(
                                    "At least 1 symbol", controller.hasSymbol.value, isDarkMode),
                                buildValidationItem("At least 8 characters",
                                    controller.hasMinLength.value, isDarkMode),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomWidgets.buildGetStartedButton(
                      text: 'Update Password',
                      textStyle: TextStyle(
                        color: isDarkMode
                            ? controller.isFormValid.value
                            ? ColorUtils.whiteColor
                            : ColorUtils.darkModeGrey2
                            : controller.isFormValid.value
                            ? ColorUtils.whiteColor
                            : ColorUtils.textFieldBorderColorLight,
                        fontFamily: "Switzer",
                        fontSize: 16,
                      ),
                      backgroundColor: isDarkMode
                          ? controller.isFormValid.value
                          ? ColorUtils.loginButton
                          : ColorUtils.appbarBackgroundDark
                          : controller.isFormValid.value
                          ? ColorUtils.loginButton
                          : ColorUtils.bottomBarLight,
                      onPressed: () => controller.isFormValid.value
                          ? controller.apiChangePassword(context)
                          : null,
                    ),
                  ],
                ),
                if (controller.isLoading.value)
                  Container(
                    color: Colors.black.withValues(alpha: 0.7),
                    child: CustomWidgets.buildLoader(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordStrengthIndicator(bool isDarkMode) {
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
            buildStrengthStep(
                1, strength >= 1 ? getStrengthColor() : Colors.grey),
            const SizedBox(width: 5),
            buildStrengthStep(
                2, strength >= 2 ? getStrengthColor() : Colors.grey),
            const SizedBox(width: 5),
            buildStrengthStep(
                3, strength >= 3 ? getStrengthColor() : Colors.grey),
            const SizedBox(width: 5),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          getStrengthText(),
          style: TextStyle(
            color: isDarkMode
                ? ColorUtils.whiteColor
                : ColorUtils.appbarBackgroundDark,
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

  Widget buildValidationItem(String text, bool isValid, isDarkMode) {
    return Row(
      children: [
        Image.asset(
          isValid ? ImageUtils.strongPassword : ImageUtils.weekPassword,
          fit: BoxFit.fill,
          height: 21,
          width: 21,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: "Switzer",
            fontWeight: FontWeight.w400,
            color: ColorUtils.forgotPasswordTextLight,
          ),
        ),
      ],
    );
  }

  Widget buildForgotPassword(bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ForgotPasswordScreen());
      },
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          StringUtils.forgotPassword,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Switzer',
            fontWeight: FontWeight.w500,
            color: isDarkMode
                ? ColorUtils.textFieldBorderColorDark
                : ColorUtils.darkModeGrey2,
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldEmailAndPassword({
    String text = "",
    required ChangePasswordController changePasswordController,
    required TextEditingController controller,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: isDarkMode ? ColorUtils.whiteColor : ColorUtils.blackColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: controller,
            textInputAction:
                controller == changePasswordController.confirmPasswordController
                    ? TextInputAction.done
                    : TextInputAction.next,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1),
                borderSide: BorderSide(
                  color: ColorUtils.loginButton,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1),
                borderSide: BorderSide(
                  color: isDarkMode
                      ? ColorUtils.textFieldBorderColorDark
                      : ColorUtils.textFieldBorderColorLight,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1),
                borderSide: BorderSide(
                  color: isDarkMode
                      ? ColorUtils.textFieldBorderColorDark
                      : ColorUtils.textFieldBorderColorLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(bool isDarkMode) {
    return AppBar(
      scrolledUnderElevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          color: isDarkMode
              ? ColorUtils.appbarHorizontalLineDark
              : ColorUtils.appbarHorizontalLineLight,
          height: 1.5,
        ),
      ),
      backgroundColor:
          isDarkMode ? ColorUtils.appbarBackgroundDark : Colors.white,
      title: buildAppBarTitle("Change Password", isDarkMode),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: isDarkMode ? Colors.white : ColorUtils.appbarBackgroundDark,
          size: 15,
        ),
        onPressed: () {
          Get.back(); // Navigate back
        },
      ),
    );
  }

  Widget buildAppBarTitle(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        color: isDarkMode
            ? ColorUtils.indicaterGreyLight
            : ColorUtils.appbarHorizontalLineDark,
        fontWeight: FontWeight.w500,
        fontFamily: "Switzer",
        fontSize: 20,
      ),
    );
  }
}
