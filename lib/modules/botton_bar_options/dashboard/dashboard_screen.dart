import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/modules/botton_bar_options/InvestmentCard.dart';
import 'package:real_proton/modules/botton_bar_options/dashboard/dashboard_controller.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/strings.dart';
import 'package:real_proton/utils/theme.dart';
import 'package:real_proton/utils/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final ThemeController themeController = Get.find();
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorUtils.dashBoardAppbar1,
              ColorUtils.dashBoardAppbar2,
            ],
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Obx(
                    () => Column(
                      children: [
                        const SizedBox(
                          height: 15
                        ),
                        buildTotalBalance(isDarkMode),
                        buildContainerGradient(),
                        const SizedBox(
                          height: 15
                        ),
                        buildCurrentPrice(isDarkMode),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildPageView(isDarkMode, controller),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            CustomWidgets.showNetworkStatus(isDarkMode),
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

  Widget buildCurrentPrice(bool isDarkMode) {
    double rpAmount = CustomWidgets.weiToRP(blockChainController.tokenPrice.value);

    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: isDarkMode
              ? ColorUtils.appbarBackgroundDark
              : ColorUtils.whiteColor,
          border: Border.all(
            color: isDarkMode
                ? ColorUtils.appbarHorizontalLineDark
                : ColorUtils.appbarHorizontalLineLight,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              Image.asset(ImageUtils.logoWithoutborder, height: 40),
              const SizedBox(width: 5),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitleText('Current Price:', isDarkMode),
                  const SizedBox(width: 8),
                  buildNumbers(
                      '\$${rpAmount.toStringAsFixed(2)}', isDarkMode),
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Image.asset(
              isDarkMode
                  ? ImageUtils.dashBoardInfoDark
                  : ImageUtils.dashBoardInfoLight,
              height: 20,
              width: 20,
            ),
          )
        ],
      ),
    );
  }

  Widget buildNumbers(String number, bool isDarkMode) {
    return Text(
      number,
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          fontFamily: "Switzer",
          color: isDarkMode
              ? ColorUtils.indicaterGreyLight
              : ColorUtils.appbarHorizontalLineDark),
    );
  }

  Widget buildTitleText(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
          fontFamily: "Switzer",
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: isDarkMode
              ? ColorUtils.darkModeGrey2
              : ColorUtils.textFieldBorderColorDark),
    );
  }

  Widget buildTotalBalance(bool isDarkMode) {
    print("-=-=->${blockChainController.userBalance.value}");
    // print("-=-=->${blockChainController..value}");

    double amountPrice = CustomWidgets.weiToRP(blockChainController.userBalance.value);
    String usdAmount = CustomWidgets.rpToUSD(amountPrice);

    print("-=-=->${usdAmount}");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      width: double.maxFinite,
      color:
          isDarkMode ? ColorUtils.appbarBackgroundDark : ColorUtils.whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5
          ),
          Text(
            'Total Balance',
            style: TextStyle(
              color: isDarkMode
                  ? ColorUtils.darkModeGrey2
                  : ColorUtils.textFieldBorderColorDark,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${amountPrice.toStringAsFixed(2)} RP',
                style: TextStyle(
                  color: isDarkMode
                      ? Colors.white
                      : ColorUtils.appbarHorizontalLineDark,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 25,
                width: 70,
                padding: const EdgeInsets.only(top: 3),
                decoration: BoxDecoration(
                    color: ColorUtils.indicaterColor1.withOpacity(0.3)),
                child: const Text(
                  "+0.0%",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13, color: ColorUtils.indicaterColor1),
                ),
              )
            ],
          ),
          Text(
            usdAmount,
            style: TextStyle(
              color: isDarkMode
                  ? ColorUtils.darkModeGrey2
                  : ColorUtils.textFieldBorderColorDark,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 40,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                bottomBarController.currentIndex.value = 2;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorUtils.loginButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              child: const Text(
                StringUtils.investNow,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPageView(bool isDarkMode, DashboardController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Container(
          color: Colors.transparent,
          child: CustomWidgets.buildLoader(),
        );
      }

      if (controller.propertyList.isEmpty) {
        return Center(
          child: Text(
            "No properties available",
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        );
      }

      return Container(
        margin: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                "Explore Investment Opportunities",
                style: TextStyle(
                  color: isDarkMode
                      ? ColorUtils.whiteColor
                      : ColorUtils.blackColor,
                  fontFamily: "Switzer",
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 470,
              child: PageView.builder(
                padEnds: false,
                physics: const BouncingScrollPhysics(),
                controller: controller.pageController,
                itemCount: controller.propertyList.length,
                pageSnapping: true,
                itemBuilder: (context, index) {
                  final data = controller.propertyList[index];
                  return InvestmentOpportunityCard(
                    title: data['title'] ?? "Unknown",
                    location: data['address'] ?? "No location available",
                    marketPrice: data["metadata"]['avgMarketPrice'] ?? "0",
                    purchasePrice: data['metadata']['purchasePrice'] ?? "0",
                    area: data['metadata']['totalAreaSqft'] ?? '0',
                    annualReturn: data['metadata']['annualReturn'] ?? '0',
                    growth: data['metadata']['projectedValueGrowth'] ?? '0',
                    category: data['metadata']['category'] ?? "hotel",
                    image1: /*data['image'] ?? */ ImageUtils.image1,
                    isDarkMode: isDarkMode,
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SmoothPageIndicator(
              controller: controller.pageController,
              count: controller.propertyList.length,
              effect: WormEffect(
                dotHeight: 6,
                dotWidth: 6,
                activeDotColor: ColorUtils.loginButton,
                dotColor: Colors.grey,
              ),
            ),
          ],
        ),
      );
    });
  }
}
