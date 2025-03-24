import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/forgot_password_screen/forgot_password_screen.dart';
import 'package:real_proton/modules/login_screen/login_controller.dart';
import 'package:real_proton/modules/signUp_screen/signUp_screen.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/strings.dart';
import 'package:real_proton/utils/theme.dart';
import 'package:real_proton/utils/widgets.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    final ThemeController themeController = Get.find();
    return Obx(
      () {
        bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
        final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
            (themeController.themeMode.value == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);
        return SafeArea(
          top: false,
          child: Scaffold(
            appBar: buildAppBar(isDarkMode),
            backgroundColor:
                isDarkMode ? Colors.black : ColorUtils.scaffoldBackGroundLight,
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              buildLoginText(isDarkMode),
                              const SizedBox(height: 10),
                              CustomWidgets.customTextField(
                                controller: loginController.emailController,
                                hintText: StringUtils.email,
                                isDarkMode: isDarkMode,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 16),
                              CustomWidgets.customTextField(
                                controller: loginController.passwordController,
                                hintText: StringUtils.password,
                                isDarkMode: isDarkMode,
                                isPassword: true,
                                isPasswordVisible: loginController.isPasswordShow,
                                onTogglePassword: () => loginController.passwordShow(),
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                              ),
                              const SizedBox(height: 10),
                              buildForgotPassword(isDarkMode),
                            ],
                          ),
                        ),
                      ),
                      if (!isKeyboardVisible) ...[
                        CustomWidgets.buildGetStartedButton(
                            onPressed: loginController.isLoading.value
                                ? null
                                : () {
                                    loginController.login(context);
                                  },
                            text: StringUtils.login),
                        const SizedBox(height: 10),
                        buildGoogleButton(isDarkMode, context,loginController),
                        buildHaveAccountButtons(isDarkMode,loginController),
                      ] else ...[
                        CustomWidgets.buildGetStartedButton(
                            onPressed: loginController.isLoading.value
                                ? null
                                : () {
                                    loginController.login(context);
                                  },
                            text: StringUtils.login),
                        buildHaveAccountButtons(isDarkMode,loginController),
                      ],
                    ],
                  ),
                ),
                if (loginController.isLoading.value)
                  Container(
                    color: Colors.black.withValues(alpha: 0.7),
                    child: CustomWidgets.buildLoader(),
                  ),
                CustomWidgets.showNetworkStatus(isDarkMode),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildGoogleButton(bool isDarkMode, BuildContext context,loginController) {
    return GestureDetector(
      onTap: () async {
        await loginController.logInWithGoogle(context);
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            border: Border.all(
          color: isDarkMode
              ? ColorUtils.appbarHorizontalLineDark
              : ColorUtils.darkModeGrey2,
          width: 1,
        )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageUtils.google,
              height: 25,
              width: 25,
            ),
            const SizedBox(width: 10),
            Text(
              StringUtils.googleSign,
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Switzer",
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : ColorUtils.blackColor,
              ),
            ),
          ],
        ),
      ),
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
      centerTitle: true,
      backgroundColor:
          isDarkMode ? ColorUtils.appbarBackgroundDark : Colors.white,
    );
  }

  Widget buildLoginText(bool isDarkMode) {
    return Text(
      StringUtils.login,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
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
            color: isDarkMode ? ColorUtils.whiteColor : ColorUtils.blackColor,
          ),
        ),
      ),
    );
  }

  Widget buildHaveAccountButtons(bool isDarkMode,loginController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            StringUtils.dontHaveAccount,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? ColorUtils.whiteColor : ColorUtils.blackColor,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Get.to(() => SignupScreen());
              loginController.emailController.text = '';
              loginController.passwordController.text = '';
              FocusScope.of(Get.context!).unfocus();
            },
            child: const Text(
              StringUtils.signUp,
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
}
