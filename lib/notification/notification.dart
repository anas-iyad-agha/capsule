import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notifications {
  static FlutterLocalNotificationsPlugin notificationService =
      FlutterLocalNotificationsPlugin();

  static String locationTimeZone = 'Asia/Damascus';

  static Future<void> init() async {
    bool permission =
        await notificationService
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission() ??
        false;

    if (permission) {
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/launcher_icon',
      );

      const iosSettings = DarwinInitializationSettings();

      const initializationSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      tz.initializeTimeZones();
      var location = tz.getLocation(locationTimeZone);
      tz.setLocalLocation(location);
      await notificationService.initialize(initializationSettings);
    }
  }

  static Future singleNotification(
    int hashcode,
    String message,
    String subtext,
    tz.TZDateTime datetime,
    String? payload,
    bool ongoing,
  ) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      hashcode.toString(),
      'PillPal',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ongoing: ongoing,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var macOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
      macOS: macOSPlatformChannelSpecifics,
    );
    await notificationService.zonedSchedule(
      hashcode,
      message,
      subtext,
      datetime,
      platformChannelSpecifics,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future singleNotificationCallback(
    int notificationId,
    String title,
    String subtext,
    DateTime dateTime,
    String? payload, {
    bool ongoing = true,
  }) async {
    var tzDateTime = tz.TZDateTime.from(
      dateTime,
      tz.getLocation(locationTimeZone),
    ).add(const Duration(seconds: 1));
    await singleNotification(
      notificationId,
      title,
      subtext,
      tzDateTime,
      payload,
      ongoing,
    );
  }

  static Future repeatingNotification(
    int hashcode,
    String message,
    String subtext,
    tz.TZDateTime datetime,
    String? payload,
  ) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      hashcode.toString(),
      'PillPal',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ongoing: true,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var macOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
      macOS: macOSPlatformChannelSpecifics,
    );
    await notificationService.zonedSchedule(
      hashcode,
      message,
      subtext,
      datetime,
      platformChannelSpecifics,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  static Future<void> repeatingNotificationCallback(
    int notificationId,
    String title,
    String subtext,
    DateTime dateTime,
    String? payload,
  ) async {
    var tzDateTime = tz.TZDateTime.from(
      dateTime,
      tz.getLocation(locationTimeZone),
    ).add(const Duration(seconds: 1));
    await repeatingNotification(
      notificationId,
      title,
      subtext,
      tzDateTime,
      payload,
    );
  }

  static Future everydayNotification(
    int hashcode,
    String message,
    String subtext,
    tz.TZDateTime datetime,
    String? payload,
  ) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      hashcode.toString(),
      'PillPal',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ongoing: true,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var macOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
      macOS: macOSPlatformChannelSpecifics,
    );
    await notificationService.zonedSchedule(
      hashcode,
      message,
      subtext,
      datetime,
      platformChannelSpecifics,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> everydayNotificationCallback(
    int notificationId,
    String title,
    String subtext,
    DateTime dateTime,
    String? payload,
  ) async {
    var tzDateTime = tz.TZDateTime.from(
      dateTime,
      tz.getLocation(locationTimeZone),
    ).add(const Duration(seconds: 1));
    await repeatingNotification(
      notificationId,
      title,
      subtext,
      tzDateTime,
      payload,
    ).then((value) => null);
  }
}
