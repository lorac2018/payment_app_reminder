import 'package:flutter/material.dart';

//Model - One Single Payment
class Payment with ChangeNotifier {
  String id;
  String namePayment;
  double amount;
  DateTime date;
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

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    namePayment = json['namePayment'] as String;
    amount = json['amount'];
    date = json['date'] as DateTime;
  }
}
