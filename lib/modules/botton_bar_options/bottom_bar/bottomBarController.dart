import 'package:get/get.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/utils/images.dart';

class BottomBarController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxBool kycPending = true.obs;

  @override
  void onInit() {
    super.onInit();
    profileController.apiSaveData();
  }

  final List<String> titles = ["Home", "Explore", " ", "Wallet", "Profile"];
  final List<String> noneSelectedIcons = [
    ImageUtils.homeNonSelected,
    ImageUtils.buildingNonSelected,
    ImageUtils.saleNonSelected,
    ImageUtils.walletNonSelected,
    ImageUtils.userNonSelected,
  ];

  final List<String> selectedIcons = [
    ImageUtils.homeSelected,
    ImageUtils.buildingSelected,
    ImageUtils.saleSelected,
    ImageUtils.walletSelected,
    ImageUtils.userSelected,
  ];

  void changeIndex(int index) {
    currentIndex.value = index;
  }

}
