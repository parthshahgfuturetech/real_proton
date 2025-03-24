import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/lending_screen/leanding_controller.dart';
import 'package:real_proton/modules/login_screen/login_screen.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/widgets.dart';
import 'package:video_player/video_player.dart';

class LeandingScreen extends StatelessWidget {
  LeandingScreen({super.key});

  final LeandingController videoController = Get.put(LeandingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          top: false,
          child: Stack(
            children: [
              Obx(() {
                if (videoController.isInitialized.value) {
                  return SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: videoController
                            .videoPlayerController.value.size.width,
                        height: videoController
                            .videoPlayerController.value.size.height,
                        child:
                            VideoPlayer(videoController.videoPlayerController),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator(),);
                }
              }),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(39, 61, 107, 0.7),
                      Color.fromRGBO(39, 61, 107, 0.7),
                      Color(0xFF18181B),
                      Color(0xFF18181B),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  const Spacer(),
                  buildLogoAndText(),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        CustomWidgets.buildGetStartedButton(
                            onPressed: () {
                              Get.off(() => LoginScreen());
                              Get.delete<LeandingController>();
                            },
                        text: "Let’s get Started",),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
      ),
    );
  }

  Widget buildLogoAndText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/images/lendingPage_logo.png",
            alignment: Alignment.topLeft,
            fit: BoxFit.fitHeight,
            height: 40,
            width: 120,
          ),
          const SizedBox(height: 8),
          const Text(
            'Redefining\nGlobal Real Estate Investments',
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontFamily: "Switzer",
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
