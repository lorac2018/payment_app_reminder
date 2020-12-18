/*Details of a single payment*/

import 'package:flutter/material.dart';
import '../models/payment.dart';
import 'package:provider/provider.dart';
import '../screens/payment_detail_screen.dart';

class PaymentsItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var payment = Provider.of<Payment>(context);
    return Card(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
          Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: Text('£' + payment.amount.toStringAsFixed(2),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor))),
          Column(children: <Widget>[
            Text(payment.namePayment,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 17.50,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).backgroundColor))
          ]),
          Divider(
            thickness: 3,
            height: 30,
          ),
          Column(children: [
            IconButton(
                icon: Icon(Icons.info, color: Theme.of(context).primaryColor),
                onPressed: () {
                  Navigator.of(context).pushNamed(PaymentDetailScreen.routeName,
                      arguments: payment.id);
                }),
            IconButton(
              icon: Icon(Icons.account_balance_wallet,
                  color: Theme.of(context).buttonColor),
              onPressed: () {},
            ),
          ]),
        ]));
  }
}
