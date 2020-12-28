import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models/payments.dart';
import '../screens/payment_detail_screen.dart';
import '../screens/payments_screen.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _isInit = true;
  var _isLoading = false;
  List payments = [];
  List filteredPayments = [];
  bool isSearching = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Payments>(context, listen: false)
          .fetchPaymentsByUserId()
          .then((_) {
        setState(() {
          _isLoading = false;
          payments =
              Provider.of<Payments>(context, listen: false).itemsPayments;
          filteredPayments = payments;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final paymentsFetched =
        Provider.of<Payments>(context, listen: false).itemsPayments;
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text('All Payments')
            : TextField(
                onChanged: (value) {
                  setState(() {
                    filteredPayments = paymentsFetched
                        .where((p) => p.namePayment
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: Icon(
                      FontAwesomeIcons.search,
                      color: Colors.white,
                    ),
                    hintText: "Search Payment Here",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
        actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      this.isSearching = false;
                      filteredPayments = payments;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      this.isSearching = true;
                    });
                  },
                ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: filteredPayments.length > 0
            ? ListView.builder(
                itemCount: filteredPayments.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          PaymentDetailScreen.routeName,
                          arguments: filteredPayments[index].id);
                    },
                    child: Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 8),
                        child: Text(
                          filteredPayments[index].namePayment,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  );
                })
            : Center(
                child: PaymentsScreen(),
              ),
      ),
    );
  }
}
