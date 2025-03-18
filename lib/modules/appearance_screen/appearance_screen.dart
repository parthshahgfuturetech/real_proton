import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/theme.dart';

enum AppThemeMode { light, dark, system }

class AppearanceScreen extends StatelessWidget {
  AppearanceScreen({super.key});

  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
            (themeController.themeMode.value == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);

        return Scaffold(
          backgroundColor:
              isDarkMode ? Colors.black : ColorUtils.scaffoldBackGroundLight,
          appBar: buildAppBar(isDarkMode),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildThemeOptionTile(
                  title: "Light Theme",
                  description:
                      "Enjoy a clean and bright interface designed for optimal visibility in well-lit environments.",
                  value: AppThemeMode.light,
                  groupValue: _getAppThemeMode(themeController.themeMode.value),
                  onChanged: (selectedValue) {
                    // controller.updateTheme(selectedValue);
                    themeController.setThemeMode(ThemeMode.light);
                  },
                  isDarkMode: isDarkMode,
                ),
                buildThemeOptionTile(
                  title: "Dark Theme",
                  description:
                      "Switch to a sleek, modern design that reduces eye strain in low-light settings.",
                  value: AppThemeMode.dark,
                  groupValue: _getAppThemeMode(themeController.themeMode.value),
                  onChanged: (selectedValue) {
                    // controller.updateTheme(selectedValue);
                    themeController.setThemeMode(ThemeMode.dark);
                  },
                  isDarkMode: isDarkMode,
                ),
                buildThemeOptionTile(
                  title: "System Default",
                  description:
                      "Automatically adapt the app's appearance to match your device's system settings for a seamless experience.",
                  value: AppThemeMode.system,
                  groupValue: _getAppThemeMode(themeController.themeMode.value),
                  onChanged: (selectedValue) {
                    // controller.updateTheme(selectedValue);
                    themeController.setThemeMode(ThemeMode.system);
                  },
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
        );
      },
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
      title: buildAppBarTitle("Appearance", isDarkMode),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: isDarkMode ? Colors.white : ColorUtils.appbarBackgroundDark,
          size: 15,
        ),
        onPressed: () {
          Get.back();
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

  Widget buildThemeOptionTile({
    required String title,
    required String description,
    required AppThemeMode value,
    required AppThemeMode groupValue,
    required void Function(AppThemeMode) onChanged,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: ()=> onChanged(value),
      child: Card(
        elevation: 0,
        color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: isDarkMode ? ColorUtils.appbarHorizontalLineDark :ColorUtils.appbarHorizontalLineLight,
          )),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
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
                        fontSize: 16,
                        fontFamily: "Switzer",
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: isDarkMode
                            ? ColorUtils.darkModeGrey2
                            : ColorUtils.dropDownBackGroundDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Switzer",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 1,
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: groupValue == value ? ColorUtils.loginButton : Colors.grey,
                    width: groupValue == value ? 6 : 1,
                  ),
                  color:
                      groupValue == value ? Colors.black : Colors.transparent,
                ),
                child: groupValue == value
                    ? Center(
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDarkMode
                                ? ColorUtils.whiteColor
                                : ColorUtils.blackColor,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppThemeMode _getAppThemeMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return AppThemeMode.light;
      case ThemeMode.dark:
        return AppThemeMode.dark;
      case ThemeMode.system:
        return AppThemeMode.system;
      default:
        return AppThemeMode.system;
    }
  }
}
