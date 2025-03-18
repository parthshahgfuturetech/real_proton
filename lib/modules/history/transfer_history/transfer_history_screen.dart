import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/modules/botton_bar_options/wallet/transfer_fund__screen/transfer_fund_controller.dart';
import 'package:real_proton/modules/history/history_controller.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/theme.dart';
import 'package:real_proton/utils/widgets.dart';

class TransferHistoryScreen extends StatelessWidget {
  TransferHistoryScreen({super.key});

  final ThemeController themeController = Get.find();
  final HistoryController controller = Get.put(HistoryController());

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
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildTransactionCompleteAndFail(isDarkMode),
              const SizedBox(height: 32),
              buildDetailsContainer(isDarkMode),
              const Spacer(),
              CustomWidgets.buildGetStartedButton(
                  text: 'Download', onPressed: () {}),

              // buildDoneButton(isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(bool isDarkMode) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: isDarkMode
          ? ColorUtils.blackColor
          : ColorUtils.scaffoldBackGroundLight,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 18,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        onPressed: () => Get.back(),
      ),
      centerTitle: true,
      title: Container(
        margin: const EdgeInsets.only(left: 10),
        child: buildAppBarTitle("Transfer Fund", isDarkMode),
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
        fontSize: 18,
      ),
    );
  }

  Widget buildDoneButton(bool isDarkMode) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
        backgroundColor: isDarkMode ? Colors.white : ColorUtils.loginButton,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        'Download',
        style: TextStyle(
          fontFamily: "Switzer",
          fontSize: 16,
          color: isDarkMode ? Colors.black : Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildDetailsContainer(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Transaction Details",
          style: TextStyle(
            fontFamily: "Switzer",
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Container(
            decoration: BoxDecoration(
                color: isDarkMode
                    ? ColorUtils.transactionHistoryColor
                    : ColorUtils.whiteColor,
                border: Border.all(
                  color: isDarkMode
                      ? ColorUtils.appbarHorizontalLineDark
                      : ColorUtils.appbarHorizontalLineLight,
                )),
            child: buildSuccessDetails(isDarkMode)),
      ],
    );
  }

  Widget buildSuccessDetails(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Buy",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Switzer",
                        color: isDarkMode
                            ? ColorUtils.whiteColor
                            : ColorUtils.appbarBackgroundDark),
                  ),
                  Text(
                    "24 Jul 2024, 8:45 PM",
                    style: TextStyle(
                      color: isDarkMode
                          ? ColorUtils.whiteColor.withOpacity(0.7)
                          : ColorUtils.appbarBackgroundDark.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Switzer",
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "125.00 RP",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Switzer",
                        color: isDarkMode
                            ? ColorUtils.whiteColor
                            : ColorUtils.appbarBackgroundDark),
                  ),
                  Text(
                    "1250.00 USDT",
                    style: TextStyle(
                      color: isDarkMode
                          ? ColorUtils.whiteColor.withOpacity(0.7)
                          : ColorUtils.appbarBackgroundDark.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Switzer",
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Divider(
            color: isDarkMode
                ? ColorUtils.whiteColor.withOpacity(0.24)
                : ColorUtils.appbarHorizontalLineLight),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTransactionDetail('Name', "Parth Shah", isDarkMode),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                      child: _buildTransactionDetail(
                          "Wallet",
                          "0x504f1C1782221194C2cf09BC9620fCC3e6818C55asdsdasdasass",
                          isDarkMode)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(const ClipboardData(
                          text:
                              "0x504f1C1782221194C2cf09BC9620fCC3e6818C55asdsdasdasass"));
                    },
                    child: Image.asset(
                      ImageUtils.copyImg,
                      height: 20,
                      width: 20,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildTransactionDetail(
                  'Amount', "125.00 RP / 1250.00 USDT", isDarkMode),
              const SizedBox(height: 10),
              _buildTransactionDetail(
                  'Transaction Hash',
                  "0x504f1C1782221194C2cf09BC9620fCC3e6818C55asdsdasdasass",
                  isDarkMode,
                  isLink: true),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTransactionCompleteAndFail(bool isDarkMode) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: isDarkMode
              ? ColorUtils.transactionHistoryColor
              : ColorUtils.whiteColor,
          border: Border(
              bottom: BorderSide(
            color: controller.isSuccessAndFailSellAndBuy.value
                ? ColorUtils.indicaterColor1
                : ColorUtils.failColor,
          ))),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Image.asset(
            controller.isSuccessAndFailSellAndBuy.value
                ? "assets/images/checkmark-3.png"
                : "assets/images/checkmark-4.png",
            height: 40,
            width: 40,
            fit: BoxFit.fill,
          ),
          const SizedBox(width: 16),
          Text(
            controller.isSuccessAndFailSellAndBuy.value
                ? 'Transaction Completed!'
                : "Transaction Failed!",
            style: TextStyle(
              color:
                  isDarkMode ? Colors.white : ColorUtils.appbarBackgroundDark,
              fontSize: 20,
              fontFamily: "Switzer",
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetail(String title, String value, bool isDarkMode,
      {bool isLink = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDarkMode
                ? ColorUtils.darkModeGrey2
                : ColorUtils.textFieldBorderColorDark,
            fontWeight: FontWeight.w400,
            fontFamily: "Switzer",
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: isLink ? () => Get.snackbar('Info', 'Link copied!') : null,
          child: Text(
            value,
            style: TextStyle(
              color: isDarkMode
                  ? ColorUtils.whiteColor
                  : ColorUtils.appbarBackgroundDark,
              fontSize: 14,
              fontFamily: "Switzer",
              overflow: TextOverflow.fade,
              decoration:
                  isLink ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}
