import 'package:flutter/material.dart';
import '../services/api.dart';
import '../models/payment.dart';
import '../services/locator.dart';



class PaymentListModel{
  API api = locator<API>();

  List<Payment> _products;

  List<Payment> get products {
    return _products;
  }

  Future getPayments() async {
    _products = await api.getPayments();
  }
}