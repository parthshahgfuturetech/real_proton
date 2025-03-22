import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';

class PropertyDetailsController extends GetxController {
  var isActive = false.obs;
  var selectedTab = 0.obs;
  var currentPage = 0.obs; // Observable variable to track the image index

  final PageController pageController = PageController();
  final PageController pageControllerSecond = PageController();


  void openImagePopup(BuildContext context, int initialIndex, List<String> imageName) {
    currentPage.value = initialIndex; // Set the initial index before opening popup

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (context, setState) {
              PageController pageController = PageController(initialPage: initialIndex);

              return Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image Viewer
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9, // Set width for dialog
                        height: MediaQuery.of(context).size.height * 0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black.withOpacity(0.2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: PageView.builder(
                            controller: pageController,
                            itemCount: imageName.length,
                            onPageChanged: (index) {
                              currentPage.value = index; // Update index in controller
                            },
                            itemBuilder: (context, index) {
                              return Center(
                                child: Image.asset(
                                  imageName[index],
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  height: MediaQuery.of(context).size.height * 0.6,
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Navigation Buttons
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left Button
                            Obx(() => GestureDetector(
                              onTap: currentPage.value > 0
                                  ? () {
                                pageController.previousPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                                currentPage.value--;
                              }
                                  : null,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: currentPage.value > 0
                                      ? ColorUtils.appbarHorizontalLineDark
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(12),
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  color: currentPage.value > 0
                                      ? Colors.white
                                      : ColorUtils.appbarHorizontalLineDark,
                                  size: 25,
                                ),
                              ),
                            )),

                            SizedBox(width: 20),

                            // Image Count
                            Obx(() => Container(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${currentPage.value + 1} / ${imageName.length}",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            )),

                            SizedBox(width: 20),

                            // Right Button
                            Obx(() => GestureDetector(
                              onTap: currentPage.value < imageName.length - 1
                                  ? () {
                                pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                                currentPage.value++;
                              }
                                  : null,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: currentPage.value < imageName.length - 1
                                      ? ColorUtils.appbarHorizontalLineDark
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(12),
                                child: Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: currentPage.value < imageName.length - 1
                                      ? Colors.white
                                      : ColorUtils.appbarHorizontalLineDark,
                                  size: 25,
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Close Button (Top Right)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

}