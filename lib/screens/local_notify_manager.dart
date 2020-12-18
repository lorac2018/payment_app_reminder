import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_reminder_payment/models/payment.dart';
import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';

class LocalNotifyManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initSetting;
  Payment payments;

  BehaviorSubject<ReceiveNotification> get didReceiveLocalNotificationSubject =>
      BehaviorSubject<ReceiveNotification>();

  LocalNotifyManager.init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      requestIOSPermission();
    }
    initializePlatform();
  }

  requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(alert: true, badge: true, sound: true);
  }

  initializePlatform() {
    var initSettingAndroid = AndroidInitializationSettings('app_icon');
    var initSettingsIOS = IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceiveNotification notification = ReceiveNotification(
              id: id, title: title, body: body, payload: payload);
          didReceiveLocalNotificationSubject.add(notification);
        });

    initSetting = InitializationSettings(initSettingAndroid, initSettingsIOS);
  }

  setOnNotificationReceive(Function onNotificationReceive) async {
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> showNotification(String title, String body) async {
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Reminder about $title',
      'You will be charged $body soon! ',
      platformChannel,
      payload: 'New Payload',
    );
  }

  Future<void> scheduleNotification() async {
    var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Schedule Title',
      'Notification Body',
      scheduleNotificationDateTime,
      platformChannel,
      payload: 'New payload',
    );
  }

  Future<void> repeatNotification() async {
    //var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'Schedule Title',
      'Repeat Body',
      RepeatInterval.EveryMinute,
      platformChannel,
      payload: 'New payload',
    );
  }

  Future<void> showDailyAtTimeNotification(String title, String body) async {
    var time = Time(14, 03, 0);
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      'Daily Reminder about $title',
      'You will be charged $body soon',
      time,
      platformChannel,
      payload: 'New payload',
    );
  }

  Future<void> showWeeklyNotification(String title, String body) async {
    var time = Time(15, 50, 0);
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
      0,
      'Weekly Reminder about $title + ${time.hour}-${time.minute}-${time.second}',
      'You will be charged $body soon',
      Day.Monday,
      time,
      platformChannel,
      payload: 'New payload',
    );
  }

  Future<void> showNotificationCloseDateSubscription(
      String title, String body, DateTime date) async {


    final scheduledNotificationDateTime =
    DateTime(date.year, date.month, date.day, 6);
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Reminder about $title',
      'You will be charged $body today.',
      scheduledNotificationDateTime,
      platformChannel,
      payload: 'New payload',
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

LocalNotifyManager localNotifyManager = LocalNotifyManager.init();

class ReceiveNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceiveNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}
