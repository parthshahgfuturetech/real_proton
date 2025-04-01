import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/history/history_controller.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/theme.dart';
import 'package:real_proton/utils/widgets.dart';

class TransferHistoryScreen extends StatelessWidget {
  final Map<String, dynamic> decryptedData;
  final String firstName;

  TransferHistoryScreen({
    required this.decryptedData,
    required this.firstName,
    Key? key
  }) : super(key: key);
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildTransactionCompleteAndFail(isDarkMode),
                        const SizedBox(height: 32),
                        buildDetailsContainer(isDarkMode),
                      ],
                    ),
                  ),
                ),
                CustomWidgets.buildGetStartedButton(
                    text: 'Download', onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(bool isDarkMode) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: isDarkMode
          ? ColorUtils.appbarBackgroundDark
          : ColorUtils.scaffoldBackGroundLight,
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
          size: 18,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        onPressed: () => Get.back(),
      ),
      centerTitle: true,
      title: Container(
        margin: const EdgeInsets.only(left: 10),
        child: buildAppBarTitle("Transaction History", isDarkMode),
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
        fontWeight: FontWeight.w600,
        fontFamily: "Switzer",
        fontSize: 22,
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
    String formattedDate = "N/A"; // Default value to prevent uninitialized error

    int timestamp = decryptedData['createdAt']; // Ensure it's an int

    if (timestamp > 0) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

      formattedDate =
      "${date.day} ${CustomWidgets.getMonthName(date.month)} ${date.year}, "
          "${CustomWidgets.formatHour(date.hour)}:${CustomWidgets.formatMinute(date.minute)} ${CustomWidgets.getPeriod(date.hour)}";

      print(formattedDate); // Check the output
    } else {
      print("Invalid timestamp");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Transferred",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Switzer",
                        color: isDarkMode
                            ? ColorUtils.whiteColor
                            : ColorUtils.appbarBackgroundDark),
                  ),
                  Text(
                    "${formattedDate}",
                    style: TextStyle(
                      color: isDarkMode
                          ? ColorUtils.whiteColor
                          : ColorUtils.appbarBackgroundDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Switzer",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 2,
          color: isDarkMode
              ? ColorUtils.whiteColor.withAlpha(50)
              : ColorUtils.appbarHorizontalLineLight,
        ),
        buildFiatSuccessTransaction(isDarkMode),
      ],
    );
  }

  Widget buildCryptoSuccessTransaction(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTransactionDetail('Name', "Parth Shah", isDarkMode),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: _buildTransactionDetail(
                    'From',
                    "0x504f1C1782221194C2cf09BC9620fCC3e6818C55asdsdasdasass",
                    isDarkMode),
              ),
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
          Row(
            children: [
              Flexible(
                  child: _buildTransactionDetail(
                      "To",
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
          _buildTransactionDetail('Transaction Hash',
              "0x504f17822211jkjkj94C2cf09BC9620fCC3e68", isDarkMode,
              isLink: true),
          const SizedBox(height: 10),
          _buildTransactionDetail(
              'Transaction Fee', "0.000365 CELO", isDarkMode),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildFiatSuccessTransaction(bool isDarkMode) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTransactionDetail('Name', firstName, isDarkMode),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: _buildTransactionDetail(
                    'Payment Id',
                    "${decryptedData['paymentId']}",
                    isDarkMode,
                    isLink: true),
              ),
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
          Row(
            children: [
              Flexible(
                  child: _buildTransactionDetail(
                      "Wallet",
                      "${decryptedData['walletAddress']}",
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
              'Amount', "\$ ${decryptedData['amount_total']}", isDarkMode),
          const SizedBox(height: 10),
        ],
      ),
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
              fontSize: 16,
              fontWeight: FontWeight.w500,
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
