import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/modules/botton_bar_options/sale/dropDownSale_screen.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/theme.dart';
import 'package:real_proton/utils/widgets.dart';

class SaleScreen extends StatelessWidget {
  SaleScreen({super.key});
  final ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width - 40;
    final double toggleWidth = 45.0;
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      backgroundColor: isDarkMode
          ? ColorUtils.blackColor
          : ColorUtils.scaffoldBackGroundLight,
      body: Obx(
        () {
    saleController.rePrice.value = CustomWidgets.weiToRP(blockChainController.tokenPrice.value);
    if (saleController.rePrice.value == 0) {
      return Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(child: CustomWidgets.buildLoader()),
      );
    }
          return Column(
          children: [
            const SizedBox(height: 20),
            CustomizedDropdown(),
            const SizedBox(height: 10),
            buildUpArrowAndPrices(isDarkMode),
            const Spacer(),
            if (saleController.isShowButton.value)
              buildSwipButton(buttonWidth, isDarkMode, toggleWidth),
            const SizedBox(height: 20),
          ],
        );
        },
      ),
    );
  }

  Widget buildUpArrowAndPrices(bool isDarkMode) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [buildTokenRow(isDarkMode), buildContainerGradient()],
        ),
        Align(
          alignment: const Alignment(0.0, 0.0),
          child: Image.asset(
            isDarkMode ? ImageUtils.arrowUpDark : ImageUtils.arrowUpLight,
            height: 40,
            width: 40,
          ),
        ),
      ],
    );
  }

  Widget buildContainerGradient() {
    return Container(
      height: 2,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Color.fromRGBO(249, 86, 22, 1),
            Colors.transparent
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  Widget buildSwipButton(
      double buttonWidth, bool isDarkMode, double toggleWidth) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: ColorUtils.loginButton, width: 0.5),
                borderRadius: BorderRadius.circular(35),
              ),
              child: ActionSlider.standard(
                controller: saleController.actionController,
                sliderBehavior: SliderBehavior.stretch,
                backgroundColor: Colors.transparent,
                icon: Image.asset(
                  ImageUtils.toggleButton,
                  height: 27,
                  width: 27,
                  color: Colors.white,
                ),
                toggleColor: ColorUtils.loginButton,
                child: const Text(
                  'Swipe to Invest',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Switzer',
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                action: saleController.textController.text.isEmpty ? (value){
                  CustomWidgets.showInfo(context: Get.context!, message: "Enter Amount");
                } :(controller) async {
                  controller.loading();
                    saleController.stripeApiCall();
                  await Future.delayed(const Duration(seconds: 2));
                  controller.success();
                  controller.reset();
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildTokenRow(bool isDarkMode) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorUtils.appbarBackgroundDark
            : ColorUtils.whiteColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  ImageUtils.logoWithoutborder,
                  height: 45,
                  width: 45,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 5),
                Text(
                  '${saleController.rpBalance.value} ${saleController.selectedToken.value}',
                  style: TextStyle(
                    color: isDarkMode
                        ? ColorUtils.darkModeGrey2
                        : ColorUtils.textFieldBorderColorDark,
                  ),
                ),
              ],
            ),
            Text(
              saleController.amount.value.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? ColorUtils.darkModeGrey2
                    : ColorUtils.textFieldBorderColorDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
