import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:real_proton/modules/reset_your_pin/reset_your_controller.dart';

import '../../utils/colors.dart';
import '../../utils/strings.dart';
import '../../utils/theme.dart';
import '../../utils/widgets.dart';

class ResetYourOtp extends StatefulWidget {
  const ResetYourOtp({super.key});

  @override
  State<ResetYourOtp> createState() => _ResetYourOtpState();
}

class _ResetYourOtpState extends State<ResetYourOtp> {
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
      body: Stack(
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
                            resetYourPinController: resetYourPinController,
                            context: context,
                            isDarkMode: isDarkMode,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: CustomWidgets.buildGetStartedButton(
                  onPressed: () {
                    if (resetYourPinController.textPhoneNumber.value.length <
                        6) {
                      Get.snackbar(
                        icon: const Icon(Icons.info, color: Colors.white),
                        "Error",
                        "Please enter all 6 digits",
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                        borderRadius: 1,
                        snackPosition:
                            SnackPosition.BOTTOM, // Ensures visibility
                      );
                    } else {
                      // phoneOtpRecivie(textPhoneNumber.value);
                    }
                  },
                  text: "Submit",
                ),
              ),
            ],
          ),
          // Show loader only if needed
        ],
      ),
    );
  }

  Widget buildMobileNumberField({
    required ResetYourPinController resetYourPinController,
    required BuildContext context,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter OTP",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: "Switzer",
              color: isDarkMode
                  ? ColorUtils.indicaterGreyLight
                  : ColorUtils.appbarHorizontalLineDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "We’ve sent a code to (+1 35625 65698)",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: "Switzer",
              color: isDarkMode
                  ? ColorUtils.indicaterGreyLight
                  : ColorUtils.appbarHorizontalLineDark,
            ),
          ),
          resetYourPinController.buildOtpFields(context, isDarkMode)
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
