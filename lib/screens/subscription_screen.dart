
import 'package:flutter/material.dart';
import '../models/payments.dart';
import 'package:provider/provider.dart';
import '../screens/graph_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  static const routeName = '/subscription-detail';

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    final paymentId =
        ModalRoute.of(context).settings.arguments as String; //the id

    var paymentName = Provider.of<Payments>(context).findById(paymentId);
    var payments = Provider.of<Payments>(context).nSubscriptions(paymentId);


    return Scaffold(
        appBar: AppBar(
          title: Text(paymentName.namePayment),
        ),
        body: ListView(children: [
          Card(
              child: ListTile(
                  leading: Icon(
                    Icons.category,
                  ),
                  title: Text('Count of subscriptions',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor)),
                  trailing: Text(payments.toString(),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).backgroundColor)))),
          Card(
              child: ListTile(
            leading: Icon(Icons.insert_chart),
            title: Text('Data Visualization',
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
              Navigator.of(context).pushNamed(ChartScreen.routeName);
            },
          ))
        ]));
  }
}
