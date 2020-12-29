import 'package:flutter/material.dart';

//Model - One Single Payment
class Payment with ChangeNotifier {
  final String id;
  final String namePayment;
  final double amount;
  final DateTime date;
  int nSubscriptions;
  bool autoPaid;

  Payment({
    @required this.id,
    @required this.namePayment,
    @required this.amount,
    @required this.date,
    this.nSubscriptions,
    this.autoPaid = false,
  });
}
