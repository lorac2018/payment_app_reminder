import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/payment.dart';
import '../models/payments.dart';
import 'package:provider/provider.dart';

class NewPaymentScreen extends StatefulWidget {
  static const routeName = '/add-payment';

  @override
  _NewPaymentScreenState createState() => _NewPaymentScreenState();
}

class _NewPaymentScreenState extends State<NewPaymentScreen> {
  final _amountFocusNode = FocusNode();
  final _namePaymentFocusNode = FocusNode();
  final budgetFocusNode = FocusNode();
  final _dateFocusNode = FocusNode();
  final _data = GlobalKey<FormState>();
  DateTime _selectedDate;
  String _displayDate;
  bool _isSubscription = false;
  bool _status = false;

  var _addPayment = Payment(
    id: null,
    namePayment: '',
    amount: 0,
    date: null,
  );
  var _initValues = {
    'namePayment': '',
    'amount': '',
    'date': '',
    'autoPaid': '',
  };
  var _isInit = true;

  _NewPaymentScreenState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final paymentId = ModalRoute.of(context).settings.arguments as String;
      if (paymentId != null) {
        _addPayment =
            Provider.of<Payments>(context, listen: false).findById(paymentId);
        _initValues = {
          'namePayment': _addPayment.namePayment,
          'amount': _addPayment.amount.toString(),
          'date': _addPayment.date.toString(),
          'autoPaid': _addPayment.autoPaid.toString(),
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _amountFocusNode.dispose();
    _namePaymentFocusNode.dispose();
    _dateFocusNode.dispose();

    super.dispose();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  Future<void> _submitData() async {
    //_data.currentState.validate();
    _data.currentState.save();

    try {
      await Provider.of<Payments>(context, listen: false)
          .addPayment(_addPayment);
      print(_addPayment.namePayment);
      print(_addPayment.date);
      print(_addPayment.amount);
      print(_addPayment.id.toString());
    } catch (error) {
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: Text('An error occurred!'),
                  content: Text('Something went wrong.'),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('Okay'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        })
                  ]));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
                key: _data,
                child: ListView(
                    padding: const EdgeInsets.all(10),
                    children: <Widget>[
                      //Title
                      TextFormField(
                          initialValue: _initValues['namePayment'],
                          decoration: InputDecoration(labelText: 'Title'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_namePaymentFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide the name.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _addPayment = Payment(
                              namePayment: value,
                              amount: _addPayment.amount,
                              date: _addPayment.date,
                              autoPaid: _addPayment.autoPaid,
                              id: _addPayment.id,
                            );
                          }),
                      Container(height: 10, width: 10),
                      TextFormField(
                          initialValue: _initValues['amount'],
                          decoration: InputDecoration(labelText: 'Amount'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _amountFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_amountFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide the price.';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number.';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Please enter a number greater than zero.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _addPayment = Payment(
                              namePayment: _addPayment.namePayment,
                              amount: double.parse(value),
                              date: _addPayment.date,
                              autoPaid: _addPayment.autoPaid,
                              id: _addPayment.id,
                            );
                          }),
                      Container(height: 30),
                      //Date
                      Container(height: 30),
                      ListTile(
                          leading: Icon(Icons.date_range),
                          title: GestureDetector(
                              child: Text('Data of purchase',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor)),
                              onTap: () {
                                _presentDatePicker();
                              }),
                          trailing: Text(
                            _selectedDate == null
                                ? 'No Date entered!'
                                : '${DateFormat.yMd().format(_selectedDate)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Theme.of(context).backgroundColor),
                          )),
                      TextFormField(
                          enabled: false,
                          onSaved: (value) {
                            _displayDate =
                                DateFormat('yyyy-MM-dd').format(_selectedDate);
                            _addPayment = Payment(
                              namePayment: _addPayment.namePayment,
                              amount: _addPayment.amount,
                              date: _displayDate,
                              autoPaid: _addPayment.autoPaid,
                              id: _addPayment.id,
                            );
                          }),
                      Container(height: 10, width: 10),
                      SizedBox(height: 20, width: 10),
                      ListTile(
                          leading: Icon(Icons.subscriptions),
                          title: Text('Is a subscription?',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor)),
                          trailing: CustomSwitch(
                              activeColor: Theme.of(context).buttonColor,
                              value: _isSubscription,
                              onChanged: (value) {
                                setState(() {
                                  _addPayment.autoPaid = value;
                                });
                              })),
                      Visibility(
                          visible: false,
                          child: Expanded(
                              child: TextFormField(
                                  initialValue: _initValues['autopaid'],
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "NULL";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _addPayment = Payment(
                                      namePayment: _addPayment.namePayment,
                                      amount: _addPayment.amount,
                                      date: _addPayment.date,
                                      autoPaid: _addPayment.autoPaid,
                                      id: _addPayment.id,
                                    );
                                  }))),
                      SizedBox(height: 20, width: 10),
                      RaisedButton(
                          child: Text('Add Payment',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).highlightColor,
                              )),
                          onPressed: _submitData),
                    ]))));
  }
}
