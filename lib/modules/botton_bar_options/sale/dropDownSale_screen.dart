import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/botton_bar_options/sale/sale_controller.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/theme.dart';

class CustomizedDropdown extends StatelessWidget {
  final ThemeController themeController = Get.find();
  final SaleController controller = Get.put(SaleController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final LayerLink layerLink = LayerLink();
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                buildImageCompositedTransformTarget(layerLink,isDarkMode),
                controller.isDropdownOpen.value
                    ? buildTextCompositedTransformFollower(layerLink,isDarkMode)
                    : const SizedBox(),
                Text(
                  '${controller.usdtBalance.value} ${controller.selectedCurrency.value}',
                  style: TextStyle(color: isDarkMode
                      ? ColorUtils.darkModeGrey2
                      : ColorUtils.textFieldBorderColorDark,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 40,
              child: TextField(
                  controller: controller.textController,
                  onChanged: (value) {
                    controller.calculate(value);
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:  isDarkMode
                        ? ColorUtils.darkModeGrey2
                        : ColorUtils.textFieldBorderColorDark,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.0',
                    border: InputBorder.none,
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextCompositedTransformFollower(LayerLink layerLink,bool isDarkMode) {
    return CompositedTransformFollower(
      link: layerLink,
      offset: const Offset(0, 50),
      child: Container(
        width: 100,
        child: Material(
          elevation: 4,
          color:isDarkMode ? ColorUtils.dropDownBackGroundDark
              :ColorUtils.appbarHorizontalLineLight,
          borderRadius: BorderRadius.circular(10),
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: ['USDT', 'BTC', 'ETH'].map((option) {
              return GestureDetector(
                onTap: () {
                  controller.selectCurrency(option);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(
                          getCurrencyImage(option),
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        option,
                        style: TextStyle(color:isDarkMode
                            ? ColorUtils.darkModeGrey2
                            : ColorUtils.textFieldBorderColorDark,),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget buildImageCompositedTransformTarget(LayerLink layerLink, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: Get.context!,
          backgroundColor: isDarkMode
              ? ColorUtils.appbarBackgroundDark
              : ColorUtils.bottomBarLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return buildCurrencySelectionSheet(isDarkMode);
          },
        );
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isDarkMode
              ? ColorUtils.dropDownBackGroundDark
              : ColorUtils.appbarHorizontalLineLight,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              child: Image.asset(
                getCurrencyImage(controller.selectedCurrency.value),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCurrencySelectionSheet(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text(
            'Select Method',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: controller.currencies.length,
          itemBuilder: (context, index) {
            String currency = controller.currencies[index];

            return Column(
              children: [
                if (index == 0)
                  const Divider(
                    color: ColorUtils.appbarHorizontalLineDark,
                    thickness: 1,
                    height: 1,
                  ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset(getCurrencyImage(currency)),
                  ),
                  trailing: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: controller.selectedCurrency.value == currency
                            ? ColorUtils.loginButton
                            : Colors.grey,
                        width: controller.selectedCurrency.value == currency ? 6 : 1,
                      ),
                      color: controller.selectedCurrency.value == currency
                          ? Colors.black
                          : Colors.transparent,
                    ),
                    child: controller.selectedCurrency.value == currency
                        ? Center(
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDarkMode ? ColorUtils.whiteColor : ColorUtils.blackColor,
                        ),
                      ),
                    )
                        : null,
                  ),
                  title: Text(
                    currency,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  onTap: () {
                    controller.selectCurrency(currency);
                    Get.back();
                  },
                ),
                if (index != controller.currencies.length - 1)
                  const Divider(
                    color: ColorUtils.appbarHorizontalLineDark,
                    thickness: 1,
                    height: 1,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  String getCurrencyImage(String currency) {
    switch (currency) {
      case 'USDC':
        return ImageUtils.btc;
      case 'USD':
        return ImageUtils.eth;
      default: // USDT as default
        return ImageUtils.usdt;
    }
  }
}
