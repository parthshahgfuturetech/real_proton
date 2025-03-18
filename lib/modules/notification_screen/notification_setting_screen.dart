import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/notification_screen/notification_controller.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/theme.dart';

class NotificationSettingsScreen extends StatelessWidget {
  NotificationSettingsScreen({super.key});
  final NotificationController controller = Get.put(NotificationController());
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
            buildNotificationTile(
              title: "Push Notifications",
              description:
              "Receive instant updates directly on your mobile device, including alerts for transactions, account changes, and personalized offers.",
              value: controller.isPushNotificationEnabled,
              onChanged: controller.togglePushNotification,
              isDarkMode: isDarkMode,
            ),
            buildNotificationTile(
              title: "Email Notifications",
              description:
              "Stay informed with detailed updates sent to your inbox, including transaction summaries, security alerts, and service updates.",
              value: controller.isEmailNotificationEnabled,
              onChanged: controller.toggleEmailNotification,
              isDarkMode: isDarkMode,
            ),
            buildNotificationTile(
              title: "SMS Notifications",
              description:
              "Get quick and concise alerts via text messages for critical updates like transaction confirmations, OTPs, and account security alerts.",
              value: controller.isSmsNotificationEnabled,
              onChanged: controller.toggleSmsNotification,
              isDarkMode: isDarkMode,
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
}
