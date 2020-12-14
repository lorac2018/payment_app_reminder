import 'package:flutter/material.dart';
import '../screens/push_notifications_screen.dart';
import '../screens/add_payment_screen.dart';
import '../models/payments.dart';
import '../screens/payments_screen.dart';
import '../widgets/drawer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homepage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isInit = false;
  var _isLoading = false;
  bool dialogOpened = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = false;
      });
      Provider.of<Payments>(context).fetchPayments().then((_) {
        setState(() {
          _isLoading = true;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Payment App Reminder',
            style: TextStyle(fontSize: 18),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.notifications_active),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(LocalPushNotifications.routeName);
                }),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(NewPaymentScreen.routeName);
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            // StatelessWidgetDemo(),
          ],
        ),
        drawer: MainDrawer(),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : PaymentsScreen());
  }
}
