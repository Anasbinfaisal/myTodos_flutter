import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:to_doey/models/task.dart';
import 'package:timezone/data/latest.dart ' as timeZone;
import 'package:timezone/timezone.dart' as timeZone;

import '../main.dart';
import '../screens/tasks_screen.dart';

class NotificationHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initNotification() async {
    _configLocalTimeZone();

    final IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            defaultPresentSound: false,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: iosInitializationSettings,
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('$payload');
    } else {
      print('done');
    }

    navKey.currentState
        ?.push(MaterialPageRoute(builder: (context) => TasksScreen()));
  }

  Future onDidReceiveLocalNotification(
      int? id, String? title, String? content, String? payload) async {
    Get.dialog(Text('Welcome'));
  }

  displayNotification({required String title, required String content}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channelId', 'channelName',
        channelDescription: 'channelDescription',
        importance: Importance.max,
        priority: Priority.high,
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        styleInformation:
            BigTextStyleInformation(content, contentTitle: title));

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    flutterLocalNotificationsPlugin.show(
        0, title, content, platformChannelSpecifics,
        payload: 'Default_Sound');
  }

  scheduledNotification(
      {required int hour, required int minute, required Task task}) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          task.id!.toInt(),
          task.title,
          task.name,
          _convertTime(hour, minute),
          NotificationDetails(
            android: AndroidNotificationDetails('channelId', 'channelName',
                channelDescription: 'channelDescription',
                importance: Importance.max,
                priority: Priority.high,
                largeIcon:
                    const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
                styleInformation: BigTextStyleInformation(task.name!,
                    contentTitle: task.title!)),
            iOS: IOSNotificationDetails(),
          ),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: '${task.id}',
          androidAllowWhileIdle: true);
    } catch (e) {
      print('error');
    }
  }

  timeZone.TZDateTime _convertTime(int hour, int minute) {
    timeZone.TZDateTime now = timeZone.TZDateTime.now(timeZone.local);
    timeZone.TZDateTime scheduledDate = timeZone.TZDateTime(
        timeZone.local, now.year, now.month, now.day, hour, minute);
    return scheduledDate;
  }

  Future<void> _configLocalTimeZone() async {
    timeZone.initializeTimeZones();
    final String locationName = await FlutterNativeTimezone.getLocalTimezone();
    timeZone.setLocalLocation(timeZone.getLocation(locationName));
  }
}
