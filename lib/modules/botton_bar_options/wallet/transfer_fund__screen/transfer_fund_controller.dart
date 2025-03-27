import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransferFundsController extends GetxController {
  var selectedAsset = ''.obs;
  var walletAddress = ''.obs;
  var transferAmount = 0.0.obs;
  var remarks = ''.obs;
  var maxBalance = 125.00.obs;
  var isSuccessAndFail = false.obs;
  final TextEditingController textController = TextEditingController();

  // Example assets
  List<Map<String, String>> assets = [
    {'name': 'Ethereum', 'icon': 'assets/images/stroke-rounded-1.png'},
    {'name': 'BSC', 'icon': 'assets/images/stroke-rounded-2.png'},
    {'name': 'Polygon', 'icon': 'assets/images/stroke-rounded-3.png'},
    {'name': 'Arbitrum', 'icon': 'assets/images/stroke-rounded-4.png'},
    {'name': 'Celo', 'icon': 'assets/images/stroke-rounded-5.png'},
    {'name': 'Avalanche', 'icon': 'assets/images/stroke-rounded-6.png'},
  ];
}