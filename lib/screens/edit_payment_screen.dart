import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/payment.dart';
import '../models/payments.dart';
import 'package:provider/provider.dart';

class EditPaymentScreen extends StatefulWidget {
  static const routeName = '/edit-payment';

  @override
  _EditPaymentScreenState createState() => _EditPaymentScreenState();
}

class _EditPaymentScreenState extends State<EditPaymentScreen> {
  final _amountFocusNode = FocusNode();
  final _namePaymentFocusNode = FocusNode();
  final _dateFocusNode = FocusNode();
  final _data = GlobalKey<FormState>();
  DateTime _selectedDate;
  bool _isSubscription = false;
  var _editedPayment = Payment(
    id: null,
    namePayment: '',
    amount: 0,
    date: null,
    autoPaid: null,
  );
  var _initValues = {
    'namePayment': '',
    'amount': '',
    'date': '',
    'autoPaid': false,
  };
  var _isInit = true;

  _EditPaymentScreenState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final paymentId = ModalRoute.of(context).settings.arguments as String;
      if (paymentId != null) {
        _editedPayment =
            Provider.of<Payments>(context, listen: false).findById(paymentId);
        _initValues = {
          'namePayment': _editedPayment.namePayment,
          'amount': _editedPayment.amount.toString(),
          'date': _editedPayment.date,
          'autoPaid': _editedPayment.autoPaid.toString(),
          'id': _editedPayment.id,
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
    final isValid = _data.currentState.validate();
    if (!isValid) {
      return;
    }
    _data.currentState.save();

    if (_editedPayment.id != null) {
      await Provider.of<Payments>(context, listen: false)
          .editPayments(_editedPayment.id, _editedPayment);
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
                          _editedPayment = Payment(
                            namePayment: value,
                            amount: _editedPayment.amount,
                            date: _editedPayment.date,
                            autoPaid: _editedPayment.autoPaid,
                            id: _editedPayment.id,
                          );
                        }),
                    Container(height: 10, width: 10),
                    TextFormField(
                        initialValue: _initValues['amount'],
                        decoration: InputDecoration(labelText: 'Amount'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _namePaymentFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_amountFocusNode);
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
                          _editedPayment = Payment(
                            namePayment: _editedPayment.namePayment,
                            amount: double.parse(value),
                            date: _editedPayment.date,
                            autoPaid: _editedPayment.autoPaid,
                            id: _editedPayment.id,
                          );
                        }),
                    Container(
                      height: 30,
                    ),
                    //Date
                    Container(height: 30),
                    ListTile(
                        leading: Icon(Icons.date_range),
                        title: GestureDetector(
                            child: Text(
                              'Data of purchase',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onTap: () {
                              _presentDatePicker();
                            }),
                        subtitle: Text(
                            _selectedDate == null
                                ? 'No Date entered!'
                                : '${DateFormat.yMd().format(_selectedDate)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Theme.of(context).backgroundColor,
                            ))),
                    TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                        ),
                        onSaved: (value) {
                          _editedPayment = Payment(
                            namePayment: _editedPayment.namePayment,
                            amount: _editedPayment.amount,
                            date: _selectedDate,
                            autoPaid: _editedPayment.autoPaid,
                            id: _editedPayment.id,
                          );
                        }),
                    ListTile(
                        leading: Icon(Icons.subscriptions),
                        title: Text('Is a subscription?',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            )),
                        trailing: CustomSwitch(
                            activeColor: Theme.of(context).buttonColor,
                            value: _isSubscription,
                            onChanged: (value) {
                              setState(() {
                                _editedPayment.autoPaid = value;
                              });
                            })),
                    Visibility(
                        visible: false,
                        child: Expanded(
                            child: TextFormField(
                                initialValue: _initValues['autoPaid'],
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "NULL";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedPayment = Payment(
                                      namePayment: _editedPayment.namePayment,
                                      amount: _editedPayment.amount,
                                      date: _editedPayment.date,
                                      autoPaid: _editedPayment.autoPaid,
                                      id: _editedPayment.id);
                                }))),
                    Container(height: 30,),
                    RaisedButton(
                        child: Text(
                          'Edit Payment',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).highlightColor,
                          ),
                        ),
                        onPressed: _submitData),
                  ]))), //SizedBox(height: 30),
    );
  }
}
