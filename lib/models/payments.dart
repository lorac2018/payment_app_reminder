import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/payment.dart';
import 'package:http/http.dart' as http;

//We want more than one payment, we want to establish direct communication between this
//widget and the inherited widgets associated, so we use Provider which has Change Notifier
//The other widgets will listen (through a listener), it is very helpful in passing data, instead of using the construtor of the widgets

class Payments extends ChangeNotifier {
  List<Payment> _payments = [];
  String userId = FirebaseAuth.instance.currentUser.uid;
  DateTime dateLocal = DateTime.now();

  List<Payment> get itemsPayments {
    return [..._payments];
  }

  /*Payment findById(String id) {
    return _payments.firstWhere((payment) => payment.id == id);
  }*/

  Payment findById(String id) {
    if(_payments != null && _payments.length > 0) {
      return _payments.firstWhere((payment) => payment.id == id);
    }
  }

//Função que calcula quanto já gastou naquela subscrição
  double totalAmountByProduct(String fetchedId) {
    var paymentId = findById(fetchedId);

    if (paymentId.autoPaid == true) {
      print(paymentId.nSubscriptions);

      return paymentId.amount * nSubscriptions(paymentId.id);
    } else
      return paymentId.amount;
  }

//Função que efetua o cálculo de quantas subscrições já subscreveu
  int nSubscriptions(String fetchedId) {
    var paymentId = findById(fetchedId);

    Duration difference = DateTime.now().difference(paymentId.date);
    if (difference.inDays <= 30) {
      return paymentId.nSubscriptions;
    } else {
      paymentId.nSubscriptions = paymentId.nSubscriptions;
      return paymentId.nSubscriptions;
    }
  }

//Função que calcula quanto já gastou, no total.
  double get totalSpending {
    var total = 0.0;
    for (var value in _payments) {
      total += value.amount;
    }
    return total;
  }

//Função que calcula o que falta pagar de todas as subscrições associadas ao id daquele pagamento
  double leftToPayAmount(Payment payment) {
    Duration difference = DateTime.now().difference(payment.date);

    if (payment.autoPaid == true) {
      if (difference.inDays <= 30) {
        //É uma subscricao, mas ainda nao fez os 30 dias de renewal
        return payment.amount;
      } else {
        //30 Days are up.
        return 0.0;
      }
    } else
      return 0.0;
  }

  /*Fetch all info about the payments from the (firebase) database*/
  Future<void> fetchPayments() async {
    const url =
        'https://paymentreminderapp2-default-rtdb.firebaseio.com/payments.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Payment> loadedProducts = [];
      extractedData.forEach((payId, data) {
        loadedProducts.add(Payment(
          id: payId,
          namePayment: data['name_payment'],
          amount: data['amount'],
          nSubscriptions: data['nSubscriptions'],
          date: DateTime.parse(data['date']),
          autoPaid: data['autopaid'],
        ));
      });
      _payments = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addPayment(Payment payment) async {
    const url =
        'https://paymentreminderapp2-default-rtdb.firebaseio.com/payments.json';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'name_payment': payment.namePayment,
          'amount': payment.amount,
          'nSubscriptions': payment.nSubscriptions,
          'date': payment.date.toIso8601String(),
          'autopaid': payment.autoPaid,
          'userId': FirebaseAuth.instance.currentUser.uid,
        }),
      );
      final newPayment = Payment(
        namePayment: payment.namePayment,
        amount: payment.amount,
        nSubscriptions: payment.nSubscriptions,
        date: payment.date,
        autoPaid: payment.autoPaid,
        id: json.decode(response.body)['name'],
      );
      _payments.add(newPayment);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  //Edit Payments
  Future<void> editPayments(String id, Payment newPayment) async {
    final paymentIndex = _payments.indexWhere((payment) => payment.id == id);
    if (paymentIndex >= 0) {
      final url =
          'https://paymentreminderapp2-default-rtdb.firebaseio.com/payments/$id.json';
      await http.patch(url,
          body: json.encode({
            'name_payment': newPayment.namePayment,
            'amount': newPayment.amount,
            'date': newPayment.date.toIso8601String(),
            'autopaid': newPayment.autoPaid,
          }));
      _payments[paymentIndex] = newPayment;
      notifyListeners();
    } else {
      print('...');
    }
  }

  //Delete Payments
  Future<void> deletePayments(String id) async {
    final url =
        'https://paymentreminderapp2-default-rtdb.firebaseio.com/payments/$id.json';
    final existingPaymentIndex =_payments.indexWhere((payment) => payment.id == id);
    var existingPayment = _payments[existingPaymentIndex];
    _payments.removeAt(existingPaymentIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _payments.insert(existingPaymentIndex, existingPayment);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingPayment = null;
  }

  int get itemCount {
    return _payments.length;
  }

  Future<void> fetchPaymentsByUserId() async {
    var url =
        'https://paymentreminderapp2-default-rtdb.firebaseio.com/payments.json?orderBy="userId"&equalTo="$userId"';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);

      if (extractedData == null) {
        return;
      }
      final List<Payment> loadedProducts = [];
      extractedData.forEach((payId, data) {
        loadedProducts.add(Payment(
          id: payId,
          namePayment: data['name_payment'],
          amount: data['amount'],
          nSubscriptions: data['nSubscriptions'],
          date: DateTime.parse(data['date']),
          autoPaid: data['autopaid'],
        ));
        loadedProducts.sort((data, data1) => data1.date.compareTo(data.date));
      });
      _payments = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
