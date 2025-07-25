import 'package:flutter/material.dart';
import 'package:lenat_mobile/view/ai_chat/ai_chat_view.dart';
import 'package:lenat_mobile/view/auth/login_view.dart';
import 'package:lenat_mobile/view/auth/verfication_view.dart';
import 'package:lenat_mobile/view/market/cart/cart_view.dart';
import 'package:lenat_mobile/view/market/checkout/checkout_view.dart';
import 'package:lenat_mobile/view/content/content_feed_view.dart';
import 'package:lenat_mobile/view/content/widget/content_feed_item.dart';
import 'package:lenat_mobile/view/notification/notification_view.dart';
import 'package:lenat_mobile/view/onboarding/onboarding_view.dart';
import 'package:lenat_mobile/view/premium/premium_view.dart';
import 'package:lenat_mobile/view/profile_edit/profile_edit_view.dart';
import 'package:lenat_mobile/view/profile_setup/gender_selector_page.dart';
import 'package:lenat_mobile/view/profile_setup/profile_setup_view.dart';
import 'package:lenat_mobile/view/splash/splash_view.dart';
import 'package:lenat_mobile/view/trivia/trivia_view.dart';
import '../view/main/main_view.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashView());

      case '/main':
        return MaterialPageRoute(builder: (_) => MainView());

      case '/onboarding':
        return MaterialPageRoute(builder: (_) => OnboardingView());

      case '/login':
        return MaterialPageRoute(builder: (_) => LoginView());

      case '/verification':
        return MaterialPageRoute(builder: (_) => VerificationView());

      case '/gender-selection':
        return MaterialPageRoute(builder: (_) => const GenderSelectionView());

      case '/profile-setup':
        return MaterialPageRoute(builder: (_) => const ProfileSetupView());

      case '/profile-edit':
        return MaterialPageRoute(builder: (_) => const ProfileEditView());

      case '/notifications':
        return MaterialPageRoute(builder: (_) => const NotificationView());

      case '/ai_chat':
        return MaterialPageRoute(builder: (_) => const AIChatView());

      case '/premium':
        return MaterialPageRoute(builder: (_) => PremiumView());

      // market

      case '/cart':
        return MaterialPageRoute(builder: (_) => const CartView());

      case '/checkout':
        return MaterialPageRoute(builder: (_) => CheckOutView());

      // Media

      // case '/content_feed':
      //   return MaterialPageRoute(builder: (_) => const ContentFeedView());
      // Trivia
      case '/trivia':
        return MaterialPageRoute(builder: (_) => const TriviaView());

      // case '/login':
      //   return MaterialPageRoute(builder: (_) => const LoginView());

      // Example: /detail?id=123
      // case '/detail':
      //   final args = settings.arguments as Map<String, dynamic>;
      //   final id = args['id'];
      //   return MaterialPageRoute(
      //     builder: (_) => DetailView(id: id),
      //   );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('404'))),
        );
    }
  }
}
