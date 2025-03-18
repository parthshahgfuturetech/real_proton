import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/modules/botton_bar_options/InvestmentCard.dart';
import 'package:real_proton/modules/botton_bar_options/explore/explore_controller.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ExploreScreen extends StatelessWidget {
  ExploreScreen({super.key});

  final ThemeController themeController = Get.find();

  final ExploreController exploreController = Get.put(ExploreController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      backgroundColor: isDarkMode
          ? ColorUtils.blackColor
          : ColorUtils.scaffoldBackGroundLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildImagesPageView(),
            const SizedBox(height: 20),
            buildProperties(isDarkMode),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                propertyDetailsController.isActive.value = true;
              },
              child: buildPageView("Active Properties", isDarkMode,
                  exploreController.actionController),
            ),
            const SizedBox(height: 20),
            buildPageView("Upcoming Properties", isDarkMode,
                exploreController.upCommingController),
            const SizedBox(height: 40),
            buildBottomSideImages(isDarkMode)
          ],
        ),
      ),
    );
  }

  Widget buildBottomSideImages(bool isDarkMode) {
    return Container(
      height: 140,
      padding: const EdgeInsets.only(left: 15, top: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? const [
                  Color.fromRGBO(82, 82, 91, 1),
                  Color.fromRGBO(82, 82, 91, 1),
                  Color.fromRGBO(24, 24, 27, 0.9),
                ]
              : const [
                  Color.fromRGBO(250, 250, 250, 1),
                  Color.fromRGBO(228, 228, 231, 1)
                ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Our Partners",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: "Switzer",
                color: isDarkMode
                    ? ColorUtils.indicaterGreyLight
                    : ColorUtils.appbarHorizontalLineDark),
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: exploreController.bottomSideImageName
                  .map((ele) => Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: buildBottomSideImage(ele),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomSideImage(String image) {
    return Image.asset(
      image,
      height: 50,
      width: 50,
    );
  }

  Widget buildPageView(
      String title, bool isDarkMode, PageController? controller) {
    final List<Map<String, dynamic>> investmentData = [
      {
        'title': 'Residence Inn by Marriott',
        'location': '625 Commercial Loop, San Marcos...',
        'marketPrice': '21.0',
        'purchasePrice': '10.5',
        'area': '87527',
        'annualReturn': '8',
        'growth': '14',
        'category': 'hotal',
        'image1': ImageUtils.image1
      },
      {
        'title': 'Red Roof Plus',
        'location': '11310 N 30th St. Tampa...',
        'marketPrice': '14.7',
        'purchasePrice': '7.5',
        'area': '60775',
        'category': 'hotal',
        'annualReturn': '7',
        'growth': '12',
        'image1': ImageUtils.image2,
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              title,
              style: TextStyle(
                  color: isDarkMode
                      ? ColorUtils.whiteColor
                      : ColorUtils.blackColor,
                  fontFamily: "Switzer",
                  fontSize: 18),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 470,
            child: PageView.builder(
              controller: controller,
              itemCount: investmentData.length,
              itemBuilder: (context, index) {
                final data = investmentData[index];
                return InvestmentOpportunityCard(
                  title: data['title'],
                  location: data['location'],
                  marketPrice: data['marketPrice'],
                  purchasePrice: data['purchasePrice'],
                  area: data['area'],
                  category: data['area'],
                  annualReturn: data['annualReturn'],
                  growth: data['growth'],
                  image1: data['image1'],
                  isDarkMode: isDarkMode,
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          SmoothPageIndicator(
            controller: controller!,
            count: investmentData.length,
            effect: const WormEffect(
              dotHeight: 6,
              dotWidth: 6,
              activeDotColor: ColorUtils.loginButton,
              dotColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImagesPageView() {
    final List<String> imageName = [
      'assets/images/explore-img-1.png',
      'assets/images/explore-img-2.png',
      'assets/images/explore-img-3.png',
    ];
    return Column(
      children: [
        Container(
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: PageView.builder(
            controller: exploreController.pageController,
            itemCount: imageName.length,
            itemBuilder: (context, index) {
              final data = imageName[index];
              return Image.asset(
                data,
                height: 30,
                width: double.infinity,
                fit: BoxFit.fill,
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        SmoothPageIndicator(
          controller: exploreController.pageController,
          count: imageName.length,
          effect: const WormEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: ColorUtils.loginButton,
            dotColor: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget buildProperties(bool isDarkMode) {
    return Container(
      height: 65,
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTitleText("Properties", isDarkMode),
                  const SizedBox(width: 8),
                  buildNumbers("05", isDarkMode),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 2,
                  color: isDarkMode
                      ? ColorUtils.darkModeGrey2
                      : ColorUtils.textFieldBorderColorDark,
                ),
                const SizedBox(
                  width: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildTitleText("Expected Yield", isDarkMode),
                      const SizedBox(width: 8),
                      buildNumbers("8% - 25%", isDarkMode),
                    ],
                  ),
                )
              ],
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
          fontSize: 18,
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
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: isDarkMode
              ? ColorUtils.darkModeGrey2
              : ColorUtils.textFieldBorderColorDark),
    );
  }
}
