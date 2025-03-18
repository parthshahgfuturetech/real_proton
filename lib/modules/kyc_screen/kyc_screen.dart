import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/kyc_screen/kyc_controller.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/theme.dart';
import 'package:real_proton/utils/widgets.dart';

class KycScreen extends StatelessWidget {
  final String? emailAddress;
  KycScreen({super.key, this.emailAddress});

  final ThemeController themeController = Get.find();
  final KycController kycController = Get.put(KycController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      appBar: buildAppBar(isDarkMode),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Obx(()=> buildKycVerification(context,isDarkMode)),
        ));
  }

  Widget buildKycVerification(
      BuildContext context, bool isDarkMode) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle("3. KYC Verification", isDarkMode),
            const SizedBox(height: 20),
            Text(
              "Select Field",
              style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 12,
                  fontFamily: "Switzer",
                  fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                showNetworkSelectionBottomSheet(context, isDarkMode);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kycController.selectedNetwork.value.isEmpty
                        ? ColorUtils.textFieldBorderColorDark
                        : ColorUtils.loginButton,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      kycController.selectedNetwork.value.isEmpty
                          ? "Selected"
                          : kycController.selectedNetwork.value,
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
            ),
            Spacer(),
            CustomWidgets.buildGetStartedButton(
                text: "Next",
                onPressed:kycController.selectedNetwork.value.isEmpty ? null :
                    (){
                      kycController.startKyc(emailAddress);
                }),
          ],
        ),
        if (kycController.isLoading.value)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildTitle(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
          color: isDarkMode ? ColorUtils.whiteColor : ColorUtils.blackColor,
          fontSize: 22,
          fontFamily: "Switzer",
          fontWeight: FontWeight.w600),
    );
  }

  void showNetworkSelectionBottomSheet(
      BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.black,
      builder: (_) {
        return Container(
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
                  'Select Network',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Switzer",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: kycController.networks.length,
                  itemBuilder: (context, index) {
                    final network = kycController.networks[index];
                    return Column(
                      children: [
                        if (index == 0)
                          const Divider(
                            color: ColorUtils.appbarHorizontalLineDark,
                            thickness: 1,
                            height: 1,
                          ),
                        ListTile(
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
                                color: kycController.selectedNetwork.value ==
                                    network['name']
                                    ? ColorUtils.loginButton
                                    : Colors.grey,
                                width: kycController.selectedNetwork.value ==
                                    network['name']
                                    ? 6
                                    : 1,
                              ),
                              color: kycController.selectedNetwork.value ==
                                  network['name']
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                            child: kycController.selectedNetwork.value ==
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
                            kycController.selectedNetwork.value = network['name']!;
                            Get.back();
                          },
                        ),
                        if (index != kycController.networks.length - 1)
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
        );
      },
    );
  }

  AppBar buildAppBar(bool isDarkMode) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor:
      isDarkMode ? ColorUtils.appbarBackgroundDark : Colors.white,
      leading:IconButton(
        icon: Icon(Icons.arrow_back_ios,
            size: 18,
            color: isDarkMode
                ? ColorUtils.whiteColor
                : ColorUtils.blackColor),
        onPressed: () {
          Get.back();
          FocusScope.of(Get.context!).unfocus();
        },
      ),
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isDarkMode
                ? ImageUtils.lendingPageLogoDark
                : ImageUtils.lendingPageLogoLight,
            height: 40,
          ),
        ],
      ),
    );
  }

}
