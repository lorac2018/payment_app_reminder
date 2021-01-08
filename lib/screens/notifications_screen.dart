import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/payments.dart';
import 'package:provider/provider.dart';
import 'ScreenSecond.dart';
import '../widgets/local_notify_manager.dart';

class ManageNotifications extends StatefulWidget {
  static const routeName = '/managenotifications';

  @override
  _ManageNotificationsState createState() => _ManageNotificationsState();
}

class _ManageNotificationsState extends State<ManageNotifications> {

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
    final paymentId =
        ModalRoute.of(context).settings.arguments as String; //the id
    final payments = Provider.of<Payments>(context).findById(paymentId);

    return Scaffold(
      appBar: AppBar(
        title: Text(payments.namePayment),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Daily Notification',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).backgroundColor)),
            leading: Icon(Icons.notifications_active),
            subtitle: Text('Remind Me Daily',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor)),
            onTap: () async {
              //await localNotifyManager.showNotification(payments.namePayment.toString(), payments.amount.toString());
              //await localNotifyManager.scheduleNotification();
              //await localNotifyManager.repeatNotification();
              await localNotifyManager.showDailyAtTimeNotification(
                  payments.namePayment.toString(), payments.amount.toString());
            },
          ),
          Container(
            height: 10,
          ),
          ListTile(
            title: Text('Weekly Notification',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).backgroundColor)),
            leading: Icon(
              Icons.notifications_active,
            ),
            subtitle: Text('Remind Me Weekly',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor)),
            onTap: () async {
              await localNotifyManager.showWeeklyNotification(
                  payments.namePayment.toString(), payments.amount.toString());
            },
          ),
          Container(height: 10),
          ListTile(
            title: Text('Custom Notification',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).backgroundColor)),
            leading: Icon(Icons.notifications_active),
            subtitle: Text('Remind Me Two Days Before',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor)),
            onTap: () async {
              await localNotifyManager.showNotificationCloseDateSubscription(
                  payments.namePayment, payments.amount.toString(), payments.date);
            },
          ),
        ],
      ),
    );
  }
}
