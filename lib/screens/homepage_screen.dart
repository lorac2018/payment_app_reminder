import 'package:flutter/material.dart';
import '../screens/add_payment_screen.dart';
import '../models/payments.dart';
import '../screens/payments_screen.dart';
import '../widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../screens/search_screen.dart';

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
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(NewPaymentScreen.routeName);
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).pushNamed(SearchScreen.routeName);
              },
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
