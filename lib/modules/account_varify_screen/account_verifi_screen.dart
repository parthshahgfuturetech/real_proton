import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/account_varify_screen/account_verifi_controller.dart';
import 'package:real_proton/modules/forgot_password_screen/send_email_box.dart';
import 'package:real_proton/modules/kyc_screen/kyc_screen.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/strings.dart';
import 'package:real_proton/utils/theme.dart';
import 'package:real_proton/utils/widgets.dart';

class AccountVerificationScreen extends StatelessWidget {
  AccountVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final AccountVerificationController accountDetailsController =
        Get.put(AccountVerificationController());
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: buildAppBar(isDarkMode, accountDetailsController),
        backgroundColor:
            isDarkMode ? Colors.black : ColorUtils.scaffoldBackGroundLight,
        body: Obx(
          () => Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => accountDetailsController.onRefreshData(),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        children: [
                          const SizedBox(height: 30),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Verify Your Email Address",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Switzer",
                                    color: isDarkMode
                                        ? ColorUtils.indicaterGreyLight
                                        : ColorUtils.appbarHorizontalLineDark,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                buildCustomTextField(
                                  isDarkMode: isDarkMode,
                                  controller:
                                      accountDetailsController.emailController,
                                  hintText2: "exz@gmail.com",
                                  isVerifiedEmail: accountDetailsController
                                      .isVerifiedEmail.value,
                                  onTap: accountDetailsController
                                          .isVerifiedEmail.value
                                      ? null
                                      : () {
                                          accountDetailsController
                                              .emailVerification(context);
                                          buildShowDialogBox(
                                              context, accountDetailsController);
                                        },
                                ),
                                const SizedBox(height: 10),
                                buildMobileNumberField(
                                  accountDetailsController:
                                      accountDetailsController,
                                  context: context,
                                  isDarkMode: isDarkMode,
                                  boxDecoration: const BoxConstraints(
                                    minWidth: 0,
                                    minHeight: 0,
                                  ),
                                  suffixIcon: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: accountDetailsController
                                            .isPhoneNumberVerified.value
                                        ? null
                                        : () async {
                                            FocusScope.of(context).unfocus();
                                            if (accountDetailsController
                                                .phoneController.text.isEmpty) {
                                              CustomWidgets.showError(
                                                  context: context,
                                                  message:
                                                      "PhoneNumber is Empty");
                                              return;
                                            }
                                            if (accountDetailsController
                                                    .phoneController.text.length <
                                                10) {
                                              CustomWidgets.showError(
                                                  context: context,
                                                  message:
                                                      "PhoneNumber is invalid");
                                              return;
                                            }
                                            bool isVerified =
                                                await accountDetailsController
                                                    .phoneVerificationAPi(
                                                        context,
                                                        accountDetailsController
                                                            .phoneController.text,
                                                        accountDetailsController
                                                            .countryCode.value,
                                                        false);
                                            if (!isVerified) {
                                              CustomWidgets.showError(
                                                  context: context,
                                                  message:
                                                      "Provided Mobile Number is Already Registered");
                                              return;
                                            }

                                            accountDetailsController.phoneSendOtp(
                                                context, isDarkMode,
                                                mobileNumber:
                                                    "${accountDetailsController.countryCode.value}${accountDetailsController.phoneController.text}");
                                          },
                                    child: accountDetailsController
                                            .isPhoneNumberVerified.value
                                        ? Container(
                                            height: 30,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            padding: const EdgeInsets.only(
                                                top: 5, left: 5, right: 5),
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  16, 185, 129, 0.45),
                                            ),
                                            child: const Text(
                                              "Verified",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Switzer",
                                                color: Color.fromRGBO(
                                                    16, 185, 129, 1),
                                              ),
                                            ),
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.only(right: 8.0),
                                            child: Text(
                                              "Get Code",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Switzer",
                                                color: ColorUtils.loginButton,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Divider(
                            height: 1.5,
                            color: isDarkMode
                                ? ColorUtils.dropDownBackGroundDark
                                : ColorUtils.appbarHorizontalLineLight,
                          ),
                          const SizedBox(height: 30),
                          buildKycStatusContainer(
                              isDarkMode, accountDetailsController),
                          buildWalletStatusContainer(
                              isDarkMode, accountDetailsController),
                          const SizedBox(height: 30),
                          buildEnable2FA(isDarkMode),
                        ],
                      ),
                    ),
                  ),
                  buildKycButton(accountDetailsController),
                ],
              ),
              if (accountDetailsController.isLoading.value)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.7),
                    child: CustomWidgets.buildLoader(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void buildShowDialogBox(BuildContext context,
      AccountVerificationController accountDetailsController) {
    String email = accountDetailsController.emailController.text.trim();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black12.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: EmailSentScreen(
            email: email,
            onPressButton: () {
              Get.back();
            },
          ),
        );
      },
    );
  }

  Widget buildMobileNumberField({
    required AccountVerificationController accountDetailsController,
    Widget? suffixIcon,
    BoxConstraints? boxDecoration,
    required BuildContext context,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Verify Your Mobile Number",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: "Switzer",
              color: isDarkMode
                  ? ColorUtils.indicaterGreyLight
                  : ColorUtils.appbarHorizontalLineDark,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? ColorUtils.appbarBackgroundDark
                  : ColorUtils.whiteColor,
              border: Border.all(
                color: accountDetailsController.focusNode.hasFocus
                    ? ColorUtils.loginButton
                    : (isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade400),
              ),
            ),
            child: Row(
              children: [
                CountryCodePicker(
                  onChanged: (countryCode) {
                    accountDetailsController.countryCode.value =
                        countryCode.dialCode ?? "+1";
                    print(
                        "Selected Country Code: ${accountDetailsController.countryCode.value}");
                    FocusScope.of(context).requestFocus();
                  },
                  boxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: isDarkMode
                        ? ColorUtils.blackColor
                        : ColorUtils.whiteColor,
                  ),
                  backgroundColor: isDarkMode
                      ? ColorUtils.whiteColor
                      : ColorUtils.blackColor,
                  flagWidth: 20,
                  initialSelection:
                      accountDetailsController.countryCode.value,
                  showFlag: true,
                  showDropDownButton: true,
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  searchDecoration: InputDecoration(
                    hintText: "Search Country code",
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 2, vertical: 10),
                  textStyle: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: accountDetailsController.phoneController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    focusNode: accountDetailsController.focusNode,
                    readOnly:
                        accountDetailsController.isPhoneNumberVerified.value,
                    onTap: () {
                      FocusScope.of(context).requestFocus();
                    },
                    decoration: InputDecoration(
                      counterText: "",
                      suffixIcon: suffixIcon,
                      suffixIconConstraints: boxDecoration,
                      hintText: "Enter your mobile number",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                      ),
                    ),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                    cursorColor: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCustomTextField({
    required TextEditingController controller,
    required String hintText2,
    required bool isDarkMode,
    VoidCallback? onTap,
    required bool isVerifiedEmail,
  }) {
    return Container(
      color:
          isDarkMode ? ColorUtils.appbarBackgroundDark : ColorUtils.whiteColor,
      child: CustomWidgets.customTextField(
        controller: controller,
        hintText2: hintText2,
        readOnly: true,
        suffixIcon: isVerifiedEmail
            ? Container(
                height: 30,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(16, 185, 129, 0.45),
                ),
                child: const Text(
                  "Verified",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Switzer",
                    color: Color.fromRGBO(16, 185, 129, 1),
                  ),
                ),
              )
            : GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onTap ?? () {},
                child: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text(
                    "Verify",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: ColorUtils.loginButton,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Switzer",
                      color: ColorUtils.loginButton,
                    ),
                  ),
                ),
              ),
        boxDecoration: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
        isDarkMode: isDarkMode,
      ),
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

  Widget buildWalletStatusContainer(
      bool isDarkMode, AccountVerificationController accountDetailsController) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorUtils.appbarBackgroundDark
            : ColorUtils.whiteColor,
        border: Border.all(
          color: isDarkMode
              ? ColorUtils.appbarHorizontalLineDark
              : ColorUtils.appbarHorizontalLineLight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                isDarkMode
                    ? ImageUtils.profileImg10
                    : ImageUtils.profileImageLight10,
                height: 40,
                width: 40,
                fit: BoxFit.fill,
              ),
              const SizedBox(width: 10),
              Text(
                'Your Wallet Status',
                style: TextStyle(
                  color: isDarkMode
                      ? ColorUtils.indicaterGreyLight
                      : ColorUtils.appbarHorizontalLineDark,
                  fontSize: 14,
                  fontFamily: "Switzer",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: accountDetailsController.isWhiteListed.value
                  ?const Color.fromRGBO(16, 185, 129, 0.45)
                  : const Color.fromRGBO(63, 63, 70, 1),
            ),
            child: Text(
              accountDetailsController.isWhiteListed.value
                  ? 'Whitelisted' : 'Not Whitelisted',
              style: TextStyle(
                color: accountDetailsController.isWhiteListed.value ?
                     const Color.fromRGBO(16, 185, 129, 1)
                : const Color.fromRGBO(161, 161, 170, 1),
                fontFamily: "Switzer",
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildKycStatusContainer(
      bool isDarkMode, AccountVerificationController accountDetailsController) {
    return Obx(
      ()=> Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isDarkMode
              ? ColorUtils.appbarBackgroundDark
              : ColorUtils.whiteColor,
          border: Border.all(
            color: isDarkMode
                ? ColorUtils.appbarHorizontalLineDark
                : ColorUtils.appbarHorizontalLineLight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  isDarkMode
                      ? ImageUtils.profileImg1
                      : ImageUtils.profileImageLight1,
                  height: 40,
                  width: 40,
                ),
                const SizedBox(width: 10),
                Text(
                  'Your KYC Status',
                  style: TextStyle(
                    color: isDarkMode
                        ? ColorUtils.indicaterGreyLight
                        : ColorUtils.appbarHorizontalLineDark,
                    fontSize: 14,
                    fontFamily: "Switzer",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                color: accountDetailsController.kycStatus.value == "Pending" ||
                        accountDetailsController.kycStatus.value == "PENDING" ||
                        accountDetailsController.kycStatus.value == "onHold" ||
                        (accountDetailsController.kycReviewAnswer.value ==
                                'RED' &&
                            accountDetailsController.kycRejectType.value ==
                                'RETRY')
                    ? const Color.fromRGBO(249, 86, 22, 0.16)
                    : accountDetailsController.kycReviewAnswer.value == 'GREEN'
                        ? const Color.fromRGBO(16, 185, 129, 0.45)
                        : (accountDetailsController.kycReviewAnswer.value ==
                                    'RED' &&
                                accountDetailsController.kycRejectType.value ==
                                    'FINAL')
                            ? const Color.fromRGBO(251, 55, 72, 0.16)
                            : const Color.fromRGBO(63, 63, 70, 1),
              ),
              child: Text(
                accountDetailsController.kycStatus.value == "Pending" ||
                        accountDetailsController.kycStatus.value == "PENDING" ||
                        accountDetailsController.kycStatus.value == "onHold"
                    ? "Pending"
                    : (accountDetailsController.kycReviewAnswer.value ==
                                'RED' &&
                            accountDetailsController.kycRejectType.value ==
                                'FINAL')
                        ? "Rejected"
                        : accountDetailsController.reviewStatus.value ==
                                "completed"
                            ? (accountDetailsController.kycReviewAnswer.value ==
                                        'RED' &&
                                    accountDetailsController
                                            .kycRejectType.value ==
                                        'RETRY')
                                ? 'Resubmit'
                                : "Verified"
                            : 'Not Verified',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Switzer",
                  color:
                      accountDetailsController.kycStatus.value == "Pending" ||
                              accountDetailsController.kycStatus.value ==
                                  "PENDING" ||
                              accountDetailsController.kycStatus.value ==
                                  "onHold" ||
                              (accountDetailsController.kycReviewAnswer.value ==
                                      'RED' &&
                                  accountDetailsController
                                          .kycRejectType.value ==
                                      'RETRY')
                          ? const Color.fromRGBO(255, 132, 71, 1)
                          : (accountDetailsController.kycReviewAnswer.value ==
                                      'RED' &&
                                  accountDetailsController
                                          .kycRejectType.value ==
                                      'FINAL')
                              ? const Color.fromRGBO(251, 55, 72, 1)
                              : accountDetailsController.kycStatus.value ==
                                          "completed" ||
                                      accountDetailsController
                                              .kycReviewAnswer.value ==
                                          'GREEN'
                                  ? const Color.fromRGBO(16, 185, 129, 1)
                                  : const Color.fromRGBO(161, 161, 170, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEnable2FA(bool isDarkMode) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isDarkMode
              ? ColorUtils.appbarBackgroundDark
              : ColorUtils.whiteColor,
          border: Border.all(
            color: isDarkMode
                ? ColorUtils.appbarHorizontalLineDark
                : ColorUtils.appbarHorizontalLineLight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  isDarkMode
                      ? ImageUtils.profileImg11
                      : ImageUtils.profileImageLight11,
                  height: 40,
                  width: 40,
                  fit: BoxFit.fill,
                ),
                const SizedBox(width: 10),
                Text(
                  'Enable 2FA Authentication',
                  style: TextStyle(
                    color: isDarkMode
                        ? ColorUtils.indicaterGreyLight
                        : ColorUtils.appbarHorizontalLineDark,
                    fontSize: 14,
                    fontFamily: "Switzer",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.navigate_next,
              color: isDarkMode
                  ? ColorUtils.indicaterGreyLight
                  : ColorUtils.appbarHorizontalLineDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildKycButton(
      AccountVerificationController accountDetailsController) {
    return accountDetailsController.kycStatus.value == "Pending" ||
            accountDetailsController.kycStatus.value == "PENDING" ||
            accountDetailsController.kycStatus.value == "onHold" ||
            accountDetailsController.reviewStatus.value == "completed" &&
                accountDetailsController.kycReviewAnswer.value == 'GREEN' ||
            (accountDetailsController.kycReviewAnswer.value == 'RED' &&
                accountDetailsController.kycRejectType.value == 'FINAL')
        ? const SizedBox.shrink()
        : (accountDetailsController.isVerifiedEmail.value &&
                    accountDetailsController.isPhoneNumberVerified.value) ||
                (accountDetailsController.kycReviewAnswer.value == 'RED' &&
                    accountDetailsController.kycRejectType.value == 'RETRY')
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: CustomWidgets.buildGetStartedButton(
                    text: (accountDetailsController.kycReviewAnswer.value ==
                                'RED' &&
                            accountDetailsController.kycRejectType.value ==
                                'RETRY')
                        ? "Re-submit Kyc Verification"
                        : "Start Kyc Verification",
                    onPressed: () {
                      Get.delete<AccountVerificationController>(force: true);
                      Get.put(AccountVerificationController());
                      Get.to(() => KycScreen(
                            emailAddress:
                                accountDetailsController.emailId.value,
                          ));
                    }),
              )
            : Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: CustomWidgets.buildGetStartedButton(
                    text: (accountDetailsController.kycReviewAnswer.value ==
                                'RED' &&
                            accountDetailsController.kycRejectType.value ==
                                'RETRY')
                        ? "Re-submit Kyc Verification"
                        : "Start Kyc Verification",
                    onPressed: null),
              );
  }

  AppBar buildAppBar(
      bool isDarkMode, AccountVerificationController accountController) {
    return AppBar(
      title: buildAppBarTitle(StringUtils.accountVerification, isDarkMode),
      centerTitle: true,
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
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: isDarkMode ? Colors.white : ColorUtils.appbarBackgroundDark,
          size: 15,
        ),
        onPressed: () =>
            Get.back(result: accountController.walletAddress.value),
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
        fontSize: 20,
      ),
    );
  }
}
