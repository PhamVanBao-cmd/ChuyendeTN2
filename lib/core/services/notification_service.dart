import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tz;

import 'package:timezone/timezone.dart' as tz;

class NotificationService {

  static final FlutterLocalNotificationsPlugin
  notifications =
  FlutterLocalNotificationsPlugin();

  /// ================= INIT =================
  static Future<void> init() async {

    tz.initializeTimeZones();

    /// timezone VN
    tz.setLocalLocation(
      tz.getLocation(
        'Asia/Ho_Chi_Minh',
      ),
    );

    const AndroidInitializationSettings
    androidSettings =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings
    settings =
    InitializationSettings(
      android: androidSettings,
    );

    await notifications.initialize(
      settings,
    );

    /// Android 13+
    await notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    /// Android 12+
    await notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  /// ================= TEST =================
  static Future<void> testNotification() async {

    const AndroidNotificationDetails
    androidDetails =
    AndroidNotificationDetails(

      'test_channel',
      'Test Notification',

      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
    NotificationDetails(
      android: androidDetails,
    );

    await notifications.show(
      999,
      'TEST THÔNG BÁO',
      'Thông báo đang hoạt động 🎉',
      details,
    );
  }

  /// ================= SIMPLE =================
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {

    const AndroidNotificationDetails
    androidDetails =
    AndroidNotificationDetails(

      'health_channel',
      'Health Notifications',

      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
    NotificationDetails(
      android: androidDetails,
    );

    await notifications.show(
      0,
      title,
      body,
      details,
    );
  }

  /// ================= WATER =================
  static Future<void> scheduleWaterReminder(
      int minutes,
      ) async {

    final time =
    tz.TZDateTime.now(
      tz.local,
    ).add(
      Duration(
        minutes: minutes,
      ),
    );

    await notifications.zonedSchedule(

      1,

      'Nhắc uống nước 💧',

      'Đã đến lúc uống nước rồi nhé!',

      time,

      const NotificationDetails(

        android: AndroidNotificationDetails(

          'water_channel',
          'Water Reminder',

          importance: Importance.max,
          priority: Priority.high,
        ),
      ),

      androidScheduleMode:
      AndroidScheduleMode.exactAllowWhileIdle,

      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// ================= SLEEP =================
  static Future<void> scheduleSleepReminder(
      int hour,
      int minute,
      ) async {

    /// xóa lịch cũ
    await notifications.cancel(2);

    final now =
    tz.TZDateTime.now(
      tz.local,
    );

    tz.TZDateTime scheduledDate =
    tz.TZDateTime(

      tz.local,

      now.year,
      now.month,
      now.day,

      hour,
      minute,
    );

    /// nếu qua giờ hôm nay
    if (scheduledDate.isBefore(now)) {

      scheduledDate =
          scheduledDate.add(
            const Duration(days: 1),
          );
    }

    print(
      "Sleep reminder: $scheduledDate",
    );

    await notifications.zonedSchedule(

      2,

      'Đến giờ đi ngủ 🌙',

      'Bạn nên nghỉ ngơi để giữ sức khỏe',

      scheduledDate,

      const NotificationDetails(

        android: AndroidNotificationDetails(

          'sleep_channel',
          'Sleep Reminder',

          importance: Importance.max,

          priority: Priority.high,

          playSound: true,

          enableVibration: true,
        ),
      ),

      androidScheduleMode:
      AndroidScheduleMode.exactAllowWhileIdle,

      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,

      matchDateTimeComponents:
      DateTimeComponents.time,
    );
  }

  /// ================= CANCEL =================
  static Future<void>
  cancelSleepReminder() async {

    await notifications.cancel(2);
  }
}