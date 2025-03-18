import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyDetailsController extends GetxController {
  var isActive = false.obs;
  var selectedTab = 0.obs;

  final PageController pageController = PageController();
}