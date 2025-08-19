import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import 'package:lenat_mobile/services/local_storage.dart';
import 'package:chapasdk/chapasdk.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../app/service_locator.dart';

class PremiumViewModel extends ChangeNotifier {
  final AuthService _authService = locator<AuthService>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  void proceedToPayment() async {}

  List packages = [];
  int selectedIndex = 1;

  String getPackagesQuery = r'''
    query MyQuery {
      other_packages {
        id
        price
        is_active
        duration_in_months
      }
    }
  ''';

  String buySubscriptionMutation = r'''
    mutation MyQuery ($package_id: String!) {
      payment_subscription(package_id: $package_id) {
        url
      }
    }
  ''';

  Future<void> getPackages(BuildContext context) async {
    final client = GraphQLProvider.of(context).value;

    final result = await client.query(
      QueryOptions(document: gql(getPackagesQuery)),
    );

    if (result.hasException) {
      print(result.exception.toString());
    } else {
      packages = result.data!["other_packages"];
      notifyListeners();
    }
  }

  Future<void> buySubscription(BuildContext context) async {
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    final client = GraphQLProvider.of(context).value;

    final result = await client.mutate(MutationOptions(
      document: gql(buySubscriptionMutation),
      variables: {
        'package_id': packages[selectedIndex]["id"],
      },
    ));

    if (result.hasException) {
      print(result.exception.toString());
    } else {
      print(result.data);
      profileViewModel.refreshUserData();
      notifyListeners();
    }
  }
}
