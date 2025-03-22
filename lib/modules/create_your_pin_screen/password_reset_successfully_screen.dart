import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:real_proton/utils/colors.dart';

import '../securitySettings_screen/security_settings_screen.dart';

class PasswordResetSuccessfullyScreen extends StatefulWidget {
  const PasswordResetSuccessfullyScreen({super.key});

  @override
  State<PasswordResetSuccessfullyScreen> createState() => _PasswordResetSuccessfullyScreenState();
}

class _PasswordResetSuccessfullyScreenState extends State<PasswordResetSuccessfullyScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Get.offAll(() => SecuritySettingsScreen());
    });
    return  Scaffold(
      backgroundColor: ColorUtils.completeGreenColor, // Pistachio color
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/checkmark_circle.png", width: 94, height: 94),
            const SizedBox(height: 20),
            const Text(
              "PIN Created!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                fontFamily: "Switzer",
                color: Colors.white
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your PIN Has Been Created Successfully!\nEnter your PIN to Proceed",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}