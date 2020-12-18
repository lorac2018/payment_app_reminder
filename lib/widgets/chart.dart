import 'package:flutter/material.dart';
import 'package:flutter_reminder_payment/models/payment.dart';
import 'package:intl/intl.dart';
import '../screens/graph_screen.dart';

class Chart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
    );
  }
}
