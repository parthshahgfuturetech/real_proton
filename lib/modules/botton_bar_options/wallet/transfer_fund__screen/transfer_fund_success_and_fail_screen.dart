import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/botton_bar_options/wallet/transfer_fund__screen/transfer_fund_controller.dart';
import 'package:real_proton/modules/botton_bar_options/wallet/wallet_controller.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/theme.dart';

class TransferFundsSuccessAndFailScreen extends StatelessWidget {
  TransferFundsSuccessAndFailScreen({super.key});

  final ThemeController themeController = Get.find();
  final WalletController controller = Get.put(WalletController());

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
          ()=> Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildTransactionCompleteAndFail(isDarkMode),
              const SizedBox(height: 32),
              buildDetailsContainer(isDarkMode),
              const Spacer(),
              buildDoneButton(),
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
      actions: [buildNotificationButton(isDarkMode)],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 18),
        onPressed: () => Get.back(),
      ),
      centerTitle: true,
      title: Container(
          margin: const EdgeInsets.only(left: 10),
          child: buildAppBarTitle("Transfer Fund", isDarkMode),
      ),
    );
  }

  Widget buildNotificationButton(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Image.asset(
        isDarkMode ? ImageUtils.notificationDark : ImageUtils.notificationLight,
        height: 25,
        width: 25,
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

  Widget buildDoneButton() {
    return ElevatedButton(
      onPressed: () {
        controller.isSuccessAndFail.value = false;
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        controller.isSuccessAndFail.value ? 'Done' :"Try Again",
        style: const TextStyle(
          fontFamily: "Switzer",
          fontSize: 16,
          color: Colors.black,
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: isDarkMode ?  ColorUtils.transactionHistoryColor : ColorUtils.whiteColor,
              border: Border.all(
                color: isDarkMode
                    ? ColorUtils.appbarHorizontalLineDark
                    : ColorUtils.appbarHorizontalLineLight,
              )),
          child: controller.isSuccessAndFail.value
              ? buildSuccessDetails(isDarkMode)
              : buildFailDetails(isDarkMode),
        ),
      ],
    );
  }

  Widget buildSuccessDetails(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Row(
          children: [
            Flexible(
                child: _buildTransactionDetail("Recipient Address",
                    "0x504f1C1782221194C2cf09BC9620fCC3e6818C55asdsdasdasass",isDarkMode)),
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
        _buildTransactionDetail('Amount', "125.00 RP / 1250.00 USDT",isDarkMode),
        const SizedBox(height: 16),
        _buildTransactionDetail('Transaction Hash',
            "0x504f1C1782221194C2cf09BC9620fCC3e6818C55asdsdasdasass",isDarkMode,
            isLink: true),
        const SizedBox(height: 16),
        _buildTransactionDetail('Date & Time', "January 11, 2025, 3:45 PM UTC",isDarkMode),
      ],
    );
  }

  Widget buildFailDetails(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTransactionDetail(
            'Transaction Hash', "0x504f1C1782221194C2cf09BC9620fCC3e6818C55",isDarkMode,
            isLink: true),
        const SizedBox(height: 16),
        _buildTransactionDetail('Date & Time', "January 11, 2025, 3:45 PM UTC",isDarkMode),
      ],
    );
  }

  Widget buildTransactionCompleteAndFail(bool isDarkMode) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: isDarkMode ? ColorUtils.transactionHistoryColor : ColorUtils.whiteColor,
          border: Border(
              bottom: BorderSide(
            color: controller.isSuccessAndFail.value
                ? ColorUtils.indicaterColor1
                : ColorUtils.failColor,
          ))),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Image.asset(
            controller.isSuccessAndFail.value
                ? "assets/images/checkmark-3.png"
                : "assets/images/checkmark-4.png",
            height: 40,
            width: 40,
            fit: BoxFit.fill,
          ),
          const SizedBox(width: 16),
          Text(
            controller.isSuccessAndFail.value
                ? 'Transaction Completed!'
                : "Transaction Failed!",
            style: TextStyle(
              color: isDarkMode ? Colors.white : ColorUtils.appbarBackgroundDark,
              fontSize: 20,
              fontFamily: "Switzer",
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetail(String title, String value,bool isDarkMode,
      {bool isLink = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDarkMode ? ColorUtils.darkModeGrey2 : ColorUtils.textFieldBorderColorDark,
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
              color:  isDarkMode ? ColorUtils.whiteColor : ColorUtils.appbarBackgroundDark,
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
