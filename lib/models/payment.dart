import 'package:flutter/material.dart';

//Model - One Single Payment
class Payment with ChangeNotifier{
  final String id;
  final String namePayment;
  final double amount;
  final double budget;
  final String date;
  final int n_subscriptions;
  //is a subscription
  bool autopaid;
  bool notification;

  Payment({
    @required this.id,
    @required this.namePayment,
    @required this.amount,
    this.budget,
    @required this.date,
    this.n_subscriptions,
    this.autopaid = false,
    this.notification = false, userId,
  });
}
