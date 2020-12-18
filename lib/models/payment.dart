import 'package:flutter/material.dart';

//Model - One Single Payment
class Payment with ChangeNotifier {
  final String id;
  final String namePayment;
  final double amount;
  final double budget;
  final DateTime date;
  final int nDays;
  final int nSubscriptions;
  bool autoPaid;
  bool notification;

  Payment({
    @required this.id,
    @required this.namePayment,
    @required this.amount,
    this.budget,
    @required this.date,
    this.nDays,
    this.nSubscriptions,
    this.autoPaid = false,
    this.notification = false,
  });
}
