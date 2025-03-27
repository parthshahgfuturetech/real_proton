import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import '../../utils/theme.dart';
import 'create_your_pin_controller.dart';

class CreateYourPinScreen extends StatefulWidget {
  const CreateYourPinScreen({super.key});

  @override
  State<CreateYourPinScreen> createState() => _CreateYourPinScreenState();
}

class _CreateYourPinScreenState extends State<CreateYourPinScreen> {
  final CreateYourPinController createYourPinController =
      Get.put(CreateYourPinController());
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: buildAppBar(isDarkMode),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            SizedBox(height: 30),

            Container(
              width: 94,
              height: 94,
              child: Image.asset("assets/images/logo.png", fit: BoxFit.contain),
            ),
            SizedBox(height: 30),

            const Text(
              "Create Your PIN",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  fontFamily: "Switzer"),
            ),
            SizedBox(height: 20),
            Obx(

                  () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  bool isFilled = index < createYourPinController.pin.value.length;
                  bool isCurrent = index == createYourPinController.pin.value.length;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isFilled
                            ? ColorUtils.loginButton
                            : (isCurrent ? ColorUtils.appbarHorizontalLineDark : Colors.grey.withOpacity(0.5)),
                      ),
                      color: isFilled ? Colors.white : Colors.transparent,
                    ),
                  );
                }),
              ),
            ),
            const Spacer(),
            // Number Pad
            buildContainerGradient(),
            buildNumberPad(isDarkMode),

          ],
        ),
      ),
    );
  }
  Widget buildContainerGradient() {
    return Container(
      height: 2,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            ColorUtils.loginButton,
            Colors.transparent
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
  AppBar buildAppBar(bool isDarkMode) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor:
          isDarkMode ? ColorUtils.appbarBackgroundDark : Colors.white,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios,
            color: isDarkMode ? Colors.white : ColorUtils.appbarBackgroundDark,
            size: 15),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget buildNumberPad(isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        // color: Colors.orange,
        child: Column(
          children: [
            for (var row in [
              ['1', '2', '3'],
              ['4', '5', '6'],
              ['7', '8', '9'],
              ['', '0', '⌫'],
            ])
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: row.map((text) {
                  return text.isEmpty
                      ? const SizedBox(width: 92)
                      : buildNumberButton(text,isDarkMode);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildNumberButton(String text, isDarkMode) {
    return GestureDetector(
      onTap: () {
        if (text == '⌫') {
          createYourPinController.deleteDigit();
        } else {
          createYourPinController.addDigit(text);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        width: 75,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: text == '⌫'
            ? const Icon(Icons.backspace, color: Colors.grey, size: 28)
            : Text(
                text,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : ColorUtils.blackColor
                ),
              ),
      ),
    );
  }
}
