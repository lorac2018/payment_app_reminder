// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import '../lib/models/payments.dart';
import '../lib/models/payment.dart';

Future<List<Payment>> getProducts() {
  return Future.value([
    Payment(
        id: "1",
        namePayment: "Smartwatch",
        amount: 200,
        date: DateTime.now(),
        autoPaid: false,
        nSubscriptions: 0),
    Payment(
        id: "2",
        namePayment: "Spotify",
        amount: 10,
        date: DateTime.now(),
        autoPaid: true,
        nSubscriptions: 1),
  ]);
}

void main() {
  Payments payments;

  group('Payment List Page', () {
    test('Page should load a list of payments from firebase', () async {
      await payments.fetchPayments();
      expect(payments.itemsPayments.length, 2);
      expect(payments.itemsPayments[0].namePayment, "Smartwatch");
      expect(payments.itemsPayments[0].amount, "200");
      expect(payments.itemsPayments[1].namePayment, "Spotify");
      expect(payments.itemsPayments[1].amount, "10");
    });

  });
}
