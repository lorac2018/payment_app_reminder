import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import '../screens/delete_payment_screen.dart';
import '../screens/edit_payment_screen.dart';
import '../screens/subscription_screen.dart';
import '../models/payments.dart';
import 'package:provider/provider.dart';

class PaymentDetailScreen extends StatelessWidget {
  //final String title;
  //PaymentDetailScreen(this.title);
  static const routeName = '/payment-detail';

  @override
  Widget build(BuildContext context) {
    //final routeArgs =
    //ModalRoute.of(context).settings.arguments as Map<String, String>;
    // final paymentTitle = routeArgs['title'];
    //final paymentId = routeArgs['id'];
    //final paymentautopaid = routeArgs['autopaid'];

    final paymentId =
        ModalRoute.of(context).settings.arguments as String; //the id
    final payments = Provider.of<Payments>(context).findById(paymentId);
    final payment = Provider.of<Payments>(context);

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
                            'Balance: £' +
                                payment.overSpentAmount.toStringAsFixed(2),
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
                                payment.totalSpending.toStringAsFixed(2),
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
                                payment.leftToPayAmount(payments).toString(),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).backgroundColor,
                            )))
                  ])),
          Container(height: 10),
          ListTile(
              leading: Icon(Icons.attach_money),
              title: Text(
                'Payment Due',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
              trailing: Text('\£${payments.amount}',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).backgroundColor,
                  ))),
          Container(height: 10),
          ListTile(
              leading: Icon(Icons.date_range),
              title: Text('Due Date',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor)),
              trailing: Text(payments.date,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).backgroundColor))),
          Container(height: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ListTile(
                leading: Icon(Icons.payment),
                title: Text('Auto-paid',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor)),
                trailing: LiteRollingSwitch(
                    value: payments.autopaid,
                    textOn: "On",
                    textOff: "Off",
                    colorOn: Theme.of(context).backgroundColor,
                    colorOff: Theme.of(context).primaryColor,
                    iconOn: Icons.done,
                    iconOff: Icons.do_not_disturb_off,
                    textSize: 15,
                    onChanged: (bool position) {
                      payments.autopaid = position;
                    })),
            Container(height: 10),
            ListTile(
                leading: Icon(
                  Icons.subscriptions,
                ),
                title: Text('Total Spent',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor)),
                trailing: Text(
                    //if subscription == true then shows the value of the subscription if not shows only the total amount of the payment
                    payments.autopaid == true
                        ? '£' +
                            payment
                                .totalAmountByProduct(paymentId)
                                .toStringAsFixed(2)
                        : payments.amount.toString(),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).backgroundColor)),
                onTap: () {
                  Navigator.of(context).pushNamed(SubscriptionScreen.routeName,
                      arguments: payments.id);
                }),
            Divider(thickness: 1),
            ListTile(
                leading: Icon(Icons.notification_important,
                    textDirection: TextDirection.ltr),
                title: Text('Notifications',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).backgroundColor))),
            Card(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  ListTile(
                    trailing: Icon(Icons.notifications_active),
                    title: Text('Manage Notification',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor)),
                    /*onTap: () {
                        Navigator.of(context).pushNamed(
                            NotificationScreen.routename,
                            arguments: paymentId);
                      }*/
                  ),
                  ListTile(
                    trailing: Icon(Icons.cancel_schedule_send_outlined),
                    title: Text('Cancel Notification',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor)),
                    /*trailing: LiteRollingSwitch(
                        value: payments.notification,
                        textOn: "On",
                        textOff: "Off",
                        colorOn: Theme.of(context).backgroundColor,
                        colorOff: Theme.of(context).primaryColor,
                        iconOn: Icons.done,
                        iconOff: Icons.do_not_disturb_off,
                        textSize: 15,
                        onChanged: (bool position) {
                          payments.notification = position;
                        },*/
                  ),
                  /*onTap: () {
                        Navigator.of(context).pushNamed(
                            NotificationScreen.routename,
                            arguments: paymentId);
                      }*/
                ])),
            ListTile(
              leading:
                  Icon(Icons.pending_actions, textDirection: TextDirection.ltr),
              title: Text('Operations Manager',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).backgroundColor)),
            ),
            Card(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  ButtonBar(children: [
                    Text('Edit Payment',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor)),
                    IconButton(
                      icon: Icon(Icons.edit),
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
                        icon: Icon(Icons.delete),
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
