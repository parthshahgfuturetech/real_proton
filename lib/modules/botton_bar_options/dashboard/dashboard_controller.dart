import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/modules/api_services/api_services.dart';
import 'package:real_proton/utils/apis.dart';

class DashboardController extends GetxController {
  var totalBalance = 1253.00.obs;
  var totalUSDValue = 12323.00.obs;
  var currentPrice = 12.00.obs;
  var kycPending = true.obs;
  var isLoading = false.obs;
  var propertyList = [].obs;
  final _logger = Logger();
  final ApiService apiService = ApiService();
  final PageController pageController = PageController(viewportFraction: 0.85);

  @override
  void onInit() {
    super.onInit();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    isLoading.value = true;
    try {
      final response = await apiService.get(Get.context!, ApiUtils.propertyList);
      if (response.statusCode == 200) {
        propertyList.value = response.data['data'];
      } else {
        throw ApiException("Failed to fetch properties.");
      }
    } catch (e) {
      _logger.i("Error :--${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
