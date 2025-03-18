import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/help_and_support/help_and_support_controller.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/theme.dart';
import 'package:real_proton/utils/widgets.dart';

class HelpSupportScreen extends StatelessWidget {
  HelpSupportScreen({super.key});

  final ThemeController themeController = Get.find();
  final HelpSupportController controller = Get.put(HelpSupportController());

  @override
  Widget build(BuildContext context) {
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
            buildExpandedList(isDarkMode),
            SizedBox(height: 16),
            CustomWidgets.buildGetStartedButton(
              text: 'Connect with us',
              onPressed: () {
                CustomWidgets.showInfo(context: context, message: "Contact us feature coming soon!");
              },),
          ],
        ),
      ),
    );
  }

  Widget buildExpandedList(bool isDarkMode) {
    return Expanded(
      child: ListView.builder(
        itemCount: controller.helpTopics.length,
        itemBuilder: (context, index) {
          final topic = controller.helpTopics[index];

          return Obx(
            () {
              final isExpanded = controller.expandedIndex.value == index;

              return GestureDetector(
                onTap: () {
                  controller.toggleExpansion(index);
                },
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? (isExpanded ? Colors.grey[850] : Colors.grey[900])
                        : (isExpanded ? ColorUtils.loginButton : Colors.white),
                    border: Border.all(
                      color: isExpanded ? ColorUtils.loginButton : Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(controller.helpSupportImg[index],height: 20,width: 20,fit: BoxFit.fill,),
                                SizedBox(width: 4,),
                                Flexible(
                                  child: Text(
                                    topic['title']!,
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? ColorUtils.indicaterGreyLight
                                          : ColorUtils.appbarHorizontalLineDark,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Switzer",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            isExpanded ? Icons.remove : Icons.add,
                            color: isExpanded
                                ? ColorUtils.loginButton
                                : (isDarkMode ? Colors.white : Colors.black),
                          ),
                        ],
                      ),
                      if (isExpanded) ...[
                        const SizedBox(height: 8),
                        Text(
                          topic['content']!,
                          style: TextStyle(
                            fontFamily: "Switzer",
                            fontWeight: FontWeight.w400,
                            color: isDarkMode
                                ? ColorUtils.darkModeGrey2
                                : ColorUtils.dropDownBackGroundDark,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildConnectButton(bool isDarkMode) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Get.snackbar("Info", "Contact us feature coming soon!");
        },
        child: Text(
          'Connect with us',
          style: TextStyle(
            color: isDarkMode ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode ? Colors.white : ColorUtils.loginButton,
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
      title:buildAppBarTitle("Help & Support",isDarkMode),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: isDarkMode ? Colors.white :ColorUtils.appbarBackgroundDark ,size: 15,),
        onPressed: () {
          Get.back(); // Navigate back
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
