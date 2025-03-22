import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:real_proton/modules/reset_your_pin/reset_your_controller.dart';

import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/strings.dart';
import '../../utils/theme.dart';
import '../../utils/widgets.dart';
import '../account_varify_screen/account_verifi_controller.dart';
import '../forgot_password_screen/send_email_box.dart';
import '../kyc_screen/kyc_screen.dart';

class ResetYourPin extends StatefulWidget {
  const ResetYourPin({super.key});

  @override
  State<ResetYourPin> createState() => _ResetYourPinState();
}

class _ResetYourPinState extends State<ResetYourPin> {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final ResetYourPinController resetYourPinController =
        Get.put(ResetYourPinController());

    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: buildAppBar(isDarkMode, resetYourPinController),
      backgroundColor:
          isDarkMode ? Colors.black : ColorUtils.scaffoldBackGroundLight,
      body: Obx(
        () => Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildMobileNumberField(
                              resetYourPinController:
                              resetYourPinController,
                              context: context,
                              isDarkMode: isDarkMode,
                              boxDecoration: const BoxConstraints(
                                minWidth: 0,
                                minHeight: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomWidgets.buildGetStartedButton(
                    text: 'Connect with us',
                    onPressed: () {
                      // CustomWidgets.showInfo(context: context, message: "Contact us feature coming soon!");
                    },
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }



  Widget buildMobileNumberField({
    required ResetYourPinController resetYourPinController,
    Widget? suffixIcon,
    BoxConstraints? boxDecoration,
    required BuildContext context,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Your Mobile Number",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: "Switzer",
              color: isDarkMode
                  ? ColorUtils.indicaterGreyLight
                  : ColorUtils.appbarHorizontalLineDark,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? ColorUtils.appbarBackgroundDark
                  : ColorUtils.whiteColor,
              border: Border.all(
                color: resetYourPinController.focusNode.hasFocus
                    ? ColorUtils.loginButton
                    : (isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade400),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: resetYourPinController.isPhoneNumberVerified.value
                      ? () {
                          return;
                        }
                      : null,
                  child: AbsorbPointer(
                    absorbing:
                    resetYourPinController.isPhoneNumberVerified.value,
                    child: CountryCodePicker(
                      onChanged: (countryCode) {
                        resetYourPinController.countryCode.value =
                            countryCode.dialCode ?? "+1";
                        print(
                            "Selected Country Code: ${resetYourPinController.countryCode.value}");
                        FocusScope.of(context).requestFocus();
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
                      initialSelection:
                      resetYourPinController.countryCode.value,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 10),
                      textStyle: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: resetYourPinController.phoneController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    focusNode: resetYourPinController.focusNode,
                    readOnly:
                    resetYourPinController.isPhoneNumberVerified.value,
                    onTap: () {
                      FocusScope.of(context).requestFocus();
                    },
                    decoration: InputDecoration(
                      counterText: "",
                      // suffixIcon: suffixIcon,
                      suffixIconConstraints: boxDecoration,
                      hintText: "Enter your mobile number",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                      ),
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










  AppBar buildAppBar(
      bool isDarkMode, ResetYourPinController resetYourPinController) {
    return AppBar(
      title: buildAppBarTitle(StringUtils.resetYourPin, isDarkMode),
      centerTitle: true,
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
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: isDarkMode ? Colors.white : ColorUtils.appbarBackgroundDark,
          size: 15,
        ),
        onPressed: () =>
            Get.back(result: resetYourPinController.walletAddress.value),
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
