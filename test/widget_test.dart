// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../lib/services/locator.dart';
import '../lib/services/api.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/models/payments.dart';
import '../lib/models/payment.dart';
import '../lib/models/payment_list_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class MockAPI extends API {
  Future<List<Payment>> getPayments() {
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
}

void main() {
  setUpAll() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    //FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
    await setupLocator();
  }



  var paymentsLocator = locator<Payments>();
  paymentsLocator.api = MockAPI();

  group('Payment List Page', () {
    test('Page should load a list of payments from firebase', () async {
      await paymentsLocator.api.getPayments();
      expect(paymentsLocator.itemsPayments.length, 2);
      expect(paymentsLocator.itemsPayments[0].namePayment, "Smartwatch");
      expect(paymentsLocator.itemsPayments[0].amount, "200");
      expect(paymentsLocator.itemsPayments[1].namePayment, "Spotify");
      expect(paymentsLocator.itemsPayments[1].amount, "10");
    });
  });
}
