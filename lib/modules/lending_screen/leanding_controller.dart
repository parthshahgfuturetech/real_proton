import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class LeandingController extends GetxController {
  late VideoPlayerController videoPlayerController;
  RxBool isInitialized = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    videoPlayerController = VideoPlayerController.asset('assets/video/background-video.mp4')
      ..initialize().then((_) {
        videoPlayerController.setLooping(true);
        videoPlayerController.play();
        isInitialized.value = true;
      });
  }

  @override
  void onClose() {
    if (videoPlayerController.value.isInitialized) {
      try {
        videoPlayerController.dispose();
      } catch (e) {
        print("Error while disposing VideoPlayerController: $e");
      }
    }
    isInitialized.value = false;
    print("LeandingController Close");
    super.onClose();

  }

  @override
  void dispose() {
    isInitialized.value = false;
    print("LeandingController disposed");
    super.dispose();
  }

}