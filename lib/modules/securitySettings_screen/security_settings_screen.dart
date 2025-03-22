import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:real_proton/modules/botton_bar_options/profile/profile_screen.dart';

import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/theme.dart';
import '../botton_bar_options/bottom_bar/bottom_bar.dart';
import '../create_your_pin_screen/create_your_pin_screen.dart';
import '../create_your_pin_screen/password_reset_successfully_screen.dart';
import 'SecuritySettingsController.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final SecuritySettingsController controller = Get.put(SecuritySettingsController());
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar:buildAppBar(isDarkMode),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildEnable2FA(isDarkMode),
            SizedBox(height: 10.0),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDarkMode ? ColorUtils.appbarHorizontalLineDark : ColorUtils.appbarHorizontalLineLight,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Login Using Biometrics",
                            style: TextStyle(
                              color: isDarkMode ? ColorUtils.indicaterGreyLight : ColorUtils.appbarHorizontalLineDark,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Switzer",
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Receive instant updates directly on your mobile device, including alerts for transactions, account changes, and personalized offers.",
                            style: TextStyle(
                              fontFamily: "Switzer",
                              fontWeight: FontWeight.w400,
                              color: isDarkMode ? ColorUtils.darkModeGrey2 : ColorUtils.dropDownBackGroundDark,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() => CupertinoSwitch(
                      value: controller.isBiometricEnabled.value,
                      onChanged: (_) => controller.toggleBiometric(),
                      activeColor: ColorUtils.loginButton,
                      thumbColor: ColorUtils.whiteColor,
                    )),
                  ],
                ),
              ),
            ),


          ],
        ),
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
      title:buildAppBarTitle("Notification Setting",isDarkMode),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: isDarkMode ? Colors.white :ColorUtils.appbarBackgroundDark ,size: 15,),
        onPressed: () {
          Get.off(BottomBar()); // Navigate back
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

  Widget buildNotificationTile({
    required String title,
    required String description,
    required RxBool value,
    required VoidCallback onChanged,
    required bool isDarkMode,
  }) {
    return Obx(
          () => Card(
        elevation: 0,
        color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color:  isDarkMode ? ColorUtils.appbarHorizontalLineDark :ColorUtils.appbarHorizontalLineLight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isDarkMode
                            ? ColorUtils.indicaterGreyLight
                            : ColorUtils.appbarHorizontalLineDark,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Switzer",
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontFamily: "Switzer",
                        fontWeight: FontWeight.w400,
                        color: isDarkMode
                            ? ColorUtils.darkModeGrey2
                            : ColorUtils.dropDownBackGroundDark,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoSwitch(
                value: value.value,
                onChanged: (_) => onChanged(),
                activeColor: ColorUtils.loginButton,
                thumbColor: ColorUtils.whiteColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEnable2FA(bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        // Get.to(PasswordResetSuccessfullyScreen()) ;

      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isDarkMode
              ? ColorUtils.appbarBackgroundDark
              : ColorUtils.whiteColor,
          border: Border.all(
            color: isDarkMode
                ? ColorUtils.appbarHorizontalLineDark
                : ColorUtils.appbarHorizontalLineLight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  isDarkMode
                      ? ImageUtils.profileImg11
                      : ImageUtils.profileImageLight11,
                  height: 40,
                  width: 40,
                  fit: BoxFit.fill,
                ),
                const SizedBox(width: 10),
                Text(
                  'Change PIN',
                  style: TextStyle(
                    color: isDarkMode
                        ? ColorUtils.indicaterGreyLight
                        : ColorUtils.appbarHorizontalLineDark,
                    fontSize: 14,
                    fontFamily: "Switzer",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.navigate_next,
              color: isDarkMode
                  ? ColorUtils.indicaterGreyLight
                  : ColorUtils.appbarHorizontalLineDark,
            ),
          ],
        ),
      ),
    );
  }

}
