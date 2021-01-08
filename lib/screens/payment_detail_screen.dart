import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import '../screens/delete_payment_screen.dart';
import '../screens/edit_payment_screen.dart';
import '../screens/cancel_notification_screen.dart';
import '../models/payments.dart';
import 'package:provider/provider.dart';
import '../screens/notifications_screen.dart';
import 'package:intl/intl.dart';
import '../screens/recipt_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentDetailScreen extends StatelessWidget {
  static const routeName = '/payment-detail';

  @override
  Widget build(BuildContext context) {
    final paymentId =
        ModalRoute.of(context).settings.arguments as String; //the id
    final payments =
        Provider.of<Payments>(context, listen: false).findById(paymentId);
    final payment = Provider.of<Payments>(context, listen: false);

    String formattedDate = DateFormat('yyyy-MM-dd').format(payments.date);

    return Scaffold(
        appBar: AppBar(
          title: Text(payments.namePayment),
        ),
        body: ListView(children: [
          Card(
              margin: EdgeInsets.symmetric(vertical: 3),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(2),
                        child: Text(
                            'Total: £' +
                                payment.totalSpending.toStringAsFixed(2),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).backgroundColor))),
                    Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        child: Text(
                            'Paid: ' +
                                '£' +
                                payment
                                    .totalAmountByProduct(paymentId)
                                    .toStringAsFixed(2),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).backgroundColor))),
                    Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                            'Due: ' +
                                '£' +
                                payment
                                    .leftToPayAmount(payments)
                                    .toStringAsFixed(2),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).backgroundColor,
                            ))),
                  ])),
          Divider(
            thickness: 0.5,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ListTile(
                title: Text('More Info',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).backgroundColor))),
            ListTile(
                leading: Icon(Icons.date_range),
                title: Text('Due Date',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor)),
                trailing: Text(formattedDate,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).backgroundColor))),
            Container(
              height: 5,
            ),
            ListTile(
                leading: Icon(Icons.payment),
                title: Text('Auto-paid',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor)),
                trailing: LiteRollingSwitch(
                    value: payments.autoPaid,
                    textOn: "On",
                    textOff: "Off",
                    colorOn: Theme.of(context).backgroundColor,
                    colorOff: Theme.of(context).primaryColor,
                    iconOn: Icons.done,
                    iconOff: Icons.do_not_disturb_off,
                    textSize: 15,
                    onChanged: (bool position) {
                      payments.autoPaid = position;
                    })),
            Container(height: 5),
            ListTile(
              leading: Icon(Icons.adjust),
              title: Text('Count of Subscription',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor)),
              trailing: Text(
                  //if subscription == true then shows the value of the subscription if not shows only the total amount of the payment
                  payments.autoPaid == true
                      ? payment.nSubscriptions(payments.id).toString()
                      : '0',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).backgroundColor,
                  )),
            ),
            Divider(thickness: 1),
            Card(
                child: ListTile(
              leading: Icon(Icons.receipt),
              title: Text('Recipts',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor)),
              trailing: Text('Press here',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).backgroundColor)),
              onTap: () {
                Navigator.of(context).pushNamed(ReciptScreen.routeName);
              },
            )),
            Divider(thickness: 1),
            ListTile(
                title: Text('Notifications',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).backgroundColor))),
            Card(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  ListTile(
                      leading: Icon(Icons.notifications_active),
                      title: Text('Manage Notification',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor)),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            ManageNotifications.routeName,
                            arguments: paymentId);
                      }),
                  ListTile(
                      trailing: Icon(
                        Icons.cancel_schedule_send_outlined,
                      ),
                      title: Text('Cancel Notifications',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor)),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(CancelNotification.routeName);
                        //arguments: paymentId);
                      }),
                ])),
            Divider(thickness: 1),
            ListTile(
              title: Text('Operations Manager',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).backgroundColor)),
            ),
            Card(
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              ButtonBar(children: [
                Text('Edit Payment',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor)),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      EditPaymentScreen.routeName,
                      arguments: paymentId,
                    );
                  },
                ),
              ]),
              ButtonBar(
                children: [
                  Text('Delete Payment',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor)),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.grey),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          DeletePaymentScreen.routeName,
                          arguments: payments.id);
                    },
                  ),
                ],
              ),
            ]))
          ])
        ]));
  }
}
