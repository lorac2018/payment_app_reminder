import 'package:flutter/material.dart';
import '../models/payments.dart';
import '../screens/payments_screen.dart';
import 'package:provider/provider.dart';

class PaymentOverviewScreen extends StatefulWidget {
  @override
  _PaymentOverviewScreenState createState() => _PaymentOverviewScreenState();
}

class _PaymentOverviewScreenState extends State<PaymentOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Payments>(context).fetchPayments().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : PaymentsScreen(),
    );
  }
}
