import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './screens/auth_screen.dart';
import 'package:provider/provider.dart';
import './screens/add_payment_screen.dart';
import './screens/edit_payment_screen.dart';
import './screens/homepage_screen.dart';
import './screens/notifications_screen.dart';
import './screens/payment_detail_screen.dart';
import './screens/subscription_screen.dart';
import 'screens/delete_payment_screen.dart';
import 'models/payments.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final AuthService auth = Provider.of<AuthService>(context);
    return ChangeNotifierProvider(
      create: (c) => Payments(),
      child: MaterialApp(
        title: 'App Reminder Payment',
        theme: ThemeData(
            //(56,90,124)
            //scaffoldBackgroundColor: Color.fromRGBO(56, 90, 124, 1),
            primaryColor: Color.fromRGBO(56, 90, 124, 1),
            buttonColor: Color.fromRGBO(95, 122, 150, 1),
            highlightColor: Colors.white,
            //(199,196,184)
            backgroundColor: Color.fromRGBO(22, 36, 49, 1),
            accentColor: Color.fromRGBO(28, 45, 62, 1),
            errorColor: Colors.red,
            fontFamily: 'Quicksand'),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.hasData) {
                return HomePage();
              }
              return AuthScreen();
            }),
        routes: {
          //HomePage.routeName: (ctx) => HomePage(),
          PaymentDetailScreen.routeName: (ctx) => PaymentDetailScreen(),
          SubscriptionScreen.routeName: (ctx) => SubscriptionScreen(),
          NewPaymentScreen.routeName: (ctx) => NewPaymentScreen(),
          NotificationScreen.routename: (ctx) => NotificationScreen(),
          EditPaymentScreen.routeName: (ctx) => EditPaymentScreen(),
          DeletePaymentScreen.routeName: (ctx) => DeletePaymentScreen()
        },
      ),
    );
  }
}
