import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/botton_bar_options/bottom_bar/bottom_bar.dart';
import 'package:real_proton/modules/lending_screen/lending_screen.dart';
import 'package:real_proton/utils/shared_preference.dart';
import 'package:real_proton/utils/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      navigateToNextScreen();
    });
  }

  void navigateToNextScreen() {
    String? token =
    SharedPreferencesUtil.getString(SharedPreferenceKey.loginToken);
    String? googleToken =
    SharedPreferencesUtil.getString(SharedPreferenceKey.googleToken);

    if ((token != null && token.isNotEmpty) ||
        (googleToken != null && googleToken.isNotEmpty)) {
      Get.offAll(() => BottomBar());
    } else {
      Get.offAll(() => LeandingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 150,
          height: 150,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    final mode = themeController.themeMode.value;

    if (mode == ThemeMode.light) return Colors.white;
    if (mode == ThemeMode.dark) return Colors.black;

    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark ? Colors.black : Colors.white;
  }
}
