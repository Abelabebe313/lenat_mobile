import 'package:flutter/material.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import 'package:lenat_mobile/services/local_storage.dart';
import 'package:chapasdk/chapasdk.dart';

import '../../app/service_locator.dart';

class PremiumViewModel extends ChangeNotifier {
  final AuthService _authService = locator<AuthService>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  void proceedToPayment() async {}
}
