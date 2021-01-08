import 'package:flutter/material.dart';
import '../models/payments.dart';
import '../screens/homepage_screen.dart';
import 'package:provider/provider.dart';
import 'package:rich_alert/rich_alert.dart';

class DeletePaymentScreen extends StatelessWidget {
  static const routeName = '/delete';

  @override
  Widget build(BuildContext context) {
    final paymentId =
        ModalRoute.of(context).settings.arguments as String; //the id
    print(paymentId);

    var payment = Provider.of<Payments>(context, listen: false);

    return RichAlertDialog(
      alertTitle: Text("Delete Payment?",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'Quicksand',
              color: Theme.of(context).accentColor),
          textAlign: TextAlign.justify),
      alertSubtitle: Text("Have you cancelled the subscription?",
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
            try {
              await payment.deletePayments(paymentId);
              Navigator.of(context).pushNamed(HomePage.routeName);
            } catch (error) {
              print(error);
            }
          },
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
          onPressed: () async {
            try {
              payment.deletePayments(paymentId);
              Navigator.of(context).pop(false);
            } catch (error) {
              print('Deleting failed');
            }
          },
        ),
      ],
    );
  }
}
