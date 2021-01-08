import 'package:flutter/material.dart';
import 'payment.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Payment> fetchPayment(http.Client client) async {
  const url =
      'https://paymentreminderapp2-default-rtdb.firebaseio.com/payments.json';
  final response = await client.get(url);

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Payment.fromJson(jsonDecode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}
