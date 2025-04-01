import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/botton_bar_options/wallet/transfer_fund__screen/transfer_fund_screen.dart';
import 'package:real_proton/modules/botton_bar_options/wallet/wallet_controller.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/strings.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';

import '../../../utils/theme.dart';
import '../../../utils/widgets.dart';


class WalletScreen extends StatelessWidget {
  final WalletController walletController = Get.put(WalletController());
  final ThemeController themeController = Get.find();
  // final BlockChainController mBlockChainController = Get.put();
  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      body: Obx(() {
        if (walletController.isLoading.value) {
             if (walletController.isLoading.value)
               return Container(
               color: Colors.black.withValues(alpha: 0.7),
              child: CustomWidgets.buildLoader(),
             );
        }
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorUtils.dashBoardAppbar1,
                  ColorUtils.dashBoardAppbar2,
                ],
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                buildShowTotalBalance(context, isDarkMode),
                Container(
                  height: 20,
                  margin: EdgeInsets.symmetric(horizontal: 33),
                  color: const Color.fromRGBO(249, 86, 22, 0.16),
                ),
                buildAssetsText(isDarkMode),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),

                decoration: BoxDecoration(              border:Border.all(
                  color: isDarkMode
                      ? ColorUtils.appbarHorizontalLineDark
                      : ColorUtils.appbarHorizontalLineLight,
                ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: walletController.assets.length,
                    itemBuilder: (context, index) {
                      var e = walletController.assets[index];

                      if (walletController.assets.isEmpty) {
                        return Center(child: Text("No assets available"));
                      }
                      double balance = double.parse("${e['balance']}");
                      String balanceOf = balance.toStringAsFixed(2);
                      return Container(
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? ColorUtils.appbarBackgroundDark
                              : ColorUtils.bottomBarLight,
                          // Completely remove borders inside the list
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildAssetsMainData(
                              image: e["id"] ?? "isEmpty",
                              isDarkMode: isDarkMode,
                              title1: e['id'] ?? "isEmpty",
                              price1: e['id'] ?? "isEmpty",
                              title2: "${balanceOf} ${walletController.buildSortNames(e['id'])}" ?? "isEmpty",
                              price2: e['balance'] ?? "isEmpty",
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildAssetsText(bool isDarkMode) {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(
        "Assets",
        style: TextStyle(
          fontSize: 18,
          color: isDarkMode ? Colors.white : Colors.black,
          fontFamily: "Switzer",
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildAssetsMainData(
      {required String image,
      required bool isDarkMode,
      required String title1,
      required String title2,
      required String price1,
      required String price2}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                walletController.buildSortImages(image),
                height: 45,
                width: 45,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                width: 8,
              ),
              buildAssetsData(
                  isDarkMode,
                  walletController.buildSortNames(title1),
                  walletController.buildSortPrice1(price1),
                  CrossAxisAlignment.start),
            ],
          ),
          buildAssetsData(
              isDarkMode,
              title2,
              walletController.buildSortPrice2(double.parse(price2), title1),
              CrossAxisAlignment.end),
        ],
      ),
    );
  }

  Widget buildAssetsData(bool isDarkMode, String title1, String title2,
      CrossAxisAlignment aliment) {
    return Column(
      crossAxisAlignment: aliment,
      children: [
        Text(
          title1,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: "Switzer",
            fontSize: 16,
            color:
                isDarkMode ? Colors.white : ColorUtils.appbarHorizontalLineDark,
          ),
        ),
        Text(
          title2,
          style: TextStyle(
            color: isDarkMode
                ? ColorUtils.darkModeGrey2
                : ColorUtils.dropDownBackGroundDark,
            fontWeight: FontWeight.w500,
            fontFamily: "Switzer",
            fontSize: 14,
          ),
        )
      ],
    );
  }

  Widget buildShowTotalBalance(BuildContext context, bool isDarkMode) {
    return Container(
      height: 220,
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/wallet-card.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTotalBalanceText(context, isDarkMode),
            buildPriceText(isDarkMode),
            buildCopyText(),
            const SizedBox(
              height: 10,
            ),
            buildButton(
                onTap: () {
                  bottomBarController.currentIndex.value = 2;
                },
                "Invest Now",
                ColorUtils.loginButton,
                Colors.white),
            const SizedBox(
              height: 10,
            ),
            buildSellAndTranserButton()
          ],
        ),
      ),
    );
  }

  Widget buildSellAndTranserButton() {
    return Row(
      children: [
        Expanded(
            child: buildButton(onTap: walletController.totalValue.value == 0.0
               ? (){} :() {
          Get.to(TransferFundsScreen());
        }, "Transfer", walletController.totalValue.value == 0.0 ?Colors.white.withAlpha(140) : Colors.white,
                const Color.fromRGBO(255, 255, 255, 0.24))),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: buildButton(
                onTap: () {},
                "Claim",
                Colors.white,
                const Color.fromRGBO(255, 255, 255, 0.24))),
      ],
    );
  }

  Widget buildButton(String title, Color textcolor1, Color boxcolor2,
      {required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        color: boxcolor2,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: textcolor1,
              fontFamily: "Switzer",
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCopyText() {
    return Row(
      children: [
        Text(
          CustomWidgets.formatAddress(profileController.walletAddress.value),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: "Switzer",
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        GestureDetector(
          onTap: () {
            Clipboard.setData(
                ClipboardData(text: profileController.walletAddress.value));
          },
          child: Image.asset(
            ImageUtils.copyImg,
            height: 18,
            width: 18,
            fit: BoxFit.fill,
          ),
        )
      ],
    );
  }

  Widget buildPriceText(bool isDarkMode) {
    return  Text(
      "\$${walletController.totalValue.value.toStringAsFixed(2)}",
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        fontFamily: "Switzer",
      ),
    );
  }

  Widget buildTotalBalanceText(BuildContext context, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          StringUtils.totalBalance,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: "Switzer",
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: Icon(
                walletController.isBalanceShow.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () {
                showNetworkSelectionBottomSheet(context, isDarkMode);
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Text(
                      walletController.selectedNetwork.value,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Switzer",
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  void showNetworkSelectionBottomSheet(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.black,
      builder: (_) {
        return Obx(
            ()=> Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              color: ColorUtils.appbarBackgroundDark,
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
                  child: const Text(
                    StringUtils.selectNetwork,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: walletController.networks.length,
                    itemBuilder: (context, index) {
                      final network = walletController.networks[index];
                      return Column(
                        children: [
                          if (index == 0)
                            const Divider(
                              color: ColorUtils.appbarHorizontalLineDark,
                              thickness: 1,
                              height: 1,
                            ),
                          ListTile(
                            leading: Image.network("${network['icon']}",height: 30,width: 30,),
                            title: Text(
                              network['name']!,
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: walletController.selectedNetwork.value ==
                                          network['name']
                                      ? ColorUtils.loginButton
                                      : Colors.grey,
                                  width: walletController.selectedNetwork.value ==
                                          network['name']
                                      ? 6
                                      : 1,
                                ),
                                color: walletController.selectedNetwork.value ==
                                        network['name']
                                    ? Colors.black
                                    : Colors.transparent,
                              ),
                              child: walletController.selectedNetwork.value ==
                                      network['name']
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
                              String selectedNetwork = network['name']!;

                              walletController.selectedNetwork.value = network['name']!;
                              blockChainController.updateNetwork(selectedNetwork); // Call updateNetwork
                              walletController.chainId = network['id'] ?? "";
                              // Print selected values
                              print("WalletController selectedNetwork: ${walletController.selectedNetwork.value}");
                              print("BlockChainController selectedNetwork: ${blockChainController.selectedNetwork.value}");

                              Get.back();
                            },
                          ),
                          if (index != walletController.networks.length - 1)
                            const Divider(
                              color: ColorUtils.appbarHorizontalLineDark,
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
          ),
        );
      },
    );
  }
}
