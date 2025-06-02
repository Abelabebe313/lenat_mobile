import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'app/app.dart';
import 'app/service_locator.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  runApp(const MyApp());
}
