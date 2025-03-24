import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/theme.dart';
import 'rate_us_controller.dart';

class RateUsScreen extends StatelessWidget {
  RateUsScreen({super.key});

  final RateUsController controller = Get.put(RateUsController());
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery
                .of(context)
                .platformBrightness == Brightness.dark);
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor:
        isDarkMode ? Colors.black : ColorUtils.scaffoldBackGroundLight,
        appBar: buildAppBar(isDarkMode),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(
                () =>
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            buildStarContainer(isDarkMode),
                            SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Feedback',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            buildFeedBackTextField(isDarkMode),
                          ],
                        ),
                      ),
                    ),
                    buildSubmitButton(isDarkMode),
                  ],
                ),
          ),
        ),
      ),
    );
  }

  Widget buildStarContainer(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorUtils.appbarBackgroundDark
            : ColorUtils.bottomBarLight,
        border: Border.all(
          color: isDarkMode
              ? ColorUtils.appbarHorizontalLineDark
              : ColorUtils.appbarHorizontalLineLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text("Rate Our Service out of 5 Star",
              style: TextStyle(
                fontFamily: "Switzer",
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: isDarkMode
                    ? ColorUtils.indicaterGreyLight
                    : ColorUtils.appbarHorizontalLineDark,
              ),),
          ),
          Row(
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  Icons.star,
                  color: index < controller.rating.value
                      ? Colors.orange
                      : Colors.grey,
                ),
                iconSize: 40,
                onPressed: () => controller.updateRating(index + 1),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildFeedBackTextField(bool isDarkMode) {
    return TextField(
      onChanged: controller.updateFeedback,
      maxLines: 5,
      maxLength: 250,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        filled: true,
        fillColor:  isDarkMode
            ? ColorUtils.appbarBackgroundDark
            : ColorUtils.bottomBarLight,
        hintText: 'Write Here',
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.grey : Colors.black38,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide: BorderSide(
            color:  isDarkMode
                ? ColorUtils.appbarHorizontalLineDark
                : ColorUtils.appbarHorizontalLineLight,
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide: BorderSide(
            color: ColorUtils.loginButton,
            width: 2,
          ),
        ),
        counterText: '${controller.feedback.value.length}/250 Words',
        counterStyle: TextStyle(
          color: isDarkMode ? Colors.grey : Colors.black38,
        ),
      ),
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  Widget buildSubmitButton(bool isDarkMode) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: controller.submitFeedback,
        child: Text(
          'Submit',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: "Switzer",
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:isDarkMode ? Colors.white : ColorUtils.loginButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1),
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
      title: buildAppBarTitle("Rate Us", isDarkMode),
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

}
