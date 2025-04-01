import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/modules/botton_bar_options/wallet/wallet_controller.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/strings.dart';
import 'package:real_proton/utils/theme.dart';

import '../../../../utils/widgets.dart';
import 'transfer_fund_controller.dart';
import 'transfer_fund_success_and_fail_screen.dart';

class TransferFundsScreen extends StatelessWidget {
  TransferFundsScreen({super.key});

  final WalletController mController = Get.put(WalletController());
  final ThemeController themeController = Get.find();
  var mBalance = 0.0;
  // var assetId="";
  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: buildAppBar(isDarkMode),
      backgroundColor:
          isDarkMode ? Colors.black : ColorUtils.scaffoldBackGroundLight,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () {
            final isKeyboardVisible =
                MediaQuery.of(context).viewInsets.bottom > 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitleText(
                            "Select Asset You Like To Transfer", isDarkMode),
                        const SizedBox(height: 8),
                        buildBottomSheet(context, isDarkMode),
                        const SizedBox(height: 16),
                        buildTitleText("Receiver's Wallet Address", isDarkMode),
                        const SizedBox(height: 8),
                        buildWalletAddressTextField(isDarkMode),
                        const SizedBox(height: 16),
                        buildTitleText("Enter Amount", isDarkMode),
                        const SizedBox(height: 8),
                        buildEnterAmountTextField(isDarkMode),
                        const SizedBox(height: 16),
                        buildTitleText("Remarks", isDarkMode),
                        const SizedBox(height: 8),
                        buildRemarksTextField(isDarkMode),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (!isKeyboardVisible)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: buildTransferButton(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildTitleText(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontFamily: "Switzer",
        color: isDarkMode ? Colors.white : ColorUtils.appbarHorizontalLineDark,
        fontSize: 14,
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

  Widget buildBottomSheet(BuildContext context, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        showNetworkSelectionBottomSheet(context, isDarkMode);
        mController.textController.clear();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: ColorUtils.textFieldBorderColorDark),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              walletController.selected.value.isEmpty
                  ? "Select"
                  : walletController.selected.value,
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            Icon(Icons.keyboard_arrow_down,
                color:
                    isDarkMode ? ColorUtils.whiteColor : ColorUtils.blackColor),
          ],
        ),
      ),
    );
  }

  TextField buildWalletAddressTextField(bool isDarkMode) {
    return TextField(
      onChanged: (value) => mController.walletAddress.value = value,
      decoration: InputDecoration(
        hintText: "Enter Wallet Address",
        hintStyle: TextStyle(
            color:
                isDarkMode ? Colors.grey : ColorUtils.textFieldBorderColorDark),
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: isDarkMode
                  ? Colors.grey
                  : ColorUtils.appbarHorizontalLineLight),
          borderRadius: BorderRadius.circular(1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide: BorderSide(
              color: isDarkMode
                  ? Colors.grey
                  : ColorUtils.appbarHorizontalLineLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide: BorderSide(color: ColorUtils.loginButton),
        ),
        filled: true,
        fillColor: isDarkMode ? Colors.black : ColorUtils.whiteColor,
      ),
    );
  }

  Widget buildEnterAmountTextField(bool isDarkMode) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
                color: isDarkMode
                    ? Colors.grey
                    : ColorUtils.appbarHorizontalLineLight),
            color: isDarkMode ? Colors.black : Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      child: TextField(
                        controller: mController.textController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: "Switzer",
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? ColorUtils.darkModeGrey2
                              : ColorUtils.textFieldBorderColorDark,
                        ),
                        decoration: const InputDecoration(
                          hintText: "0.0",
                          contentPadding: EdgeInsets.only(bottom: 5),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          MaxValueAmount(value,
                              mController.buildSortPrice1(mController.assetId));
                        },
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "~\$${calculateTotalAmount(mController.textController, mController.buildSortPrice1(mController.assetId)).toStringAsFixed(2)}",
                      style: TextStyle(
                        fontFamily: "Switzer",
                        fontSize: 14,
                        color: isDarkMode
                            ? ColorUtils.darkModeGrey2
                            : ColorUtils.forgotPasswordTextDark,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: ColorUtils.loginButton,
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    onPressed: () {
                      // controller.transferAmount.value = controller.maxBalance.value;

                      mController.textController.text = mController
                          .buildSortPrice2(mBalance, mController.assetId);
                      // print("balnceUpdate----${balnceUpdate}");
                    },
                    child: const Text(
                      "Max",
                      style: TextStyle(
                        fontFamily: "Switzer",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.loginButton,
                      ),
                    ),
                  ),
                  Text(
                    "Balance: ${mController.buildSortPrice2(mBalance, mController.assetId)} CELO",
                    style: TextStyle(
                      color: isDarkMode
                          ? ColorUtils.darkModeGrey2
                          : ColorUtils.forgotPasswordTextDark,
                      fontFamily: "Switzer",
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget buildRemarksTextField(bool isDarkMode) {
    return TextField(
      onChanged: (value) => mController.remarks.value = value,
      decoration: InputDecoration(
        hintText: "Remarks",
        hintStyle: TextStyle(
            color:
                isDarkMode ? Colors.grey : ColorUtils.textFieldBorderColorDark),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide: BorderSide(
              color: isDarkMode
                  ? Colors.grey
                  : ColorUtils.appbarHorizontalLineLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide: BorderSide(
              color: isDarkMode
                  ? Colors.grey
                  : ColorUtils.appbarHorizontalLineLight),
        ),
        filled: true,
        fillColor: isDarkMode ? Colors.black : ColorUtils.whiteColor,
      ),
    );
  }

  Widget buildTransferButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorUtils.loginButton,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        onPressed: () {
          // controller.isSuccessAndFail.value = true;
          // Get.to(()=>TransferFundsSuccessAndFailScreen());

          if (mController.walletAddress.value.isEmpty &&
              walletController.selected.value.isEmpty) {
            CustomWidgets.showInfo(
                context: Get.context!,
                message: "Wallet Address and Selected Value are missing");
          } else if (mController.walletAddress.value.isEmpty) {
            CustomWidgets.showInfo(
                context: Get.context!, message: "Wallet Address is missing");
          } else if (walletController.selected.value.isEmpty) {
            CustomWidgets.showInfo(
                context: Get.context!, message: "Selected Value is missing");
          } else if (mController.textController.value.text.isEmpty) {
            CustomWidgets.showInfo(
                context: Get.context!, message: "Amount Value is missing");
          } else {
            walletController.getAllAddressApi(
                walletsAddress: mController.walletAddress.value);
          }
        },
        child: const Text(
          "Transfer Funds",
          style: TextStyle(
            fontFamily: "Switzer",
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void showNetworkSelectionBottomSheet(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            color: isDarkMode
                ? ColorUtils.appbarBackgroundDark
                : ColorUtils.bottomBarLight,
            border: const Border(
              top: BorderSide(
                color: ColorUtils.appbarHorizontalLineDark,
              ),
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 23, vertical: 15),
                child: Text(
                  'Select Assets',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontFamily: "Switzer",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: walletController.assets.length,
                  itemBuilder: (context, index) {
                    final asset = walletController.assets[index];
                    bool isSelected = walletController.selected.value ==
                        walletController.buildSortNames(asset['id']);

                    return Column(
                      children: [
                        if (index == 0)
                          Divider(
                            color: isDarkMode
                                ? ColorUtils.appbarHorizontalLineDark
                                : ColorUtils.appbarHorizontalLineLight,
                            thickness: 1,
                            height: 1,
                          ),
                        ListTile(
                          leading: Image.asset(
                            walletController.buildSortImages(asset['id']),
                            height: 30,
                            width: 30,
                          ),
                          title: Text(
                            walletController.buildSortNames(asset['id']),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Switzer",
                              color: isDarkMode
                                  ? Colors.white
                                  : ColorUtils.appbarHorizontalLineDark,
                            ),
                          ),
                          trailing: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? ColorUtils.loginButton
                                    : Colors.grey,
                                width: isSelected ? 6 : 1,
                              ),
                              color: isSelected
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isDarkMode
                                            ? ColorUtils.whiteColor
                                            : ColorUtils.blackColor,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          onTap: () {
                            walletController.selected.value =
                                walletController.buildSortNames(asset['id']);
                            mController.assetId = asset['id'];
                            mBalance = double.parse(asset['balance']);
                            print(
                                "balance_print---->> ${mController.balance}--${asset['balance']}");
                            print(
                                " mController.assetId ---->> ${mController.assetId}");
                            Get.back();
                          },
                        ),
                        if (index != walletController.assets.length - 1)
                          Divider(
                            color: isDarkMode
                                ? ColorUtils.appbarHorizontalLineDark
                                : ColorUtils.appbarHorizontalLineLight,
                            thickness: 1,
                            height: 1,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double calculateTotalAmount(
      TextEditingController controller, String assetPrice) {
    print("controller----${controller}== ${assetPrice}");
    double inputValue = double.tryParse(controller.text) ?? 0.0;
    double assetValue = double.tryParse(assetPrice) ?? 0.0;
    return inputValue * assetValue;
  }

  double MaxValueAmount(String value, String assetPrice) {
    print("MaxValueAmount----$value $assetPrice");
    double inputValue = double.tryParse(value) ?? 0.0;
    double assetValue = double.tryParse(assetPrice) ?? 0.0;
    return inputValue * assetValue;
  }
}
