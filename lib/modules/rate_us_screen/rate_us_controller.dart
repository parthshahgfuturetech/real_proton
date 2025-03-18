import 'package:get/get.dart';

class RateUsController extends GetxController {
  // Reactive variables for rating and feedback
  var rating = 0.obs; // Initial rating value
  var feedback = ''.obs; // Feedback text

  void updateRating(int newRating) {
    rating.value = newRating;
  }

  void updateFeedback(String newFeedback) {
    feedback.value = newFeedback;
  }

  void submitFeedback() {
    if (rating.value == 0) {
      Get.snackbar('Error', 'Please select a rating');
    } else if (feedback.value.isEmpty) {
      Get.snackbar('Error', 'Please provide your feedback');
    } else {
      Get.snackbar('Success', 'Thank you for your feedback!');
      // Submit feedback logic here
    }
  }
}
