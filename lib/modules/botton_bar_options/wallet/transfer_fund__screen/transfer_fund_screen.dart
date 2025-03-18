import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/strings.dart';
import 'package:real_proton/utils/theme.dart';

import 'transfer_fund_controller.dart';
import 'transfer_fund_success_and_fail_screen.dart';

class TransferFundsScreen extends StatelessWidget {
  TransferFundsScreen({super.key});

  final TransferFundsController controller = Get.put(TransferFundsController());
  final ThemeController themeController = Get.find();

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
                final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
                return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTitleText( "Select Asset You Like To Transfer",isDarkMode),
                      const SizedBox(height: 8),
                      buildBottomSheet(context, isDarkMode),
                      const SizedBox(height: 16),
                      buildTitleText( "Receiver's Wallet Address",isDarkMode),
                      const SizedBox(height: 8),
                      buildWalletAddressTextField(isDarkMode),
                      const SizedBox(height: 16),
                      buildTitleText("Enter Amount",isDarkMode),
                      const SizedBox(height: 8),
                      buildEnterAmountTextField(isDarkMode),
                      const SizedBox(height: 16),
                      buildTitleText("Remarks",isDarkMode),
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

  Widget buildTitleText(String title,bool isDarkMode) {
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
        icon: Icon(Icons.arrow_back_ios, size: 18,color: isDarkMode ? Colors.white : Colors.black,),
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
      onTap: () => showNetworkSelectionBottomSheet(context, isDarkMode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
              color: controller.selectedAsset.value.isEmpty
                  ? ColorUtils.textFieldBorderColorDark
                  : ColorUtils.loginButton),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.selectedAsset.value.isEmpty
                  ? "Select"
                  : controller.selectedAsset.value,
              style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black),
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
      onChanged: (value) => controller.walletAddress.value = value,
      decoration: InputDecoration(
        hintText: "Enter Wallet Address",
        hintStyle:  TextStyle(color: isDarkMode ? Colors.grey : ColorUtils.textFieldBorderColorDark),
        border: OutlineInputBorder(
          borderSide:  BorderSide(color: isDarkMode ? Colors.grey :ColorUtils.appbarHorizontalLineLight),
          borderRadius: BorderRadius.circular(1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide:  BorderSide(color: isDarkMode ? Colors.grey :ColorUtils.appbarHorizontalLineLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide:  BorderSide(color: Colors.orange),
        ),
        filled: true,
        fillColor: isDarkMode ? Colors.black : ColorUtils.whiteColor,
      ),
    );
  }

  Widget buildEnterAmountTextField(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: isDarkMode ? Colors.grey : ColorUtils.appbarHorizontalLineLight),
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
                    controller: controller.textController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Switzer",
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? ColorUtils.darkModeGrey2
                          : ColorUtils.textFieldBorderColorDark,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 5),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "~\$345.65",
                  style: TextStyle(
                    fontFamily: "Switzer",
                    fontSize: 14,
                    color: isDarkMode ? ColorUtils.darkModeGrey2 : ColorUtils.forgotPasswordTextDark,
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
                  controller.transferAmount.value = controller.maxBalance.value;
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
                "Balance: ${controller.maxBalance.value} CELO",
                style: TextStyle(
                  color: isDarkMode ? ColorUtils.darkModeGrey2 : ColorUtils.forgotPasswordTextDark,
                  fontFamily: "Switzer",
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildRemarksTextField(bool isDarkMode) {
    return TextField(
      onChanged: (value) => controller.remarks.value = value,
      decoration: InputDecoration(
        hintText: "Remarks",
        hintStyle:  TextStyle(color: isDarkMode ? Colors.grey : ColorUtils.textFieldBorderColorDark),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide:  BorderSide(color: isDarkMode ? Colors.grey :ColorUtils.appbarHorizontalLineLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide:  BorderSide(color: isDarkMode ? Colors.grey :ColorUtils.appbarHorizontalLineLight),
        ),
        filled: true,
        fillColor: isDarkMode ? Colors.black :ColorUtils.whiteColor,
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
          controller.isSuccessAndFail.value = true;
          Get.to(()=>TransferFundsSuccessAndFailScreen());
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
            color: isDarkMode ? ColorUtils.appbarBackgroundDark : ColorUtils.bottomBarLight,
            border: const Border(
                top: BorderSide(
              color: ColorUtils.appbarHorizontalLineDark,
            )),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 23, vertical: 15),
                child: Text(
                  'Select Network',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white :Colors.black,
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
                  itemCount: controller.assets.length,
                  itemBuilder: (context, index) {
                    final asset = controller.assets[index];
                    return Column(
                      children: [
                        if (index == 0)
                          Divider(
                            color: isDarkMode ? ColorUtils.appbarHorizontalLineDark : ColorUtils.appbarHorizontalLineLight,
                            thickness: 1,
                            height: 1,
                          ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(asset['icon']!),
                          ),
                          title: Text(
                            asset['name']!,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                                fontFamily: "Switzer",
                                color: isDarkMode ? Colors.white : ColorUtils.appbarHorizontalLineDark),
                          ),
                          trailing: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: controller.selectedAsset.value ==
                                        asset['name']!
                                    ? Colors.orange
                                    : Colors.grey,
                                width: controller.selectedAsset.value ==
                                        asset['name']!
                                    ? 6
                                    : 1,
                              ),
                              color: controller.selectedAsset.value ==
                                      asset['name']!
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                            child:
                                controller.selectedAsset.value == asset['name']!
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
                            controller.selectedAsset.value = asset['name']!;
                            Get.back();
                          },
                        ),
                        if (index != controller.assets.length - 1)
                          Divider(
                            color: isDarkMode ? ColorUtils.appbarHorizontalLineDark : ColorUtils.appbarHorizontalLineLight,
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
}
