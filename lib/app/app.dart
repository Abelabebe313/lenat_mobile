import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/core/router.dart';
import 'package:lenat_mobile/view/auth/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:lenat_mobile/view/main/main_viewmodel.dart';
import 'package:lenat_mobile/view/splash/splash_viewmodel.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => MainViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
      child: GraphQLProvider(
        client: ValueNotifier(
          GraphQLClient(
            // link: HttpLink('http://92.205.167.80:8080/v1/graphql'),
            link: HttpLink(
              'http://92.205.167.80:8080/v1/graphql',
              defaultHeaders: {
                'x-hasura-admin-secret': '123',
              },
            ),
            cache: GraphQLCache(store: HiveStore()),
          ),
        ),
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
      ),
    );
  }
}
