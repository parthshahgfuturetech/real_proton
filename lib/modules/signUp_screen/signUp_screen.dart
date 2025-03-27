import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/signUp_screen/signUp_controller.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/strings.dart';
import 'package:real_proton/utils/theme.dart';
import 'package:real_proton/utils/widgets.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final ThemeController themeController = Get.find();
  final SignupController signUpController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    // signUpController.deviceInfo1();
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : const Color(0xffF2F2F2),
        appBar: buildAppBar(signUpController, isDarkMode),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildScreens(context, signUpController, isDarkMode),
                              buildBasicDetailsFooterText(isDarkMode),
                              SafeArea(
                                child: CustomWidgets.buildGetStartedButton(
                                  onPressed: () {
                                    signUpController.signUp(context);
                                  },
                                  text: "Submit",
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  if (signUpController.isLoading.value)
                    Container(
                      color: Colors.black.withValues(alpha: 0.7),
                      child: CustomWidgets.buildLoader(),
                    ),
                  CustomWidgets.showNetworkStatus(isDarkMode),
                ],
              ),
            ),
        ),
      ),
    );
  }

  AppBar buildAppBar(SignupController controller, bool isDarkMode) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor:
          isDarkMode ? ColorUtils.appbarBackgroundDark : Colors.white,
      leading: signUpController.isGoogleLogin.value
          ? const SizedBox.shrink()
          : IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  size: 18,
                  color: isDarkMode
                      ? ColorUtils.whiteColor
                      : ColorUtils.blackColor),
              onPressed: () {
                Get.back();
                FocusScope.of(Get.context!).unfocus();
              },
            ),
      centerTitle: true,
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
    );
  }

  Widget buildScreens(
      BuildContext context, SignupController controller, bool isDarkMode) {
    return Column(
      children: [
        buildBasicDetails(controller, isDarkMode),
        const SizedBox(height: 10),
        buildPasswordStrengthIndicator(controller, isDarkMode),
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
    );
  }

  Widget buildTitle(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
          color: isDarkMode ? ColorUtils.whiteColor : ColorUtils.blackColor,
          fontSize: 22,
          fontWeight: FontWeight.w600),
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

  Widget buildPasswordStrengthIndicator(
      SignupController controller, bool isDarkMode) {
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

  Widget buildBasicDetails(SignupController controller, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle("Basic Details", isDarkMode),
        const SizedBox(height: 20),
        CustomWidgets.customTextField(
            controller: controller.firstNameController,
            hintText: "First Name",
            textInputAction: TextInputAction.next,
            isDarkMode: isDarkMode),
        const SizedBox(height: 10),
        CustomWidgets.customTextField(
            controller: controller.lastNameController,
            hintText: "Last Name",
            textInputAction: TextInputAction.next,
            isDarkMode: isDarkMode),
        const SizedBox(height: 10),
        CustomWidgets.customTextField(
            controller: controller.emailController,
            hintText: "Email",
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            isDarkMode: isDarkMode),
        const SizedBox(height: 10),
        buildMobileNumberField(
          signUpController: controller,
          isDarkMode: isDarkMode,
        ),
        const SizedBox(height: 10),
        CustomWidgets.customTextField(
          controller: controller.passwordController,
          hintText: "Create Password",
          isDarkMode: isDarkMode,
          isPassword: true,
          isPasswordVisible: signUpController.isPasswordShow,
          onTogglePassword: () => signUpController.passwordShow(),
          onChangeValue: controller.validatePassword,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 10),
        CustomWidgets.customTextField(
          controller: controller.confirmPasswordController,
          hintText: "Confirm Password",
          isDarkMode: isDarkMode,
          isPassword: true,
          isPasswordVisible: signUpController.isConfirmPasswordShow,
          onTogglePassword: () => signUpController.confirmPasswordShow(),
          onChangeValue: (value) {
            controller.confirmPassword.value = value;
          },
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Center buildBasicDetailsFooterText(bool isDarkMode) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            StringUtils.by_continuing_you_accept_our,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? ColorUtils.whiteColor : ColorUtils.blackColor,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              StringUtils.terms_of_use,
              style: TextStyle(
                fontSize: 14,
                color: ColorUtils.loginButton,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMobileNumberField({
    Widget? suffixIcon,
    BoxConstraints? boxDecoration,
    required SignupController signUpController,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mobile Number",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? ColorUtils.appbarBackgroundDark
                  : ColorUtils.whiteColor,
              border: Border.all(
                color: signUpController.focusNode.hasFocus
                    ? ColorUtils.loginButton
                    : (isDarkMode
                    ? Colors.grey.shade700
                    : Colors.grey.shade400),
              ),
            ),
            child: Row(
              children: [
                CountryCodePicker(
                  onChanged: (countryCode) {
                    signUpController.countryCode.value =
                        countryCode.dialCode ?? "+1";
                    print(
                        "Selected Country Code: ${signUpController.countryCode.value}");
                  },
                  boxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: isDarkMode
                        ? ColorUtils.blackColor
                        : ColorUtils.whiteColor,
                  ),
                  backgroundColor: isDarkMode
                      ? ColorUtils.whiteColor
                      : ColorUtils.blackColor,
                  flagWidth: 20,
                  initialSelection: signUpController.countryCode.value,
                  showFlag: true,
                  showDropDownButton: true,
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  searchDecoration: InputDecoration(
                    hintText: "Search Country code",
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                  textStyle: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: signUpController.mobileController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    focusNode: signUpController.focusNode,
                    decoration: InputDecoration(
                      counterText: "",
                      suffixIcon: suffixIcon,
                      suffixIconConstraints: boxDecoration,
                      hintText: "Enter your mobile number",
                      hintStyle: TextStyle(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                    cursorColor: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
