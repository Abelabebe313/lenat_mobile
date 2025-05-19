import 'package:flutter/material.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/core/router.dart';
import 'package:provider/provider.dart';
import 'package:lenat_mobile/view/main/main_viewmodel.dart';
import 'package:lenat_mobile/view/splash/splash_viewmodel.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => MainViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lenat Mobile App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          appBarTheme: AppBarTheme(
            backgroundColor: appBarBackgroundColor,
          ),
        ),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: '/',
      ),
    );
  }
}
