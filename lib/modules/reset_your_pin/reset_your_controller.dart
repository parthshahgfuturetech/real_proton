import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/modules/api_services/api_services.dart';
import 'package:real_proton/modules/kyc_screen/kyc_controller.dart';
import 'package:real_proton/utils/apis.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/strings.dart';
import 'package:real_proton/utils/widgets.dart';

class ResetYourPinController extends GetxController
    with WidgetsBindingObserver {
  RxString kycStatus = 'Not Verified'.obs,
      walletStatus = 'Whitelisted'.obs,
      walletAddress = ''.obs,
      phoneNumber = ''.obs,
      kycApplicantId = ''.obs,
      kycReviewAnswer = ''.obs,
      kycRejectType = ''.obs,
      countryCodeNumber = ''.obs,
      textPhoneNumber = ''.obs;
  RxBool isStartWallet = true.obs,
      isVerifiedEmail = false.obs,
      isPhoneNumberVerified = false.obs,
      isLoading = false.obs;
  bool isEmailVerified = false;
  String chainId = '';
  String assetsId = '';
  var mobileNumber = ''.obs;
  var isFocused = false.obs;  // Track focus state

  final phoneController = TextEditingController();
  ValueNotifier<String> countryCode = ValueNotifier("+1");
  final ApiService apiServiceClass = ApiService();
  final Logger _logger = Logger();
  final FocusNode focusNode = FocusNode();
  KycController kycController = Get.put(KycController());

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> onRefreshData() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 3), () {
    });
    isLoading.value = false;
  }

  buildOtpFields(BuildContext context, bool isDarkMode) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text(
              //   "Enter OTP",
              //   style: TextStyle(
              //     color: isDarkMode
              //         ? ColorUtils.whiteColor
              //         : ColorUtils.blackColor,
              //     fontSize: 22,
              //     fontFamily: "Switzer",
              //     fontWeight: FontWeight.w400,
              //   ),
              // ),
              // Text(
              //   "We’ve sent a code to ${countryCode.value}${phoneController.text}",
              //   style: TextStyle(
              //     color: isDarkMode
              //         ? ColorUtils.darkModeGrey2
              //         : ColorUtils.blackColor,
              //     fontSize: 14,
              //     fontFamily: "Switzer",
              //     fontWeight: FontWeight.w400,
              //   ),
              // ),
              const SizedBox(height: 15),
              PinCodeTextField(
                appContext: context,
                cursorColor: isDarkMode ? Colors.white : Colors.black,
                animationType: AnimationType.none,
                blinkDuration: Duration.zero,
                animationDuration: Duration.zero,
                enableActiveFill: true,
                autoDismissKeyboard: false,
                autoFocus: true,
                keyboardType: TextInputType.number,
                length: 6,
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontFamily: "Switzer",
                ),
                pinTheme: PinTheme(
                  inactiveFillColor: isDarkMode
                      ? ColorUtils.appbarBackgroundDark
                      : ColorUtils.bottomBarLight,
                  selectedFillColor: isDarkMode
                      ? ColorUtils.appbarBackgroundDark
                      : ColorUtils.bottomBarLight,
                  inactiveColor: ColorUtils.textFieldBorderColorDark,
                  selectedColor: ColorUtils.loginButton,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(1),
                  fieldHeight: 45,
                  fieldWidth: 45,
                  borderWidth: 1,
                  activeBorderWidth: 1,
                  inactiveBorderWidth: 1,
                  activeColor: ColorUtils.textFieldBorderColorDark,
                  activeFillColor: isDarkMode
                      ? ColorUtils.appbarBackgroundDark
                      : ColorUtils.bottomBarLight,
                ),
                onChanged: (value) {
                  // print("Pressed onComplte:-$value");
                  textPhoneNumber.value = value;
                  // phoneOtpRecivie(value);
                },
              ),
              buildResend(isDarkMode),

            ],
          ),
        ),
        if (isLoading.value)
          Container(
            color: Colors.black.withOpacity(0.7),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
  Widget buildResend(bool isDarkMode) {
    return GestureDetector(
      onTap: () {},
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          "Resend OTP",
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 14,
            fontFamily: 'Switzer',
            fontWeight: FontWeight.w500,
            color: isDarkMode
                ? ColorUtils.textFieldBorderColorDark
                : ColorUtils.darkModeGrey2,
          ),
        ),
      ),
    );
  }





}
