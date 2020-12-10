import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  FlutterLocalNotificationsPlugin fltrNotification;
  String _selectedParam;
  String task;
  int val;

  @override
  void initState() {
    super.initState();
    var androidInitialize = new AndroidInitializationSettings('app_icon');
    var iOSinitialize = new IOSInitializationSettings();
    var initilizationSettings = null;
    // new InitializationSettings(androidInitialize, iOSinitialize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationSettings,
        onSelectNotification: notificationSelected);
  }

  _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Payment App Reminder", "Test");
    // importance: Importance.Max);
    var ISODetails = new IOSNotificationDetails();
    var generalNotificationsDetails = null;
    // new NotificationDetails(androidDetails, ISODetails);

    var scheduledTime = DateTime.now().add(Duration(seconds: 5));

    //    fltrNotification.schedule(1, "Title", "Scheduled Notification",
    //       scheduledTime, generalNotificationsDetails);
    if (_selectedParam == "Hour") {
      scheduledTime = DateTime.now().add(Duration(hours: val));
    } else if (_selectedParam == "Minute") {
      scheduledTime = DateTime.now().add(Duration(minutes: val));
    } else {
      scheduledTime = DateTime.now().add(Duration(seconds: val));
    }

    fltrNotification.schedule(
        1, "Times Uppp", task, scheduledTime, generalNotificationsDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton(
                  value: _selectedParam,
                  items: [
                    DropdownMenuItem(
                      child: Text("Seconds"),
                      value: "Seconds",
                    ),
                    DropdownMenuItem(
                      child: Text("Minutes"),
                      value: "Minutes",
                    ),
                    DropdownMenuItem(
                      child: Text("Hour"),
                      value: "Hour",
                    ),
                  ],
                  hint: Text(
                    "Select Your Field.",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onChanged: (_val) {
                    setState(() {
                      _selectedParam = _val;
                    });
                  },
                ),
                DropdownButton(
                  value: val,
                  items: [
                    DropdownMenuItem(
                      child: Text("1"),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("2"),
                      value: 2,
                    ),
                    DropdownMenuItem(
                      child: Text("3"),
                      value: 3,
                    ),
                    DropdownMenuItem(
                      child: Text("4"),
                      value: 4,
                    ),
                  ],
                  hint: Text(
                    "Select Value",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onChanged: (_val) {
                    setState(() {
                      val = _val;
                    });
                  },
                ),
              ],
            ),
            RaisedButton(
              onPressed: _showNotification,
              child: new Text('Set Notification'),
            )
          ],
        ),
      ),
    );
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text("Notification Clicked $payload"),
      ),
    );
  }

  Future<void> scheduleNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      String id,
      String body,
      DateTime scheduledNotificationDateTime) async {
    var androidPlataformChannelSpecifics = AndroidNotificationDetails(
        id, 'Reminder Notification', 'Remember about it');
    var iOSPlataformChannelSpecifics = IOSNotificationDetails();
    /*var plataformChannelSpecifics = NotificationDetails(
        androidPlataformChannelSpecifics, iOSPlataformChannelSpecifics);*/

    /*await flutterLocalNotificationsPlugin.schedule(0, "Reminder", body,
        scheduledNotificationDateTime, plataformChannelSpecifics);*/
  }

  Future<void> scheduleNotificationPeriodically(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      String id,
      String body,
      RepeatInterval) async {
    //var androidPlataformChannelSpecifics = AndroidNotificationDetails(
    //    id, "Reminder notifications", "Remember about it");
  }

  Future<void> turnOffNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> turnOffNotificationById(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      num id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
