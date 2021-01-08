import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reminder_payment/widgets/payments_item.dart';
import '../lib/models/payments.dart';
import '../lib/models/payment.dart';
import '../lib/screens/payments_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';

Payments payment;

class FirebaseAuthMock extends Mock implements Firebase {}

Widget createPaymentsScreen() => ChangeNotifierProvider<Payments>(
      create: (context) {
        payment = Payments();
        return payment;
      },
      child: MaterialApp(
        home: PaymentsItem(),
      ),
    );

void main() async {

  group('Payments Page Widget Tests', () {
    testWidgets('Test if ListView shows', (tester) async {
      await tester.pumpWidget(createPaymentsScreen());
      payment.fetchPayments();
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
