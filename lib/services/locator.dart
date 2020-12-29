import 'package:flutter_reminder_payment/models/payment_list_model.dart';
import 'package:flutter_reminder_payment/screens/auth_screen.dart';

import '../models/payments.dart';
import 'package:get_it/get_it.dart';

import 'api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  /**/
  // locator.registerLazySingleton(() => FirebaseAuth.instanceFor());
  locator.registerSingleton<API>(API());

  /*Models*/
  locator.registerSingleton<Payments>(Payments());
}
