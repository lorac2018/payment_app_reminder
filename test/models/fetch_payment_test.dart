// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/payment.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../../lib/models/fetch_payment.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('fetchPayments', () {
    test('returns a Payment if the http call is successful!', () async {
      final client = MockClient();

      when(client.get(
              'https://paymentreminderapp2-default-rtdb.firebaseio.com/payments.json'))
          .thenAnswer(
              (_) async => http.Response('{"namePayment": "Test"}', 200));

      expect(await fetchPayment(client), isA<Payment>());
    });
    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();
      when(client.get(
              'https://paymentreminderapp2-default-rtdb.firebaseio.com/payments.json'))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchPayment(client), throwsException);
    });
  });
}
