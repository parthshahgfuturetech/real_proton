import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/modules/botton_bar_options/bottom_bar/bottomBarController.dart';
import 'package:real_proton/modules/botton_bar_options/bottom_bar/bottom_bar.dart';
import 'package:real_proton/modules/botton_bar_options/profile/profile_controller.dart';
import 'package:real_proton/utils/apis.dart';
import 'package:real_proton/modules/api_services/api_services.dart';
import 'package:real_proton/utils/shared_preference.dart';
import 'package:real_proton/utils/widgets.dart';

import '../location_get/location_controller.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late ApiService apiServiceClass;
  RxBool isLoading = false.obs, isGoogleLogin = false.obs,isPasswordShow = false.obs;
  final Logger _logger = Logger();
  String firstName = '';
  String emailId = "";
  String phoneNumber = "";
  String countryCodeNumber = "";
  bool isVerifiedEmail = false;
  final LocationController locationController = Get.put(LocationController());

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    apiServiceClass = ApiService(isGoogleLogin: isGoogleLogin.value);
    emailController.clear();
    passwordController.clear();
  }

  void passwordShow(){
    isPasswordShow.value = !isPasswordShow.value;
  }



  Future<UserCredential?> logInWithGoogle(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      isLoading.value = true;

      await googleSignIn.signOut();
      await auth.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        _logger.i("Google sign-in was canceled by the user.");
        isLoading.value = false;
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.idToken == null || googleAuth.accessToken == null) {
        _logger.i("Failed to retrieve Google authentication details.");
        isLoading.value = false;
        return null;
      }

      final AuthCredential cred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      _logger.i("-=-=-=-=>Google IdToken ${googleAuth.idToken}");
      _logger.i("-=-=-=-=>Google AccessToken ${googleAuth.accessToken}");

      final UserCredential userCredential =
          await auth.signInWithCredential(cred);
      String googleAccessToken = googleAuth.accessToken ?? "";

      await SharedPreferencesUtil.setString(
          SharedPreferenceKey.googleToken, googleAccessToken);
      isGoogleLogin.value = true;
      CustomWidgets.showSuccess(
          context: Get.context!, message: "Login successful.");
      Get.offAll(()=>BottomBar());
      bottomBarController.currentIndex.value = 4;
      return userCredential;
    } catch (e) {
      _logger.i("Error during Google sign-in: $e");
      CustomWidgets.showError(context: Get.context!, message: "Network error");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty) {
      CustomWidgets.showInfo(context: Get.context!, message: "Email is required.");
      return;
    } else if (!GetUtils.isEmail(email)) {
      CustomWidgets.showError(
          context: Get.context!, message: "Please enter a valid email address.");
      return;
    }

    if (password.isEmpty) {
      CustomWidgets.showInfo(
          context: Get.context!, message: "Password is required.");
      return;
    } else if (password.length < 6) {
      CustomWidgets.showError(
          context: Get.context!,
          message: "Password must be at least 6 characters long.");
      return;
    }

    isLoading.value = true;
    isGoogleLogin.value = false;


    await locationController.getCurrentLocation();
    double lat = locationController.latitude.value;
    double lng = locationController.longitude.value;
    _logger.i("User Location => Lat: $lat, Lng: $lng");


    String ipAddress = await getPublicIpAddress();
    _logger.i("User IP: $ipAddress");


    FocusScope.of(context).unfocus();
    final loginData = {
      "email": email,
      "password": password,
      "ipAddress":'${ipAddress}',
      "lat":'$lat',
      "long":'$lng',
      "os":'${Platform.isAndroid ? 'android' : Platform.isIOS ? 'ios' : 'unknown'}',
    };
    _logger.i("Login Request Data: $loginData");

    try {
      final response = await apiServiceClass.post(context, ApiUtils.loginAPi,
          data: loginData);
      if (response.statusCode == 200) {
        final token = response.data['data']['accessToken'];
        if (token != null) {
          await SharedPreferencesUtil.setString(
              SharedPreferenceKey.loginToken, token);
          CustomWidgets.showSuccess(
              context: Get.context!, message: "Login successful.");

          Get.put(BottomBarController());
          Get.put(ProfileController());

          Get.offAll(()=>BottomBar());
          bottomBarController.currentIndex.value = 4;
          emailController.clear();
          passwordController.clear();
        } else {
          CustomWidgets.showError(
              context: Get.context!, message: "Invalid response from server.");
        }
      } else {
        CustomWidgets.showError(
            context: Get.context!, message: "Invalid email or password.");
      }
    } catch (e) {
      CustomWidgets.showError(
          context: Get.context!, message: "${e.toString()} Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> getPublicIpAddress() async {
    try {
      final response = await http.get(Uri.parse('https://api64.ipify.org?format=json'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['ip'];  // Returns public IP address
      }
    } catch (e) {
      print("Failed to get public IP: $e");
    }
    return "Unknown IP";
  }
}
