import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_reminder_payment/models/payments.dart';
import 'package:provider/provider.dart';
import 'ScreenSecond.dart';
import 'local_notify_manager.dart';

class ManageNotifications extends StatefulWidget {
  static const routeName = '/managenotifications';

  @override
  _ManageNotificationsState createState() => _ManageNotificationsState();
}

class _ManageNotificationsState extends State<ManageNotifications> {
  DateTime date;

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
    final payment = Provider.of<Payments>(context);

    _convertDateFromString(String strDate){
      DateTime todayDate = DateTime.parse(strDate);
      print(todayDate);
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(payments.namePayment),
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              color: Theme.of(context).buttonColor,
              child: Text('Remind Me Daily'),
              textColor: Colors.white,
              onPressed: () async {
                //await localNotifyManager.showNotification(payments.namePayment.toString(), payments.amount.toString());
                //await localNotifyManager.scheduleNotification();
                //await localNotifyManager.repeatNotification();
                await localNotifyManager.showDailyAtTimeNotification(
                    payments.namePayment.toString(),
                    payments.amount.toString());
              },
            ),
            RaisedButton(
              color: Theme.of(context).buttonColor,
              child: Text('Remind me Weekly'),
              textColor: Colors.white,
              onPressed: () async{
                await localNotifyManager.showWeeklyNotification(
                    payments.namePayment.toString(),
                    payments.amount.toString());
              },
            ),
            RaisedButton(
              child: Text('Remind Me Closest to the Day Pay'),
              color: Theme.of(context).buttonColor,
              textColor: Colors.white,
              onPressed: () async {
                date = _convertDateFromString(payments.date);
                await localNotifyManager.showNotificationCloseDateSubscription(payments.namePayment, payments.amount.toString(), date);

              },
            )
          ],
        ),
      ),
    );
  }
}
