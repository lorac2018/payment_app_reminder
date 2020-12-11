import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  static const routename = '/notification';

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final paymentId =
        ModalRoute.of(context).settings.arguments as String; //the id
    //var payments = Provider.of<Payments>(context).findById(paymentId);

    return Scaffold(
      body: ListTile(
        leading: Icon(Icons.cancel),
        trailing: CustomSwitch(
          activeColor: Theme.of(context).buttonColor,
          //value: payments.notification,
          onChanged: (value) {
            setState(() {
              //  payments.notification = value;
            });
          },
        ),
      ),
    );
  }
}
