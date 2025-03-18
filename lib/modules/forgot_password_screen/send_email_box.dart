import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/login_screen/login_screen.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/strings.dart';
import 'package:real_proton/utils/theme.dart';

import 'reset_password/reset_password.dart';

class EmailSentScreen extends StatelessWidget {
  final String email;
  final void Function()? onPressButton;

  EmailSentScreen({super.key, required this.email, this.onPressButton});

  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            border: Border.all(
              width: 2,
              color: isDarkMode
                  ? ColorUtils.appbarHorizontalLineDark
                  : ColorUtils.appbarHorizontalLineLight,
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.7)
                    : Colors.grey.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildBody1(isDarkMode),
              Container(
                width: double.infinity,
                height: 2,
                color: isDarkMode
                    ? ColorUtils.appbarHorizontalLineDark
                    : ColorUtils.appbarHorizontalLineLight,
              ),
              buildSendButton(isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody1(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          buildFirstImage(isDarkMode),
          const SizedBox(height: 16),
          buildTitle(isDarkMode),
          const SizedBox(height: 8),
          buildEmailAndSubTitle(isDarkMode),
        ],
      ),
    );
  }

  Widget buildSendButton(bool isDarkMode) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressButton,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorUtils.loginButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        child: Text(
          "Go Back",
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildEmailAndSubTitle(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              StringUtils.checkMailSubTitle1,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode
                    ? ColorUtils.forgotPasswordTextDark
                    : ColorUtils.forgotPasswordTextLight,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "$email\n",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Text(
          StringUtils.checkMailSubTitle2,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode
                ? ColorUtils.forgotPasswordTextDark
                : ColorUtils.forgotPasswordTextLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildTitle(bool isDarkMode) {
    return Text(
      StringUtils.checkMail,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget buildFirstImage(bool isDarkMode) {
    return Image.asset(
      isDarkMode ? ImageUtils.emailDark : ImageUtils.emailLight,
      height: 80,
    );
  }
}
