import 'package:get/get.dart';

class HelpSupportController extends GetxController {
  var expandedIndex = (-1).obs;

  final List<Map<String, String>> helpTopics = [
    {
      "title": "How do I update my account information?",
      "content":
      "To update your account information, navigate to the Account Settings section in the app and make the desired changes."
    },
    {
      "title": "What payment methods are accepted?",
      "content":
      "Major credit and debit cards like Visa, MasterCard, and American Express, as well as digital payment options like PayPal and Apple Pay."
    },
    {
      "title": "How do I reset my password?",
      "content":
      "To reset your password, click on 'Forgot Password' at the login screen and follow the instructions sent to your email."
    },
    {
      "title": "How do I contact customer support?",
      "content":
      "You can contact customer support via email at support@example.com or by using the chat feature in the app."
    },
  ].obs;

  final List<String> helpSupportImg =[
    "assets/images/help-support-img-1.png",
    "assets/images/help-support-img-2.png",
    "assets/images/help-support-img-3.png",
    "assets/images/help-support-img-4.png",
  ];

  void toggleExpansion(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1; // Collapse if the same panel is tapped
    } else {
      expandedIndex.value = index; // Expand the selected panel
    }
  }
}
