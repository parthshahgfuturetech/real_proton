import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/modules/account_varify_screen/account_verifi_screen.dart';
import 'package:real_proton/modules/botton_bar_options/bottom_bar/bottomBarController.dart';
import 'package:real_proton/modules/botton_bar_options/dashboard/dashboard_screen.dart';
import 'package:real_proton/modules/botton_bar_options/explore/explore_screen.dart';
import 'package:real_proton/modules/botton_bar_options/profile/profile_screen.dart';
import 'package:real_proton/modules/botton_bar_options/sale/sale_screen.dart';
import 'package:real_proton/modules/botton_bar_options/wallet/wallet_screen.dart';
import 'package:real_proton/modules/notification_screen/notification_screen.dart';
import 'package:real_proton/modules/property_details/property_detail__screen.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/theme.dart';

class BottomBar extends StatelessWidget {
  BottomBar({super.key});

  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
            (themeController.themeMode.value == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);
        return SafeArea(
          top: false,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: buildAppBar(context, isDarkMode),
            ),
            body: Stack(
              children: [
                buildScreens(),
                if (bottomBarController.kycPending.value) buildKycContainer(),
              ],
            ),
            bottomNavigationBar: Stack(
              clipBehavior: Clip.none,
              children: [
                buildBottomNavigationBarOptions(isDarkMode),
                buildSalePageOptions(context, isDarkMode),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildAppBar(BuildContext context, bool isDarkMode) {
    switch (bottomBarController.currentIndex.value) {
      case 0:
        return buildDashBoardScreenAppBar(isDarkMode);
      case 1:
        return propertyDetailsController.isActive.value
            ? buildProprtyDetailsAppbar(isDarkMode)
            : buildExploreScreenAppBar(isDarkMode);
      case 2:
        return buildSaleScreenAppBar(isDarkMode);
      case 3:
        return buildDashBoardScreenAppBar(isDarkMode,
            currentIndex: bottomBarController.currentIndex.value);
      case 4:
        return buildProfileAppbar(isDarkMode);
      default:
        return buildDashBoardScreenAppBar(isDarkMode);
    }
  }

  Widget buildProprtyDetailsAppbar(bool isDarkMode) {
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
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: isDarkMode ? Colors.white : ColorUtils.appbarBackgroundDark,
          size: 15,
        ),
        onPressed: () {
          propertyDetailsController.isActive.value = false;
        },
      ),
      backgroundColor:
          isDarkMode ? ColorUtils.appbarBackgroundDark : Colors.white,
      centerTitle: true,
      title: buildAppBarTitle("Property Details", isDarkMode),
    );
  }

  Widget buildProfileAppbar(bool isDarkMode) {
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
      centerTitle: true,
      title: buildAppBarTitle("Profile", isDarkMode),
    );
  }

  Widget buildSaleScreenAppBar(bool isDarkMode) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: isDarkMode
          ? ColorUtils.blackColor
          : ColorUtils.scaffoldBackGroundLight,
      title: Container(
          margin: const EdgeInsets.only(left: 10),
          child: buildAppBarTitle("Sale", isDarkMode)),
      bottom: PreferredSize(preferredSize: const Size.fromHeight(kToolbarHeight)
          , child: Container(
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
          )),
    );
  }

  Widget buildDashBoardScreenAppBar(bool isDarkMode, {int? currentIndex}) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(249, 86, 22, 0.25),
      scrolledUnderElevation: 0,
      leadingWidth: 200,
      leading: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 13),
              Center(
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDarkMode
                          ? ColorUtils.darkModeGrey2
                          : ColorUtils.whiteColor,
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: profileController.isLoading.value
                        ? Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                      ),
                    )
                        : profileController.userImage.value.isEmpty
                        ? Image.asset(
                      ImageUtils.emoji,
                      fit: BoxFit.fill,
                      height: 50,
                      width: 50,
                    )
                        : Image.network(
                      profileController.userImage.value,
                      fit: BoxFit.fill,
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: buildAppBarTitle(
                              "${profileController.firstName.value} ${profileController.lastName.value}",
                              isDarkMode),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          height: 5,
                          width: 5,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const Text('Accredited',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          if (profileController.isLoading.value)
            Container(
              margin: const EdgeInsets.only(top: 9,left: 20),
              child: CircularProgressIndicator(
                strokeWidth: 1,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
        ],
      ),
      actions: currentIndex == 3 ? null : [buildNotificationButton(isDarkMode)],
    );
  }

  Widget buildExploreScreenAppBar(bool isDarkMode) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: isDarkMode
          ? ColorUtils.blackColor
          : ColorUtils.scaffoldBackGroundLight,
      title: buildAppBarTitle("Investment Opportunities", isDarkMode),
    );
  }

  Widget buildAppBarTitle(String title, bool isDarkMode) {
    return Text(
      title,
      maxLines: 1,
      style: TextStyle(
        overflow: TextOverflow.ellipsis,
        color: isDarkMode
            ? ColorUtils.indicaterGreyLight
            : ColorUtils.appbarHorizontalLineDark,
        fontWeight: FontWeight.w600,
        fontFamily: "Switzer",
        fontSize: 22,
      ),
    );
  }

  Widget buildNotificationButton(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          Get.to(() => NotificationScreen());
        },
        child: Image.asset(
          isDarkMode
              ? ImageUtils.notificationDark
              : ImageUtils.notificationLight,
          height: 25,
          width: 25,
        ),
      ),
    );
  }

  Widget buildScreens() {
    return Positioned.fill(
      child: () {
        switch (bottomBarController.currentIndex.value) {
          case 0:
            return DashboardScreen();
          case 1:
            return propertyDetailsController.isActive.value
                ? PropertyDetailsScreen()
                : ExploreScreen();
          case 2:
            return SaleScreen();
          case 3:
            return WalletScreen();
          case 4:
            return ProfileScreen();
          default:
            return DashboardScreen();
        }
      }(),
    );
  }

  Widget buildSalePageOptions(BuildContext context, bool isDarkMode) {
    return Positioned(
      top: 5,
      left: MediaQuery.of(context).size.width / 2 - 30,
      child: GestureDetector(
        onTap: () {
          bottomBarController.changeIndex(2);
        },
        child: Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // color:  bottomBarController.currentIndex.value == 2
            //     ? Color.fromRGBO(249, 86, 22, 0.24)
            //     : Colors.transparent,
            border: Border.all(
              color: bottomBarController.currentIndex.value == 2
                  ? const Color.fromRGBO(249, 86, 22, 0.24)
                  : Colors.transparent,
              width: 4,
            ),
          ),
          child: Image.asset(
            bottomBarController.currentIndex.value == 2
                ? ImageUtils.saleSelected
                : isDarkMode
                    ? ImageUtils.saleNonSelected1
                    : ImageUtils.saleNonSelected,
            height: 55,
            width: 55,
          ),
        ),
      ),
    );
  }

  Widget buildBottomNavigationBarOptions(bool isDarkMode) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDarkMode
                ? ColorUtils.textFieldBorderColorDark
                : ColorUtils.textFieldBorderColorLight,
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: isDarkMode
            ? ColorUtils.appbarBackgroundDark
            : ColorUtils.bottomBarLight,
        currentIndex: bottomBarController.currentIndex.value,
        onTap: (index) {
          bottomBarController.changeIndex(index);
        },
        selectedItemColor: ColorUtils.loginButton,
        unselectedItemColor: isDarkMode
            ? ColorUtils.indicaterGreyLight
            : ColorUtils.appbarHorizontalLineDark,
        type: BottomNavigationBarType.fixed,
        items: List.generate(
          5,
          (index) => BottomNavigationBarItem(
            icon: Image.asset(
              fit: BoxFit.fill,
              bottomBarController.currentIndex.value == index
                  ? bottomBarController.selectedIcons[index]
                  : bottomBarController.noneSelectedIcons[index],
              height: 22,
              width: 22,
            ),
            label: bottomBarController.titles[index],
          ),
        ),
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontFamily: "Switzer",
          fontWeight: FontWeight.w400,
          color: isDarkMode
              ? ColorUtils.indicaterGreyLight
              : ColorUtils.appbarHorizontalLineDark,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: "Switzer",
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget buildKycContainer() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: bottomBarController.kycPending.value
          ? Container(
              height: 30,
              color: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        ImageUtils.infoImg,
                        height: 20,
                        width: 20,
                        fit: BoxFit.fitHeight,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        'KYC Verification Pending',
                        style: TextStyle(
                          fontFamily: "Switzer",
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(()=>AccountVerificationScreen());
                    },
                    child: const Text('Verify Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Switzer",
                          decoration: TextDecoration.underline,
                        )),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
