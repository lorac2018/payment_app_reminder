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
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Container(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          leading: Container(
              padding: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 1.0, color: Colors.white))),
              child: Image(
                image: AssetImage('assets/images/img2.png'),
              )),
          title: Text(
            payment.namePayment,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //Icon(Icons.padding, color: Colors.grey),
            Text(
              '£' + payment.amount.toString(),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 17),
            ),
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
