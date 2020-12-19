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
      elevation: 15.0,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
      child: Container(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          leading: Container(
              padding: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 1.0, color: Colors.white))),
              child: Icon(Icons.adjust, color: Theme.of(context).primaryColor)),
          title: Text(
            payment.namePayment,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Row(children: [
            Icon(Icons.padding, color: Colors.grey),
            Text(
              '£' + payment.amount.toStringAsFixed(2),
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 15),
            )
          ]),
          trailing: Icon(Icons.keyboard_arrow_right,
              color: Theme.of(context).primaryColor, size: 30.0),
          onTap: () {
            Navigator.of(context).pushNamed(PaymentDetailScreen.routeName,
                arguments: payment.id);
          },
        ),
      ),
    );
  }
}
