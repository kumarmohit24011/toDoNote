
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:developer' as developer;

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
    developer.log('Initializing NotificationService...', name: 'NotificationService');
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        developer.log('Notification was tapped. Payload: ${response.payload}', name: 'NotificationService');
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _requestPermissions();
    developer.log('NotificationService initialized.', name: 'NotificationService');
  }

  Future<void> _requestPermissions() async {
    developer.log('Requesting notification permissions...', name: 'NotificationService');
    var notificationStatus = await Permission.notification.request();
    var scheduleExactAlarmStatus = await Permission.scheduleExactAlarm.request();
    developer.log('Permission status: notification: $notificationStatus, scheduleExactAlarm: $scheduleExactAlarmStatus', name: 'NotificationService');
  }

  Future<void> scheduleNotification(int id, String title, DateTime scheduledTime) async {
    developer.log('Attempting to schedule notification for task: "$title" at $scheduledTime', name: 'NotificationService');

    if (scheduledTime.isBefore(DateTime.now())) {
      developer.log('Scheduled time ($scheduledTime) is in the past. Notification not scheduled.', name: 'NotificationService');
      return;
    }

    var notificationPermission = await Permission.notification.isGranted;
    var scheduleExactAlarmPermission = await Permission.scheduleExactAlarm.isGranted;

    if (!notificationPermission || !scheduleExactAlarmPermission) {
      developer.log('Cannot schedule notification due to missing permissions. Notification: $notificationPermission, Exact Alarm: $scheduleExactAlarmPermission', name: 'NotificationService');
      // Optionally, re-request permissions here if it makes sense in the app's flow
      // await _requestPermissions();
      return;
    }

    try {
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
            playSound: true,
            ticker: 'ticker',
            ),
        ),
        payload: 'TaskID|$id|$title',
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
        developer.log('Successfully scheduled notification for task: "$title" at $scheduledTime', name: 'NotificationService');
    } catch (e) {
        developer.log('Error scheduling notification: $e', name: 'NotificationService', error: e);
    }
  }

  Future<void> cancelNotification(int id) async {
    developer.log('Cancelling notification with id: $id', name: 'NotificationService');
    await flutterLocalNotificationsPlugin.cancel(id);
    developer.log('Notification with id: $id cancelled.', name: 'NotificationService');
  }
}
