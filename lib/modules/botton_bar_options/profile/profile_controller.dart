import 'dart:convert';
import 'dart:io';

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
import 'package:real_proton/modules/botton_bar_options/wallet/wallet_controller.dart';
import 'package:real_proton/modules/login_screen/login_controller.dart';
import 'package:real_proton/modules/login_screen/login_screen.dart';
import 'package:real_proton/utils/apis.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/shared_preference.dart';
import 'package:real_proton/utils/strings.dart';
import 'package:real_proton/utils/widgets.dart';

class ProfileController extends GetxController {
  RxInt progress = 0.obs;
  RxString kycStatus = 'Pending'.obs,
      firstName = "".obs,
      lastName = "".obs,
      userImage = ''.obs,
      emailId = ''.obs,
      walletAddress = ''.obs,
      phoneNumber = ''.obs;
  String kycReviewAnswer = '';
  int vaultId = 0;
  List walletList = [];
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final _logger = Logger();
  RxBool isLoading = false.obs;
  final ApiService apiServiceClass = ApiService();
  final ImagePicker _picker = ImagePicker();
  bool permissionGranted = false,
      isEmailVerified = false,
      isPhoneVerified = false;
  bool updateDetailsBtn = false;
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
    ImageUtils.profileImg12,
    ImageUtils.profileImg7,
    ImageUtils.profileImg8,
    ImageUtils.profileImg9,
  ];

  final List<String> profileAppSettingsLightImageLight = [
    ImageUtils.profileImageLight6,
    ImageUtils.profileImageLight12,
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
      'title': 'Security Settings',
      'subtitle': 'Manage Your Security PIN',
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
      print("profileController-apiSaveData:============");
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
        isEmailVerified = decryptedData['isEmailVerified'] ?? '';
        isPhoneVerified = decryptedData['isPhoneVerified'] ?? '';
        vaultId = decryptedData['wallets'][0]['vaultID'] ?? 0;
        if (isEmailVerified && progress.value < 100) {
          progress.value += 25;
        }
        if (isPhoneVerified && progress.value < 100) {
          progress.value += 25;
        }
        firstNameController.text = firstName.value;
        lastNameController.text = lastName.value;
        walletList = decryptedData['wallets'] ?? [];
        if (walletList.isNotEmpty) {
          walletAddress.value =
              decryptedData['wallets'][0]['walletAddress'] ?? '';
          await SharedPreferencesUtil.setString('walletAddress',  walletAddress.value);
          _logger.i("walletAddress===>${walletAddress}");
        }

        if (decryptedData['kycMetadata']['reviewResult']['reviewAnswer'] ==
            'GREEN') {
          updateDetailsBtn = true;
          progress.value += 25;

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

        if (decryptedData['wallets'][0]['chains'][0]['isWhitelisted'] ==
            false) {
          bottomBarController.kycPending.value = true;
        } else {
          bottomBarController.kycPending.value = false;
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

    bool hasPermission = await checkAndRequestPermissions(context);
    print("Storage permission granted: $hasPermission");

    if (hasPermission) {
      final XFile? imageFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (imageFile != null) {
        try {
          final response = await apiServiceClass.uploadImage(
              Get.context!, ApiUtils.updateUser, imageFile);

          if (response.statusCode == 200) {
            final responseJson = response.data['data'];
            String decryptedText = CustomWidgets.decryptOpenSSL(
                responseJson, StringUtils.secretKey);
            final Map<String, dynamic> decryptedData =
                jsonDecode(decryptedText);
            print("pickImage===>$decryptedData");
            _logger.i("API Successful");
            userImage.value = decryptedData['profile'];
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
      CustomWidgets.showError(
          context: Get.context!,
          message: "Gallery permission denied. Please enable it in settings.");
      openAppSettings(); // Open settings if permanently denied
    }

    isLoading.value = false;
  }

  Future<bool> checkAndRequestPermissions(BuildContext context) async {
    if (Platform.isAndroid) {
      bool hasStoragePermission =
          await requestPermission(context, Permission.storage);
      bool hasMediaPermission =
          await requestPermission(context, Permission.photos);
      return hasStoragePermission || hasMediaPermission;
    } else if (Platform.isIOS) {
      return await requestPermission(context, Permission.photos);
    }
    return false;
  }

  Future<bool> requestPermission(
      BuildContext context, Permission permission) async {
    final status = await permission.status;
    print("Current permission status: $status");

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final newStatus = await permission.request();
      print("New permission status after request: $newStatus");
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

        await SharedPreferencesUtil.remove(SharedPreferenceKey.loginToken);
        await SharedPreferencesUtil.clear();

        await Future.delayed(Duration(seconds: 3));
        Get.delete<WalletController>();
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
