
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:developer' as developer;

// Define the notification channel
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important task reminders.', // description
  importance: Importance.max,
);

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    tz.initializeTimeZones();

    // Initialize with the callback
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        developer.log('Notification was tapped. Payload: ${response.payload}', name: 'NotificationService');
        // Here you could add navigation logic based on the payload
      },
    );

    // Create the notification channel on Android
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    PermissionStatus notificationStatus = await Permission.notification.request();
    if (notificationStatus.isDenied) {
      developer.log('Notification permission was denied.', name: 'NotificationService');
    }

    if (await Permission.scheduleExactAlarm.isDenied) {
       PermissionStatus exactAlarmStatus = await Permission.scheduleExactAlarm.request();
       if(exactAlarmStatus.isDenied) {
         developer.log('Schedule exact alarm permission was denied.', name: 'NotificationService');
       }
    }
  }

  Future<void> scheduleNotification(int id, String title, DateTime scheduledTime) async {
    if (!(await Permission.notification.isGranted) || !(await Permission.scheduleExactAlarm.isGranted)) {
      developer.log('Cannot schedule notification due to missing permissions.', name: 'NotificationService');
      return;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Task Due: $title',
      'Your task "$title" is due now.',
      tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true, // Explicitly enable sound
          ticker: 'ticker', // Add ticker text
        ),
      ),
      payload: 'TaskID|$id|$title', // Add a payload
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
     developer.log('Scheduled notification for task: $title at $scheduledTime', name: 'NotificationService');
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
