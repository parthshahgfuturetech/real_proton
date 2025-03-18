import 'package:get/get.dart';

class NotificationController extends GetxController {

  var isPushNotificationEnabled = true.obs;
  var isEmailNotificationEnabled = true.obs;
  var isSmsNotificationEnabled = false.obs;

  void togglePushNotification() {
    isPushNotificationEnabled.value = !isPushNotificationEnabled.value;
  }

  void toggleEmailNotification() {
    isEmailNotificationEnabled.value = !isEmailNotificationEnabled.value;
  }

  void toggleSmsNotification() {
    isSmsNotificationEnabled.value = !isSmsNotificationEnabled.value;
  }

  var notifications = [
    {
      'title': 'Your KYC Completed!',
      'message': 'Your KYC has been completed, you can now buy or sell tokens',
      'time': '57 Min ago',
      'isRead': false,
      'isToday': true,
    },
    {
      'title': 'Your KYC Completed!',
      'message': 'Your KYC has been completed, you can now buy or sell tokens',
      'time': '57 Min ago',
      'isRead': true,
      'isToday': false,
    },
    {
      'title': 'Your KYC Completed!',
      'message': 'Your KYC has been completed, you can now buy or sell tokens',
      'time': '57 Min ago',
      'isRead': true,
      'isToday': false,
    },
    {
      'title': 'Your KYC Completed!',
      'message': 'Your KYC has been completed, you can now buy or sell tokens',
      'time': '57 Min ago',
      'isRead': true,
      'isToday': false,
    },
  ].obs;

  // Mark all notifications as read
  void markAllAsRead() {
    for (var notification in notifications) {
      notification['isRead'] = true;
    }
    notifications.refresh(); // Refresh the list
  }
}
