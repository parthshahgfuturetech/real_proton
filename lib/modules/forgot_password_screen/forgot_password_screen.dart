import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/forgot_password_screen/forgot_password_controller.dart';
import 'package:real_proton/modules/forgot_password_screen/send_email_box.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/strings.dart';
import 'package:real_proton/utils/theme.dart';
import 'package:real_proton/utils/widgets.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final ThemeController themeController = Get.find();
  final ForgotPasswordController controller =
      Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: isDarkMode
            ? ColorUtils.blackColor
            : ColorUtils.scaffoldBackGroundLight,
        appBar: buildAppBar(isDarkMode),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            ()=> Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitle(isDarkMode),
                    const SizedBox(height: 8),
                    buildSubTitle(isDarkMode),
                    const SizedBox(height: 16),
                    CustomWidgets.customTextField(
                        hintText: "Enter your email address",
                        controller: controller.emailController,
                        isDarkMode: isDarkMode),
                    const Spacer(),
                    CustomWidgets.buildGetStartedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              if (controller.validateEmail(context)) {
                                controller.forgotPassword(context).then((val){
                                  controller.isLoading.value = false;
                                });
                              }
                            },
                      text: StringUtils.forgot_password_button,
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

  Widget buildTitle(bool isDarkMode) {
    return Text(
      StringUtils.reset_password,
      style: TextStyle(
        fontSize: 34,
        fontFamily: "Switzer",
        fontWeight: FontWeight.w600,
        color: isDarkMode ? ColorUtils.whiteColor : ColorUtils.blackColor,
      ),
    );
  }

  Widget buildSubTitle(bool isDarkMode) {
    return Text(
      StringUtils.reset_password_sub_title,
      style: TextStyle(
        fontSize: 14,
        fontFamily: "Switzer",
        fontWeight: FontWeight.w400,
        color: isDarkMode
            ? ColorUtils.darkModeGrey2
            : ColorUtils.textFieldBorderColorDark,
      ),
    );
  }

  AppBar buildAppBar(bool isDarkMode) {
    return AppBar(
      backgroundColor:
          isDarkMode ? ColorUtils.appbarBackgroundDark : Colors.white,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          color: isDarkMode
              ? ColorUtils.appbarHorizontalLineDark
              : ColorUtils.appbarHorizontalLineLight,
          height: 1.5,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 18,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        onPressed: () {
          Get.back();
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
}
