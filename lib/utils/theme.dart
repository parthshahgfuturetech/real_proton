import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
enum AppThemeMode { light, dark, system }

class ThemeController extends GetxController {
  var themeMode = ThemeMode.dark.obs;

  // void setThemeMode(ThemeMode mode) {
  //   themeMode.value = mode;
  //   Get.changeThemeMode(mode);
  // }
  @override
  void onInit() {
    super.onInit();
    loadThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', _themeModeToString(mode));
  }

  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    String? themeString = prefs.getString('themeMode');

    if (themeString != null) {
      themeMode.value = _stringToThemeMode(themeString);
      Get.changeThemeMode(themeMode.value);
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
      default:
        return 'system';
    }
  }

  ThemeMode _stringToThemeMode(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}