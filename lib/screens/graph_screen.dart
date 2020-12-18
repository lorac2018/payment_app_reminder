import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_reminder_payment/models/payment.dart';
import 'package:flutter_reminder_payment/models/payments.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ChartScreen extends StatefulWidget {
  static const routeName = '/graphs';
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  ChartScreen(Object data, {this.label, this.spendingAmount, this.spendingPctOfTotal});

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  Widget build(BuildContext context) {
    var _payments = Provider.of<Payments>(context);
    // final paymentId =
    // ModalRoute.of(context).settings.arguments as String; //the id
    // var payments = Provider.of<Payments>(context).findById(paymentId);

    return Column(
      children: <Widget>[
        FittedBox(
          child: Text('\$${_payments.totalSpending.toStringAsFixed(0)}'),
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          height: 60,
          width: 10,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  color: Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                heightFactor: _payments.totalSpending,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text("Payments"),
      ],
    );
  }
}
