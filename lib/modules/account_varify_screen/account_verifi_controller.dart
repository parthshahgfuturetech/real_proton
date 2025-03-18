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

class AccountVerificationController extends GetxController
    with WidgetsBindingObserver {
  RxString kycStatus = 'Not Verified'.obs,
      walletStatus = 'Whitelisted'.obs,
      walletAddress = ''.obs,
      varifationsId = ''.obs,
      userId = ''.obs,
      emailId = ''.obs,
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
  final emailController = TextEditingController();
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
    saveData();

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> onRefreshData() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 3), () {
      saveData();
    });
    isLoading.value = false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint("App Resumed - Restoring Data");
        if (isEmailVerified || kycController.isKycDone) {
          saveData();
          // kycController.isKycDone = false;
        }
        break;
      case AppLifecycleState.inactive:
        debugPrint("App inactive - Restoring Data");
        break;
      case AppLifecycleState.paused:
        debugPrint("App paused - Restoring Data");
        break;
      case AppLifecycleState.detached:
        debugPrint("App detached - Restoring Data");
        break;
      case AppLifecycleState.hidden:
        debugPrint("App hidden - Restoring Data");
        break;
    }
  }

  Future<void> kycUpdate() async {
    try {
      isLoading.value = true;
      final response = await apiServiceClass.get(Get.context!,
          "https://api.realproton.com/v1/sumsub/applicant-status/${kycApplicantId.value}");

      if (response.statusCode == 200) {
        final responseJson = response.data;
        String decryptedText =
            CustomWidgets.decryptOpenSSL(responseJson, StringUtils.secretKey);
        final Map<String, dynamic> decryptedData = jsonDecode(decryptedText);

        kycStatus.value = decryptedData['reviewStatus'];

        if (decryptedData['reviewResult']['reviewAnswer'] != null) {
          kycReviewAnswer.value = decryptedData['reviewResult']['reviewAnswer'];
        }
        if (decryptedData['reviewResult']['reviewRejectType'] != null) {
          kycRejectType.value =
              decryptedData['reviewResult']['reviewRejectType'];
        }
        if (kycReviewAnswer.value == 'GREEN') {
          bottomBarController.kycPending.value = false;
          saleController.isShowButton.value = true;
          walletController.isTransactionHistoryShow.value = true;
          createChainId();
          Future.delayed(Duration(seconds: 2), () async {
            return await createWalletApi();
          });
        } else {
          bottomBarController.kycPending.value = true;
          saleController.isShowButton.value = false;
          walletController.isTransactionHistoryShow.value = false;
        }
        _logger.i("sumsub status APi Done");
        kycUpdateData();
      } else {
        isLoading.value = false;
        _logger.i("sumsub status APi not Done");
        throw ApiException("Failed to fetch properties.");
      }
    } catch (e) {
      isLoading.value = false;
      _logger.i("Error :--${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createChainId() async {
    try{
      final response = await apiServiceClass.get(Get.context!, ApiUtils.chainId);

      if(response.statusCode == 200){
        final responseJson = response.data['data'];
        String decryptedText =
        CustomWidgets.decryptOpenSSL(responseJson, StringUtils.secretKey);

        final List<dynamic> decryptedData = jsonDecode(decryptedText);

        chainId = decryptedData[0]['_id'];
        assetsId = decryptedData[0]['chainId'];

        _logger.i("ChainId is Successfully");
      }else{
        _logger.i("ChainId is not Successfully");
      }
    }catch(e){
      _logger.i("ChainId is not Successfully $e");
    }
  }

  Future<void> createWalletApi() async {
    final data = {
      "assetId": assetsId,
      "chainId": chainId
    };
    try {
      final response = await apiServiceClass
          .post(Get.context!, ApiUtils.createWallet, data: data);
      if (response.statusCode == 200) {
        _logger.i("Successfully Create Wallet Address");
      } else {
        _logger.i("Error during Create Wallet Address");
      }
    } catch (e) {
      _logger.i("Error during Create Wallet Address");
    }
  }

  Future<void> kycUpdateData() async {
    final data = {
      "kycStatus": kycStatus.value,
      "kycMetadata": {
        "reviewResult": {
          "reviewAnswer": kycReviewAnswer.value,
          "reviewRejectType": kycRejectType.value,
        }
      }
    };
    FocusScope.of(Get.context!).unfocus();
    isLoading.value = true;
    try {
      final response = await apiServiceClass
          .put(Get.context!, ApiUtils.updateUser, data: data);

      if (response.statusCode == 200) {
        final responseJson = response.data['data'];
        String decryptedText =
        CustomWidgets.decryptOpenSSL(responseJson, StringUtils.secretKey);
        final Map<String, dynamic> decryptedData = jsonDecode(decryptedText);

        kycStatus.value = decryptedData['kycStatus'];
        kycReviewAnswer.value = decryptedData['kycMetadata']
            ['reviewResult']['reviewAnswer'];
        kycRejectType.value = decryptedData['kycMetadata']
            ['reviewResult']['reviewRejectType'];
        _logger.i("Kyc Data Update successful");
      } else {
        isLoading.value = false;
        _logger.i("Error during Kyc else");
      }
    } catch (e) {
      isLoading.value = false;
      _logger.i("Error during Kyc verification: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveData() async {
    try {
      isLoading.value = true;
      final response =
          await apiServiceClass.get(Get.context!, ApiUtils.userDetails);
      if (response.statusCode == 200) {
        final responseJson = response.data['user'];
        String decryptedText =
            CustomWidgets.decryptOpenSSL(responseJson, StringUtils.secretKey);
        final Map<String, dynamic> decryptedData = jsonDecode(decryptedText);

        isVerifiedEmail.value = decryptedData['isEmailVerified'];
        isPhoneNumberVerified.value = decryptedData['isPhoneVerified'];
        emailId.value = decryptedData['email'];
        phoneNumber.value = decryptedData['mobileNumber'];
        countryCodeNumber.value = decryptedData['countryCode'];
        emailController.text = emailId.value;
        phoneController.text =
            phoneNumber.value.replaceFirst(countryCodeNumber.value, "");
        countryCode = ValueNotifier(countryCodeNumber.value);
        kycApplicantId.value = decryptedData['kycApplicationId'];
        kycStatus.value = decryptedData['kycStatus'];
        kycReviewAnswer.value =
            decryptedData['kycMetadata']['reviewResult']['reviewAnswer'];
        kycRejectType.value =
            decryptedData['kycMetadata']['reviewResult']['reviewRejectType'];
        kycUpdate();
        if ((kycReviewAnswer.value == 'RED' &&
            kycRejectType.value == 'FINAL')) {
          CustomWidgets.showError(
              context: Get.context!, message: StringUtils.errorMessage);
        }
        userId.value = decryptedData['_id'];
        walletAddress.value = decryptedData['wallets'][0]['walletAddress'];
      } else {
        isLoading.value = false;
        throw ApiException("Failed to fetch properties.");
      }
    } catch (e) {
      isLoading.value = false;
      _logger.i("Error :--${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> emailVerification(BuildContext context) async {
    final data = {
      "email": emailController.text.trim(),
    };
    FocusScope.of(context).unfocus();
    isLoading.value = true;
    try {
      final response =
          await apiServiceClass.post(context, ApiUtils.resendEmail, data: data);

      if (response.statusCode == 200) {
        isEmailVerified = true;
        CustomWidgets.showSuccess(
            context: Get.context!, message: "Email Send successful");
      } else {
        CustomWidgets.showError(
            context: Get.context!,
            message: response.data['message'] ?? "Send failed");
      }
    } catch (e) {
      CustomWidgets.showError(
          context: Get.context!, message: "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> phoneVerificationAPi(BuildContext context, String number,
      String countyCode, bool isVerified) async {
    final data = {
      "mobileNumber": "$countyCode$number",
      "countryCode": countyCode,
      "isPhoneVerified": isVerified,
    };
    FocusScope.of(context).unfocus();
    isLoading.value = true;
    try {
      final response =
          await apiServiceClass.put(context, ApiUtils.updateUser, data: data);

      if (response.statusCode == 200) {
        final responseJson = response.data['data'];
        String decryptedText = CustomWidgets.decryptOpenSSL(responseJson, StringUtils.secretKey);
        final Map<String, dynamic> decryptedData = jsonDecode(decryptedText);

        isPhoneNumberVerified.value = decryptedData['isPhoneVerified'];
        phoneNumber.value = decryptedData['mobileNumber'];
        countryCodeNumber.value = decryptedData['countryCode'];

        phoneController.text =
            phoneNumber.value.replaceFirst(countryCodeNumber.value, "");
        countryCode = ValueNotifier(countryCodeNumber.value);

        _logger.i("Phone verification Done");
        return true;
      } else {
        isLoading.value = false;
        _logger.i("Error during phone else");
      }
    } catch (e) {
      isLoading.value = false;
      _logger.i("Error during phone verification: $e");
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  void phoneSendOtp(BuildContext context, bool isDarkMode,
      {required String mobileNumber}) {
    try {
      isLoading.value = true;
      FocusScope.of(context).unfocus();
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: mobileNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
        verificationFailed: (error) {
          isLoading.value = false;
          if (error.code == 'quota-exceeded') {
            _logger.i("Quota exceeded. Enable billing.");
          } else if (error.code == 'invalid-phone-number') {
            CustomWidgets.showError(
                context: context, message: "Invalid phone number format.");
          } else {
            CustomWidgets.showError(
                context: context, message: "Invalid phone number format.");
            _logger.i("Unexpected error: ${error.code}");
          }
        },
        codeSent: (verificationId, forceResendingToken) {
          isLoading.value = false;
          varifationsId.value = verificationId;
          buildOtpBottomSheet(context, isDarkMode);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      _logger.i("Error during phone verification: ${e.toString()}");
    }
  }

  Future<void> phoneOtpRecivie(String value) async {
    try {
      isLoading.value = true;
      final cred = PhoneAuthProvider.credential(
        verificationId: varifationsId.value,
        smsCode: value,
      );

      await FirebaseAuth.instance.signInWithCredential(cred).then((value) {
        isLoading.value = false;
        _logger.i("Successfull sign-in: ${value.user}");
        Get.back();
        phoneVerificationAPi(
            Get.context!, phoneController.text, countryCode.value, true);
        Get.snackbar(
          icon: const Icon(Icons.info, color: Colors.white),
          "SuccessFul",
          "Verification Done",
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          borderRadius: 1,
          snackPosition: SnackPosition.BOTTOM, // Ensures visibility
        );
      });
    } catch (e) {
      isLoading.value = false;
      _logger.i("Error during sign-in: ${e.toString()}");
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-verification-code') {
          Get.snackbar(
            icon: const Icon(Icons.info, color: Colors.white),
            "Error",
            "Invalid Verification Code",
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            borderRadius: 1,
            snackPosition: SnackPosition.BOTTOM, // Ensures visibility
          );
        }
      }
    }
  }

  buildOtpBottomSheet(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: isDarkMode
          ? ColorUtils.appbarBackgroundDark
          : ColorUtils.bottomBarLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      builder: (builderContext) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: BoxDecoration(
            color: isDarkMode
                ? ColorUtils.appbarBackgroundDark
                : ColorUtils.bottomBarLight,
            border: const Border(
                top: BorderSide(
              color: ColorUtils.appbarHorizontalLineDark,
            )),
            borderRadius: BorderRadius.circular(15),
          ),
          child: buildOtpFields(context, isDarkMode),
        );
      },
    );
  }

  buildOtpFields(BuildContext context, bool isDarkMode) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Enter OTP",
                style: TextStyle(
                  color: isDarkMode
                      ? ColorUtils.whiteColor
                      : ColorUtils.blackColor,
                  fontSize: 22,
                  fontFamily: "Switzer",
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "We’ve sent a code to ${countryCode.value}${phoneController.text}",
                style: TextStyle(
                  color: isDarkMode
                      ? ColorUtils.darkModeGrey2
                      : ColorUtils.blackColor,
                  fontSize: 14,
                  fontFamily: "Switzer",
                  fontWeight: FontWeight.w400,
                ),
              ),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CustomWidgets.buildGetStartedButton(
                  onPressed: () {
                    if (textPhoneNumber.value.length < 6) {
                      Get.snackbar(
                        icon: const Icon(Icons.info, color: Colors.white),
                        "Error",
                        "Please enter all 6 digits",
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                        borderRadius: 1,
                        snackPosition:
                            SnackPosition.BOTTOM, // Ensures visibility
                      );
                    } else {
                      phoneOtpRecivie(textPhoneNumber.value);
                    }
                  },
                  text: "Submit",
                ),
              )
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
