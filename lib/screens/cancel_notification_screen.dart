import 'package:flutter/material.dart';
import 'ScreenSecond.dart';
import '../widgets/local_notify_manager.dart';
import 'package:rich_alert/rich_alert.dart';
import '../screens/homepage_screen.dart';

class CancelNotification extends StatefulWidget {
  static const routeName = '/cancel';

  @override
  _CancelNotificationState createState() => _CancelNotificationState();
}

class _CancelNotificationState extends State<CancelNotification> {
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
    return RichAlertDialog(
      alertTitle: Text("Cancel all Notifications?",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'Quicksand',
              color: Theme.of(context).accentColor),
          textAlign: TextAlign.justify),
      alertSubtitle: Text("Are you sure?",
          style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).primaryColor),
          textAlign: TextAlign.justify),
      alertType: RichAlertType.WARNING,
      actions: <Widget>[
        FlatButton(
          child: Text("YES",
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).accentColor),
              textAlign: TextAlign.justify),
          onPressed: () async {
            await localNotifyManager.cancelAllNotifications();
            Navigator.of(context).pushNamed(HomePage.routeName);
          }
        ),
        FlatButton(
          child: Text("NO",
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).accentColor,
              ),
              textAlign: TextAlign.justify),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}
