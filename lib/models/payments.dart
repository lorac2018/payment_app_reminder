import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/payment.dart';
import 'package:http/http.dart' as http;

//We want more than one payment, we want to establish direct communication between this
//widget and the inherited widgets associated, so we use Provider which has Change Notifier
//The other widgets will listen (through a listener), it is very helpful in passing data, instead of using the construtor of the widgets

class Payments with ChangeNotifier {
  List<Payment> _payments = [];

  List<Payment> get itemsPayments {
    return [..._payments];
  }

  Payment findById(String id) {
    return _payments.singleWhere((payment) => payment.id == id);
  }

//Função que calcula quanto já gastou naquela subscrição
  double totalAmountByProduct(String fetchedId) {
    var paymentId = findById(fetchedId);
    return paymentId.amount;
    /*return paymentId.amount * paymentId.n_subscriptions;*/
  }

// return the number of subscriptions
  int numberOfSubscriptions(String paymentId) {
    var fetchedId = findById(paymentId);
    return fetchedId.n_subscriptions;
  }

//Função que efetua o cálculo de quantas subscrições já subscreveu
  int nSubscriptions(String fetchedId) {
    //Primeiro, faz a diferença entre a data atual e a data de subscrição e verifica se (já) foi cobrado
    // Se sim, faz a contagem
    // Se não, break
    return 10;
  }

//Função que calcula quanto já gastou do orçamento fornecido
//Diferença entre o valor balance e a funcao total_spending
  double get overSpentAmount {
    var balance = 0.0;

    /* _payments.forEach((element) {
      balance = element.budget;
    });*/
    //return totalSpending - balance;
    return balance;
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
    DateTime now = DateTime.now();

    DateTime convertDate = DateTime.parse(payment.date);

    //Verifica se é uma subscrição, se sim, verifica se ainda não foi cobrado, associando o valor. Se for cobrado, não conta
    if (payment.autopaid == true) {
      //Verifica a data

      if (convertDate.isBefore(now)) {
        return payment.amount;
      } else
        return null;
    } else
      return payment.amount;
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
          date: data['date'],
          autopaid: data['autopaid'],
          notification: data['notification'],
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
          'budget': payment.budget,
          'date': payment.date,
          'autopaid': payment.autopaid,
          'notification': payment.notification,
          'userId': FirebaseAuth.instance.currentUser.uid,
        }),
      );
      final newPayment = Payment(
        namePayment: payment.namePayment,
        amount: payment.amount,
        budget: payment.budget,
        date: payment.date,
        autopaid: payment.autopaid,
        notification: payment.notification,
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
            'date': newPayment.date,
            'autopaid': newPayment.autopaid,
            'notification': newPayment.notification,
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
    final existingProductIndex = _payments.indexWhere((prod) => prod.id == id);
    var existingProduct = _payments[existingProductIndex];
    _payments.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _payments.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

  int get itemCount {
    return _payments.length;
  }
}
