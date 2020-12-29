import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/payment.dart';

class API {
  var client = new http.Client();

  Future<List<Payment>> getPayments() async {
    var response = await client.get(
        'https://paymentreminderapp2-default-rtdb.firebaseio.com/payments.json');

    var data = json.decode(response.body) as Map<String, dynamic>;
    var loadedPayments = List<Payment>();

    data.forEach((payId, data) {
      loadedPayments.add(Payment(
        id: payId,
        namePayment: data['name_payment'],
        amount: data['amount'],
        nSubscriptions: data['nSubscriptions'],
        date: data['date'],
        autoPaid: data['autopaid'],
      ));
    });
    return loadedPayments;
  }
}
