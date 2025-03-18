import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/theme.dart';
import 'notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationController controller = Get.put(NotificationController());
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      appBar: buildAppBar(isDarkMode),
      backgroundColor:
      isDarkMode ? Colors.black : ColorUtils.scaffoldBackGroundLight,
      body: Obx(
            () => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              buildSectionHeader(
                title: 'Today',
                actionText: 'Mark all as Read',
                onActionTap: controller.markAllAsRead,
                isDarkMode: isDarkMode
              ),
              SizedBox(height: 15,),
              ...controller.notifications
                  .where((notification) => notification['isToday'] == true)
                  .map((notification) => buildNotificationTile(notification,isDarkMode))
                  .toList(),
              const SizedBox(height: 16),
              // Earlier Section
              buildSectionHeader(title: 'Earlier',isDarkMode: isDarkMode),
              SizedBox(height: 15,),
              ...controller.notifications
                  .where((notification) => notification['isToday'] == false)
                  .map((notification) => buildNotificationTile(notification,isDarkMode))
                  .toList(),
            ],
          ),
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
      title:buildAppBarTitle("Notification",isDarkMode),
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

  Widget buildSectionHeader({
    required String title,
    String? actionText,
    VoidCallback? onActionTap,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:  TextStyle(
              color: isDarkMode
              ? ColorUtils.indicaterGreyLight
              : ColorUtils.appbarHorizontalLineDark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (actionText != null)
            GestureDetector(
              onTap: onActionTap,
              child: Container(
                height: 30,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white.withOpacity(0.16) : ColorUtils.indicaterGreyLight,
                  border: Border.all(
                    color: isDarkMode
                        ? ColorUtils.appbarHorizontalLineDark
                        : ColorUtils.appbarHorizontalLineLight,
                  ),
                ),
                child: Center(
                  child: Text(
                    actionText,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : ColorUtils.appbarBackgroundDark,
                      fontSize: 12,
                      fontFamily: "Switzer",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildNotificationTile(Map<String, dynamic> notification,bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? notification['isRead']
            ? ColorUtils.appbarBackgroundDark
            : ColorUtils.notificationColor  : notification['isRead']
            ? ColorUtils.bottomBarLight
            : ColorUtils.notificationLight,
        border: isDarkMode ? Border.all(
          color: notification['isRead']
              ? ColorUtils.appbarHorizontalLineDark
              : ColorUtils.notificationBorderColor,
        ) : Border.all(
          color: notification['isRead']
              ? ColorUtils.appbarHorizontalLineLight
              : ColorUtils.notificationBorderColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(isDarkMode ? ImageUtils.checkmark5 :ImageUtils.checkmark6,height: 40,width: 40,fit: BoxFit.fill,),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notification['title'],
                      style: TextStyle(
                        color:isDarkMode
                            ? ColorUtils.indicaterGreyLight
                            : ColorUtils.appbarHorizontalLineDark,
                        fontSize: 16,
                        fontFamily: "Switzer",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      notification['time'],
                      style: TextStyle(
                        color: isDarkMode
                            ? ColorUtils.darkModeGrey2
                            : ColorUtils.dropDownBackGroundDark,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Switzer",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification['message'],
                  style: const TextStyle(
                    color: ColorUtils.darkModeGrey2,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Switzer",
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
