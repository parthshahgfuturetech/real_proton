import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_idensic_mobile_sdk_plugin/flutter_idensic_mobile_sdk_plugin.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/modules/account_varify_screen/account_verifi_controller.dart';
import 'package:real_proton/modules/api_services/api_services.dart';
import 'package:real_proton/utils/apis.dart';
import 'package:real_proton/utils/strings.dart';
import 'package:real_proton/utils/widgets.dart';

class KycController extends GetxController {
  RxBool isLoading = false.obs;
  RxString selectedNetwork = ''.obs,kycStatus = ''.obs,
      levelName = ''.obs,
      country = ''.obs,
      status = ''.obs,
      kycApplicantId = ''.obs;
  SNSMobileSDK? snsMobileSDK;
  bool isKycDone = false;
  final ApiService apiServiceClass = ApiService();
  final Logger _logger = Logger();

  Future<void> startKyc(String? emailAddress) async {
    isLoading.value = true;
    if (snsMobileSDK != null) {
      snsMobileSDK!.dismiss();
      snsMobileSDK = null;
    }

    final data = {
      "userId": emailAddress,
      "levelName": selectedNetwork.value,
      "ttlInSecs": 600,
    };
    isLoading.value = true;
    try {
      final response = await apiServiceClass.post(Get.context!, ApiUtils.sumsubToken, data: data);

      final responseJson = response.data;
      String decryptedText =
      CustomWidgets.decryptOpenSSL(responseJson, StringUtils.secretKey);
      final Map<String, dynamic> decryptedData = jsonDecode(decryptedText);

      String newKycToken = decryptedData['token'];
      _logger.i("New KYC Token: $newKycToken");

      Future<String> onTokenExpiration() async {
        return Future<String>.delayed(Duration(seconds: 2), () => newKycToken);
      }

      final builder = SNSMobileSDK.init(newKycToken, onTokenExpiration)
         .withHandlers(
        onEvent: (SNSMobileSDKEvent event) {
          _logger.i("event Payload: ${event.payload.values}");
          _logger.i("event ApplicatId: ${event.payload['applicantId']}");
          _logger.i("Restarted Sdk Status: ${SNSMobileSDKStatus.values}");
          _logger.i("Restarted Sdk Answer: ${SNSMobileSDKAnswerType.values}");
          kycApplicantId.value = event.payload['applicantId'];
          levelName.value =  event.payload['eventPayload']['levelName'];
          country.value = event.payload['CountryCode'];
          kycVerificationApi(applicantId: kycApplicantId.value,
           levelName: levelName.value,);
        },
        onStatusChanged: (newStatus, oldStatus) {
          _logger.i("Restarted SDK with oldStatus result: ${oldStatus.name}");
          _logger.i("Restarted SDK with newStatus result: ${newStatus.name}");
          kycStatus.value = newStatus.name;
          kycVerificationApi(applicantId: kycApplicantId.value,
            levelName: levelName.value,reviewStatus: kycStatus.value);
        },
        onActionResult: (SNSMobileSDKActionResult result) {
          _logger.i("Restarted SDK with action result: ${result.answer}");
          return Future.value(SNSActionResultHandlerReaction.Continue);
        },
      )
          .withAutoCloseOnApprove(3)
          .withLocale(Locale("en"))
          .withDebug(true);
      snsMobileSDK = builder.build();
      final result = await snsMobileSDK!.launch().then((value){
        print("hello open sumsub");
      Get.put(AccountVerificationController());
        isKycDone = true;
      });
      Get.back();
    } catch (e) {
      isLoading.value = false;
      _logger.e("Error restarting KYC: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> kycVerificationApi({String applicantId = "",
    String levelName = '',String reviewStatus = '',
    String reviewRejectType = '',}) async {

    final data = {
      "kycStatus": reviewStatus.toUpperCase(),
      "kycApplicationId": applicantId,
      "levelName": levelName,
      "reviewStatus": reviewStatus,
      "kycMetadata": {
        "reviewResult": {
          "reviewAnswer": "",
          "reviewRejectType": reviewRejectType,
        },
        "timestamp": DateTime.now().toUtc().toIso8601String(),
      }
    };
    FocusScope.of(Get.context!).unfocus();
    isLoading.value = true;
    try{
      final response =
      await apiServiceClass.put(Get.context!, ApiUtils.updateUser, data: data);

      if(response.statusCode == 200){
        final responseJson = response.data['data'];
        String decryptedText =
        CustomWidgets.decryptOpenSSL(responseJson, StringUtils.secretKey);
        final Map<String, dynamic> decryptedData = jsonDecode(decryptedText);
        print("-=->dec${decryptedData}");
        kycApplicantId.value = decryptedData['kycApplicationId'];
        kycStatus.value = decryptedData['kycStatus'];
        _logger.i("Phone verification Done");
      }else{
        isLoading.value = false;
        _logger.i("Error during phone verification");
      }
    }catch(e){
      isLoading.value = false;
      _logger.i("Error during phone verification: ${e}");
    }finally{
      isLoading.value = false;
    }
  }

  final List<Map<String, String>> networks = [
    {
      'name': 'NON-US Investors',
    },
    {
      'name': 'Accredited',
    },
    {
      'name': 'Institutional',
    },
  ];
}
