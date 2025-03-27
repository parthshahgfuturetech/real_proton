import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/modules/property_details/property_details_controller.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/strings.dart';
import 'package:real_proton/utils/theme.dart';
import 'package:real_proton/utils/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PropertyDetailsScreen extends StatelessWidget {
  PropertyDetailsScreen({super.key});

  final ThemeController themeController = Get.find();
  final PropertyDetailsController controller =
  Get.put(PropertyDetailsController());
  final List<String> imageName = [ImageUtils.image1, ImageUtils.image2];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery
                .of(context)
                .platformBrightness == Brightness.dark);
    return Obx(
          () =>
          Scaffold(
            backgroundColor:
            isDarkMode ? Colors.black : ColorUtils.scaffoldBackGroundLight,
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          buildImagesPageView(),
                          buildOwnerNameAndAddress(isDarkMode),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 10),
                  child: CustomWidgets.buildGetStartedButton(
                      onPressed: () {
                        bottomBarController.currentIndex.value = 2;
                      }, text: 'Invest Now'),
                )
              ],
            ),
          ),
    );
  }

  Widget buildOwnerNameAndAddress(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringUtils.addresTitle,
          style: TextStyle(
              fontFamily: "Switzer",
              fontSize: 20,
              color: isDarkMode ? ColorUtils.whiteColor : ColorUtils.blackColor,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Image.asset(
              ImageUtils.location,
              height: 20,
              width: 20,
              fit: BoxFit.fill,
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
              child: Text(
                StringUtils.addres,
                style: TextStyle(
                    fontFamily: "Switzer",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: isDarkMode
                        ? ColorUtils.darkModeGrey2
                        : ColorUtils.textFieldBorderColorDark),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDarkMode
                ? ColorUtils.appbarBackgroundDark
                : ColorUtils.bottomBarLight,
            border: Border.all(
              color: isDarkMode
                  ? ColorUtils.textFieldBorderColorDark
                  : ColorUtils.textFieldBorderColorLight,
            ),
          ),
          child: Row(
            children: [
              _buildTabButton(0, "Basic Details", isDarkMode),
              SizedBox(
                width: 10,
              ),
              _buildTabButton(1, "Property Performance", isDarkMode),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        controller.selectedTab.value == 0
            ? _buildBasicDetails(isDarkMode)
            : _buildPropertyPerformance(isDarkMode),
      ],
    );
  }

  Widget buildImagesPageView() {
    final List<String> imageName = [ImageUtils.image1, ImageUtils.image2];
    return Stack(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: propertyDetailsController.pageController,
            itemCount: imageName.length,
            itemBuilder: (context, index) {
              final data = imageName[index];
              return GestureDetector(
                onTap: () {
                  controller.openImagePopup(context, index,imageName);
                },
                child: Image.asset(
                  data,
                  height: 30,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: SmoothPageIndicator(
              controller: propertyDetailsController.pageController,
              count: imageName.length,
              effect: const WormEffect(
                dotHeight: 6,
                dotWidth: 6,
                activeDotColor: ColorUtils.loginButton,
                dotColor: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String image, String title, bool isDarkMode) {
    return Row(
      children: [
        Image.asset(
          image,
          height: 20,
          width: 20,
          fit: BoxFit.fill,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            title,
            style: TextStyle(
                fontSize: 12,
                fontFamily: "Switzer",
                fontWeight: FontWeight.w500,
                color: isDarkMode
                    ? ColorUtils.whiteColor
                    : ColorUtils.appbarBackgroundDark),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(int index, String title, bool isDarkMode) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedTab.value = index,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: controller.selectedTab.value == index
                ? (isDarkMode ? Colors.white : ColorUtils.loginButton)
                : (isDarkMode
                ? ColorUtils.appbarHorizontalLineDark
                : ColorUtils.indicaterGreyLight),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                fontFamily: "Switzer",
                color: controller.selectedTab.value == index
                    ? (isDarkMode
                    ? ColorUtils.loginButton
                    : ColorUtils.whiteColor)
                    : (isDarkMode
                    ? ColorUtils.indicaterGreyLight
                    : ColorUtils.appbarHorizontalLineDark),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicDetails(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorUtils.appbarBackgroundDark
            : ColorUtils.bottomBarLight,
        border: Border.all(
          color: isDarkMode
              ? ColorUtils.textFieldBorderColorDark
              : ColorUtils.textFieldBorderColorLight,
        ),
      ),
      child: Column(
        children: [
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3.5,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            children: [
              _buildDetailItem(
                  ImageUtils.profileDetailsImd1, "2 Acres", isDarkMode),
              _buildDetailItem(
                  ImageUtils.profileDetailsImd2, "87,527 SF Area", isDarkMode),
              _buildDetailItem(
                  ImageUtils.profileDetailsImd3, "5 Floors", isDarkMode),
              _buildDetailItem(
                  ImageUtils.profileDetailsImd4, "117 Units", isDarkMode),
              _buildDetailItem(
                  ImageUtils.profileDetailsImd4, "2020 Build", isDarkMode),
              _buildDetailItem(ImageUtils.profileDetailsImd5,
                  "71.50% Occupancy", isDarkMode),
              _buildDetailItem(
                  ImageUtils.profileDetailsImd6, "Good C", isDarkMode),
              _buildDetailItem(
                  ImageUtils.profileDetailsImd7, "2022 Upgrade", isDarkMode),
            ],
          ),
          Divider(),
          Text(
            StringUtils.longText,
            style: TextStyle(
                fontFamily: "Switzer",
                fontWeight: FontWeight.w400,
                color: isDarkMode
                    ? ColorUtils.darkModeGrey2
                    : ColorUtils.textFieldBorderColorDark,
                fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyPerformance(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorUtils.appbarBackgroundDark
            : ColorUtils.bottomBarLight,
        border: Border.all(
          color: isDarkMode
              ? ColorUtils.textFieldBorderColorDark
              : ColorUtils.textFieldBorderColorLight,
        ),
      ),
      child: Column(
        children: [
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            children: [
              _buildDetailRow('\$10,500,000', 'Acquisition Price', isDarkMode),
              _buildDetailRow(
                  '\$21,000,000', "Today's Market Price", isDarkMode),
              _buildDetailRow('\$1,600,367', 'Annualized Net', isDarkMode),
              _buildDetailRow('15.24%', 'Yield', isDarkMode),
              _buildDetailRow('\$21,000,000', 'Net Asset Value', isDarkMode),
              _buildDetailRow('\$3,772,837', '12 Mo. Sales Value', isDarkMode),
              _buildDetailRow('\$125', 'Average Market Rate', isDarkMode),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String left, String right, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          left,
          style: TextStyle(
              fontSize: 16,
              fontFamily: "Switzer",
              color: isDarkMode ? ColorUtils.whiteColor : ColorUtils.blackColor,
              fontWeight: FontWeight.w500),
        ),
        Flexible(
          child: Text(
            right,
            style: TextStyle(
                fontSize: 12,
                fontFamily: "Switzer",
                fontWeight: FontWeight.w400,
                color: isDarkMode
                    ? ColorUtils.darkModeGrey2
                    : ColorUtils.textFieldBorderColorDark),
          ),
        ),
      ],
    );
  }



}
