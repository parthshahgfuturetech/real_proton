import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/modules/account_varify_screen/account_verifi_screen.dart';
import 'package:real_proton/modules/appearance_screen/appearance_screen.dart';
import 'package:real_proton/modules/botton_bar_options/profile/profile_controller.dart';
import 'package:real_proton/modules/change_password/change_password_screen.dart';
import 'package:real_proton/modules/help_and_support/help_and_support_screen.dart';
import 'package:real_proton/modules/history/history_screen.dart';
import 'package:real_proton/modules/login_screen/login_controller.dart';
import 'package:real_proton/modules/notification_screen/notification_setting_screen.dart';
import 'package:real_proton/modules/rate_us_screen/rate_us_screen.dart';
import 'package:real_proton/modules/securitySettings_screen/security_settings_screen.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/theme.dart';
import 'package:real_proton/utils/widgets.dart';

import '../../create_your_pin_screen/create_your_pin_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    final ProfileController proController = Get.put(ProfileController());
    final ThemeController themeController = Get.find();
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor:
          isDarkMode ? Colors.black : ColorUtils.scaffoldBackGroundLight,
      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildEditProfileContainer(context, isDarkMode, proController),
                  buildBalanceContainer(isDarkMode, proController),
                  const SizedBox(height: 16),
                  buildSectionHeader('Account Information'),
                  buildAccountAndAppMainContainer(
                    isDarkMode,
                    proController.profileItems,
                    isDarkMode
                        ? proController.profileDarkImageDark
                        : proController.profileLightImageLight,
                    proController
                  ),
                  buildSectionHeader('App Settings'),
                  buildAccountAndAppMainContainer(
                    isDarkMode,
                    proController.profileAppSettingItems,
                    isDarkMode
                        ? proController.profileAppSettingsDarkImageDark
                        : proController.profileAppSettingsLightImageLight,proController
                  ),
                  const SizedBox(height: 20),
                  buildLogoutButton(context, loginController, proController),
                  SizedBox(
                      height: bottomBarController.kycPending.value ? 50 : 20),
                ],
              ),
            ),
            if (proController.isLoading.value)
              Container(
                color: Colors.black.withValues(alpha: 0.7),
                child: CustomWidgets.buildLoader(),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildLogoutButton(
      BuildContext context, loginController, ProfileController proController) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          proController.logOutMethod(context, loginController);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(251, 55, 72, 0.16),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color.fromRGBO(255, 108, 109, 1)),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        child: const Text(
          "Logout",
          style: TextStyle(
            fontFamily: "Switzer",
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color.fromRGBO(255, 108, 109, 1),
          ),
        ),
      ),
    );
  }

  Widget buildAccountAndAppMainContainer(
    bool isDarkMode,
    List<Map<String, dynamic>> items,
    List<String> imagePaths,
      ProfileController prController
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkMode
              ? ColorUtils.appbarHorizontalLineDark
              : ColorUtils.appbarHorizontalLineLight,
        ),
        color: isDarkMode
            ? ColorUtils.appbarBackgroundDark
            : ColorUtils.bottomBarLight,
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final imagePath = imagePaths[index];

          return buildAccountAndAppSettingContainer(
            title: item['title'],
            subTitle: item['subtitle'],
            imagePath: imagePath,
            isDarkMode: isDarkMode,
            onTap: () {
              handleTap(item['title'],prController );
            },
          );
        }),
      ),
    );
  }

  void handleTap(String title,ProfileController prController) {
    if (title == "Account Verification") {
      Get.to(() => AccountVerificationScreen())!.then((value) {
        print("hello accout$value");
        profileController.walletAddress.value = value;
        if(profileController.walletAddress.value.isNotEmpty){
          bottomBarController.kycPending.value = false;
          saleController.isShowButton.value = true;
          walletController.isTransactionHistoryShow.value = true;
        }
      });
    } else if (title == "Change Password") {
      Get.to(() => ChangePasswordScreen());
    } else if (title == "Reports") {
      Get.to(() => AccountVerificationScreen());
    } else if (title == "Notification Setting") {
      Get.to(() => NotificationSettingsScreen());
    }else if (title == "Security Settings") {
      // Get.to(() => SecuritySettingsScreen());
      Get.to(() => CreateYourPinScreen());
    } else if (title == 'Appearance') {
      Get.to(() => AppearanceScreen());
    } else if (title == 'Rate Us') {
      Get.to(() => RateUsScreen());
    } else if (title == 'Help & Support') {
      Get.to(() => HelpSupportScreen());
    } else if (title == 'Transaction History') {
      Get.to(() => HistoryScreen("${prController.firstName.value} ${prController.lastName.value}"));
    } else {
      Get.snackbar(
        "Action",
        "You tapped on $title",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget buildAccountAndAppSettingContainer({
    required String title,
    required String subTitle,
    required String imagePath,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 40,
              width: 40,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode
                              ? ColorUtils.indicaterGreyLight
                              : ColorUtils.appbarHorizontalLineDark,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Switzer",
                        ),
                      ),
                      const SizedBox(width: 4),
                      bottomBarController.kycPending.value
                          ? title == "Account Verification"
                              ? Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  decoration: const BoxDecoration(
                                    color: ColorUtils.loginButton,
                                  ),
                                  child: const Text(
                                    "Pending",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Switzer",
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink()
                          : const SizedBox.shrink(),
                    ],
                  ),
                  Text(
                    subTitle,
                    style: const TextStyle(
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                      color: ColorUtils.darkModeGrey2,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Switzer",
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.navigate_next,
              size: 30,
              color: isDarkMode
                  ? ColorUtils.indicaterGreyLight
                  : ColorUtils.appbarHorizontalLineDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBalanceContainer(
      bool isDarkMode, ProfileController proController) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorUtils.appbarBackgroundDark
            : ColorUtils.bottomBarLight,
      ),
      child: Row(
        children: [
          Image.asset(
            isDarkMode ? ImageUtils.profileImg1 : ImageUtils.profileImageLight1,
            height: 40,
            width: 40,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$12,323.00',
                style: TextStyle(
                    fontFamily: "Switzer",
                    fontWeight: FontWeight.w500,
                    color: isDarkMode
                        ? ColorUtils.indicaterGreyLight
                        : ColorUtils.appbarHorizontalLineDark,
                    fontSize: 16),
              ),
              if (proController.walletAddress.value.isNotEmpty) ...[
                Row(
                  children: [
                    Text(
                      CustomWidgets.formatAddress(proController.walletAddress.value),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Switzer",
                        color: ColorUtils.darkModeGrey2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                              text: proController.walletAddress.value),
                        );
                      },
                      child: Image.asset(
                        ImageUtils.copyImg,
                        height: 20,
                        width: 20,
                        color: isDarkMode
                            ? ColorUtils.indicaterGreyLight
                            : ColorUtils.appbarHorizontalLineDark,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const SizedBox.shrink()
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget buildEditProfileContainer(
      BuildContext context, bool isDarkMode, ProfileController proController) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorUtils.loginButton,
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(255, 126, 85, 0.24),
            Color.fromRGBO(249, 86, 22, 0.06),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDarkMode
                                ? ColorUtils.darkModeGrey2
                                : ColorUtils.whiteColor,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: proController.isLoading.value
                              ? Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.shade300,
                                  ),
                                )
                              : proController.userImage.value == null ||
                                      proController.userImage.value.isEmpty
                                  ? Image.asset(
                                      ImageUtils.emoji,
                                      fit: BoxFit.fill,
                                      height: 50,
                                      width: 50,
                                    )
                                  : Image.network(
                                      proController.userImage.value,
                                      fit: BoxFit.fill,
                                      height: 50,
                                      width: 50,
                                    ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: ColorUtils.appbarBackgroundDark,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return SafeArea(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(context).viewInsets.bottom,
                                  ),
                                  child: buildEditDetailsBottomSheet(
                                      isDarkMode, proController),
                                ),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode
                              ? const Color.fromRGBO(255, 255, 255, 0.16)
                              : ColorUtils.indicaterGreyLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        child: Text(
                          'Edit Details',
                          style: TextStyle(
                            color: isDarkMode
                                ? ColorUtils.indicaterGreyLight
                                : ColorUtils.appbarHorizontalLineDark,
                            fontSize: 15,
                            fontFamily: "Switzer",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (proController.isLoading.value)
                  Container(
                    margin: const EdgeInsets.only(top: 9, left: 7),
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${proController.firstName.value} ${proController.lastName.value}",
                      style: TextStyle(
                          fontFamily: "Switzer",
                          color: isDarkMode
                              ? ColorUtils.indicaterGreyLight
                              : ColorUtils.appbarHorizontalLineDark,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Accredited',
                      style: TextStyle(
                          fontFamily: "Switzer",
                          color: isDarkMode
                              ? ColorUtils.indicaterGreyLight
                              : ColorUtils.appbarHorizontalLineDark,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              Stack(
                children: [
                  SizedBox(
                    height: 25,
                    child: LinearProgressIndicator(
                      value: proController.progress.value / 100,
                      color: ColorUtils.loginButton,
                      backgroundColor: Colors.grey[800],
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${proController.progress.value}%',
                          style: const TextStyle(
                            fontFamily: "Switzer",
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildEditDetailsBottomSheet(
      bool isDarkMode, ProfileController proController) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Obx(
                  () => Stack(
                    children: [
                      Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDarkMode
                                  ? ColorUtils.darkModeGrey2
                                  : ColorUtils.whiteColor,
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: proController.isLoading.value
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade300,
                                    ),
                                  )
                                : proController.userImage.value.isEmpty
                                    ? Image.asset(
                                        ImageUtils.emoji,
                                        fit: BoxFit.fill,
                                        height: 50,
                                        width: 50,
                                      )
                                    : Image.network(
                                        proController.userImage.value,
                                        fit: BoxFit.fill,
                                        height: 50,
                                        width: 50,
                                      ),
                          ),
                        ),
                      ),
                      if (proController.isLoading.value)
                        Container(
                          margin: const EdgeInsets.only(top: 7, left: 7),
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            color: isDarkMode ? Colors.black : Colors.black,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 40,
                  width: 130,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: const BoxDecoration(
                    color: ColorUtils.dropDownBackGroundDark,
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      proController.pickImage(Get.context!);
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          ImageUtils.changeImage,
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          "Change Photo",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Switzer",
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomWidgets.customTextField(
                controller: proController.firstNameController,
                hintText: "First Name",
                textInputAction: TextInputAction.next,
                isDarkMode: isDarkMode),
            const SizedBox(height: 16),
            CustomWidgets.customTextField(
                controller: proController.lastNameController,
                hintText: "Last Name",
                textInputAction: TextInputAction.done,
                isDarkMode: isDarkMode),
            const SizedBox(height: 16),
            CustomWidgets.buildGetStartedButton(
              onPressed: () {
                proController.apiUserUpdate(Get.context!);
                Get.back();
              },
              text: 'Update Details',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            color: ColorUtils.darkModeGrey2,
            fontSize: 16,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
