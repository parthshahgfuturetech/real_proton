import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/modules/account_varify_screen/account_verifi_controller.dart';
import 'package:real_proton/modules/api_services/api_services.dart';
import 'package:real_proton/modules/botton_bar_options/bottom_bar/bottomBarController.dart';
import 'package:real_proton/modules/login_screen/login_controller.dart';
import 'package:real_proton/modules/login_screen/login_screen.dart';
import 'package:real_proton/utils/apis.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/shared_preference.dart';
import 'package:real_proton/utils/strings.dart';
import 'package:real_proton/utils/widgets.dart';

class ProfileController extends GetxController {
  RxInt progress = 60.obs;
  RxString kycStatus = 'Pending'.obs,
      firstName = "".obs,
      lastName = "".obs,
      userImage = ''.obs,
      emailId = ''.obs,
      walletAddress = ''.obs,
      phoneNumber = ''.obs;
  String kycReviewAnswer = '';
  List walletList = [];
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final _logger = Logger();
  RxBool isLoading = false.obs;
  final ApiService apiServiceClass = ApiService();
  final ImagePicker _picker = ImagePicker();
  bool permissionGranted = false;

  @override
  void onInit() {
    super.onInit();
    apiSaveData();
  }

  final List<String> profileDarkImageDark = [
    ImageUtils.profileImg2,
    ImageUtils.profileImg3,
    ImageUtils.profileImg4,
    ImageUtils.profileImg5,
  ];

  final List<String> profileLightImageLight = [
    ImageUtils.profileImageLight2,
    ImageUtils.profileImageLight3,
    ImageUtils.profileImageLight4,
    ImageUtils.profileImageLight5,
  ];

  final List<String> profileAppSettingsDarkImageDark = [
    ImageUtils.profileImg6,
    ImageUtils.profileImg7,
    ImageUtils.profileImg8,
    ImageUtils.profileImg9,
  ];

  final List<String> profileAppSettingsLightImageLight = [
    ImageUtils.profileImageLight6,
    ImageUtils.profileImageLight7,
    ImageUtils.profileImageLight8,
    ImageUtils.profileImageLight9,
  ];

  final List<Map<String, dynamic>> profileItems = [
    {
      'title': 'Account Verification',
      'subtitle': 'Manage Your Account Verification Process',
    },
    {
      'title': 'Change Password',
      'subtitle': 'Change Your Current Password',
    },
    {
      'title': 'Transaction History',
      'subtitle': 'See Your All Transactions',
    },
    {
      'title': 'Reports',
      'subtitle': 'Download your Transactions',
    },
  ];

  final List<Map<String, dynamic>> profileAppSettingItems = [
    {
      'title': 'Notification Setting',
      'subtitle': 'Manage Your Notifications',
    },
    {
      'title': 'Appearance',
      'subtitle': 'Change Theme to Dark or Light',
    },
    {
      'title': 'Rate Us',
      'subtitle': 'Rate Our Services',
    },
    {
      'title': 'Help & Support',
      'subtitle': 'Contact Us For Any Support',
    },
  ];

  void clearUserData() {
    firstName.value = "";
    lastName.value = "";
    emailId.value = "";
    phoneNumber.value = "";
    userImage.value = "";
    firstNameController.clear();
    lastNameController.clear();
  }

  Future<void> apiSaveData() async {
    try {
      isLoading.value = true;

      apiServiceClass.updateAuthorizationToken(
          SharedPreferencesUtil.getString(SharedPreferenceKey.loginToken) ??
              "");

      final response =
          await apiServiceClass.get(Get.context!, ApiUtils.userDetails);
      if (response.statusCode == 200) {
        final responseJson = response.data['user'];
        String decryptedText =
            CustomWidgets.decryptOpenSSL(responseJson, StringUtils.secretKey);
        final Map<String, dynamic> decryptedData = jsonDecode(decryptedText);

        firstName.value = decryptedData['firstName'] ?? '';
        lastName.value = decryptedData['lastName'] ?? '';
        emailId.value = decryptedData['email'] ?? '';
        phoneNumber.value = decryptedData['mobileNumber'] ?? '';
        userImage.value = decryptedData['profile'] ?? '';

        firstNameController.text = firstName.value;
        lastNameController.text = lastName.value;
        walletList = decryptedData['wallets'] ?? [];
        if (walletList.isNotEmpty) {
          walletAddress.value =
              decryptedData['wallets'][0]['walletAddress'] ?? '';
        }
        if (decryptedData['kycMetadata']['reviewResult']['reviewAnswer'] ==
            'GREEN') {
          bottomBarController.kycPending.value = false;
          saleController.isShowButton.value = true;
          walletController.isTransactionHistoryShow.value = true;
          kycReviewAnswer = response.data['kycMetadata']['reviewResult']
                  ['reviewAnswer'] ??
              '';
        } else {
          bottomBarController.kycPending.value = true;
          saleController.isShowButton.value = false;
          walletController.isTransactionHistoryShow.value = false;
        }
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

  Future<void> pickImage(BuildContext context) async {
    isLoading.value = true;

    if (await requestPermission(Get.context!, Permission.storage)) {
      final XFile? imageFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        try {
          final response = await apiServiceClass.uploadImage(
              Get.context!, ApiUtils.updateUser, imageFile);
          if (response.statusCode == 200) {
            _logger.i("API Successful");
            userImage.value = response.data['data']['profile'];
            Get.back();
          } else {
            _logger.i("API Failed");
          }
        } catch (e) {
          _logger.i('Error uploading image: $e');
        }
      }
    } else {
      _logger.i("Gallery permission denied.");
    }
    isLoading.value = false;
  }

  Future<bool> requestPermission(
      BuildContext context, Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final newStatus = await permission.request();
      if (newStatus.isGranted) {
        return true;
      } else {
        CustomWidgets.showError(
            context: Get.context!,
            message: "Permission denied. Please grant permission.");
        return false;
      }
    }

    if (status.isPermanentlyDenied) {
      CustomWidgets.showError(
          context: Get.context!,
          message: "Permission permanently denied. Open settings to enable.");
      openAppSettings();
      return false;
    }
    return false;
  }

  Future<void> apiUserUpdate(BuildContext context) async {
    final data = {
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
    };
    FocusScope.of(Get.context!).unfocus();
    isLoading.value = true;
    try {
      final response = await apiServiceClass
          .put(Get.context!, ApiUtils.updateUser, data: data);

      if (response.statusCode == 200) {
        firstNameController.text = response.data['data']['firstName'];
        lastNameController.text = response.data['data']['lastName'];

        firstName.value = firstNameController.text;
        lastName.value = lastNameController.text;
      } else {
        isLoading.value = false;
        _logger.i("Error during phone verification");
      }
    } catch (e) {
      isLoading.value = false;
      _logger.i("Error during phone verification: ${e}");
    } finally {
      isLoading.value = false;
      _logger.i("Error during Updatename ");
    }
  }

  Future<void> logOutMethod(
      BuildContext context, LoginController loginController) async {
    isLoading.value = true;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      _logger.i("User signed out from Firebase");

      apiServiceClass.updateAuthorizationToken(
          SharedPreferencesUtil.getString(SharedPreferenceKey.loginToken) ??
              "");

      final response = await apiServiceClass.get(Get.context!, ApiUtils.logout);

      if (response.statusCode == 200) {
        await FirebaseAuth.instance.signOut();
        // if (loginController.isGoogleLogin.value) {
        //   await googleSignIn.signOut();
        //   _logger.i("User signed out from Google");
        //   await SharedPreferencesUtil.remove(SharedPreferenceKey.googleToken);
        // } else {
        await SharedPreferencesUtil.remove(SharedPreferenceKey.loginToken);
        await SharedPreferencesUtil.clear();
        // }
        await Future.delayed(Duration(seconds: 3));
        Get.delete<BottomBarController>();
        Get.delete<ProfileController>(force: true);
        Get.delete<AccountVerificationController>();
        clearUserData();
        Get.offAll(() => LoginScreen());
      } else {
        _logger.i("Error during logout");
      }
    } catch (e) {
      _logger.i("Error during logout: ${e.toString()}");
      CustomWidgets.showError(context: Get.context!, message: "Logout failed");
    } finally {
      isLoading.value = false;
    }
  }
}
