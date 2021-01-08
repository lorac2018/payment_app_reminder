import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_reminder_payment/main.dart';
import 'package:flutter_reminder_payment/models/payments.dart';
import 'package:flutter_reminder_payment/screens/payments_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reminder_payment/screens/homepage_screen.dart';
import '../../lib/screens/add_payment_screen.dart';
import 'package:provider/provider.dart';
import '../../lib/models/payment.dart';

Widget createHomeScreen() => ChangeNotifierProvider<Payments>(
      create: (context) => Payments(),
      child: MaterialApp(
        home: HomePage(),
      ),
    );

void main() {
  group('Home Page Widget Test', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      runApp(MyApp());
    });

    testWidgets('Testing if Payment Screen loads', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.byType(Center), findsOneWidget);
    });
    testWidgets('Testing Scrolling', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.text('Payment App Reminder'), findsOneWidget);
      await tester.fling(find.byType(ListView), Offset(0, -200), 3000);
      await tester.pumpAndSettle();
      expect(find.text('Payment App Reminder'), findsNothing);
    });

    testWidgets('Testing IconButtons', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.byIcon(Icons.add), findsNothing);
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byType(Navigator), findsOneWidget);
    });
  });
}
