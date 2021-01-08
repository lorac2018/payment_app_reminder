import 'package:flutter/material.dart';
import '../models/payments.dart';
import '../widgets/payments_item.dart';
import 'package:provider/provider.dart';

class PaymentsScreen extends StatefulWidget {
  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = false;
      });
      Provider.of<Payments>(context, listen: false)
          .fetchPaymentsByUserId()
          .then((_) {
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
    final fetchedPayment = Provider.of<Payments>(context);

    final payments = fetchedPayment.itemsPayments;
    return Scaffold(
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: payments.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            value: payments[i], child: PaymentsItem()),
      ),
    );
  }
}
