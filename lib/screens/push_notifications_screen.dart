import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'local_notify_manager.dart';
import 'ScreenSecond.dart';

class LocalPushNotifications extends StatefulWidget {
  static const routeName = '/notifications';

  @override
  _LocalPushNotificationsState createState() => _LocalPushNotificationsState();
}

class _LocalPushNotificationsState extends State<LocalPushNotifications> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setOnNotificationClick(onNotificationClick);
  }

  onNotificationReceive(ReceiveNotification notification) {
    print('Notification received: ${notification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload $payload');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ScreenSecond(payload: payload);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Local Notifications')),
      body: Center(
        child: FlatButton(
          onPressed: () async {
            //await localNotifyManager.showNotification();
            //await localNotifyManager.scheduleNotification();
            //await localNotifyManager.repeatNotification();
            // localNotifyManager.showDailyAtTimeNotification();
          },
          child: Text('Send Notification'),
        ),
      ),
    );
  }
}
