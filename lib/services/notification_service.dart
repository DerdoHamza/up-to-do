import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static AwesomeNotifications awesomeNotification = AwesomeNotifications();
  static Future init() async {
    var status =
        await awesomeNotification.requestPermissionToSendNotifications();

    if (status) {
      await awesomeNotification.initialize(
        null,
        [
          NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
          ),
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'basic_channel_group',
              channelGroupName: 'Basic group')
        ],
      );
    }
  }

  static Future showNotification({
    required DateTime date,
    required String title,
    required String body,
    required int id,
  }) async {
    await awesomeNotification.createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'basic_channel',
          title: title,
          body: body,
          wakeUpScreen: true,
          category: NotificationCategory.Reminder,
          notificationLayout: NotificationLayout.BigText,
          autoDismissible: false,
        ),
        schedule: NotificationCalendar.fromDate(
          date: date,
          allowWhileIdle: true,
          preciseAlarm: true,
        ));
  }
}
