import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/core/router.dart';
import 'package:lenat_mobile/view/ai_chat/ai_chat_viewmodel.dart';
import 'package:lenat_mobile/view/auth/auth_viewmodel.dart';
import 'package:lenat_mobile/view/consult/consult_page_viewmodel.dart';
import 'package:lenat_mobile/view/content/content_feed_viewmodel.dart';
import 'package:lenat_mobile/view/market/checkout/checkout_viewmodel.dart';
import 'package:lenat_mobile/view/market/market_viewmodel.dart';
import 'package:lenat_mobile/view/home/home_viewmodel.dart';
import 'package:lenat_mobile/view/media/media_viewmodel.dart';
import 'package:lenat_mobile/view/premium/premium_viewmodel.dart';
import 'package:lenat_mobile/view/profile_edit/profile_edit_viewmodel.dart';
import 'package:lenat_mobile/view/profile_setup/profile_setup_viewmodel.dart';
import 'package:lenat_mobile/view/trivia/question/question_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:lenat_mobile/view/main/main_viewmodel.dart';
import 'package:lenat_mobile/view/splash/splash_viewmodel.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';
import 'package:lenat_mobile/view/trivia/trivia_viewmodel.dart';
import 'package:lenat_mobile/view/market/cart/cart_viewmodel.dart';

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
        ChangeNotifierProvider(create: (_) => ProfileSetupViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileEditViewModel()),
        ChangeNotifierProvider(create: (_) => ContentFeedViewModel()),
        ChangeNotifierProvider(create: (_) => MediaViewModel()),
        ChangeNotifierProvider(create: (_) => TriviaViewModel()),
        ChangeNotifierProvider(create: (_) => QuestionViewModel()),
        ChangeNotifierProvider(create: (_) => MarketViewModel()),
        ChangeNotifierProvider(create: (_) => ConsultPageViewModel()),
        ChangeNotifierProvider(create: (_) => AiChatViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => PremiumViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => CheckoutViewModel()),
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
