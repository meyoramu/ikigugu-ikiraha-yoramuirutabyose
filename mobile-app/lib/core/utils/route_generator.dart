// core/utils/route_generator.dart
import 'package:curry_puff_master/features/ar_preview/presentation/screens/ar_puff_screen.dart';
import 'package:curry_puff_master/features/cart/presentation/screens/checkout_screen.dart';
import 'package:curry_puff_master/features/home/presentation/screens/home_screen.dart';
import 'package:curry_puff_master/features/loyalty/presentation/screens/loyalty_screen.dart';
import 'package:curry_puff_master/features/order_tracking/presentation/screens/order_tracking_screen.dart';
import 'package:curry_puff_master/features/puff_builder/presentation/screens/puff_builder_screen.dart';
import 'package:curry_puff_master/features/puff_sommelier/presentation/screens/sommelier_screen.dart';
import 'package:curry_puff_master/features/social_sharing/presentation/screens/social_share_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/puff-builder':
        return MaterialPageRoute(builder: (_) => const PuffBuilderScreen());
      case '/ar-preview':
        return MaterialPageRoute(
          builder: (_) => ARPuffScreen(puffId: settings.arguments as int),
        );
      case '/sommelier':
        return MaterialPageRoute(
          builder: (_) => SommelierScreen(puffId: settings.arguments as int),
        );
      case '/loyalty':
        return MaterialPageRoute(builder: (_) => const LoyaltyScreen());
      case '/social-share':
        return MaterialPageRoute(builder: (_) => const SocialShareScreen());
      case '/checkout':
        return MaterialPageRoute(
          builder: (_) => CheckoutScreen(totalAmount: settings.arguments as double),
        );
      case '/order-tracking':
        return MaterialPageRoute(
          builder: (_) => OrderTrackingScreen(orderId: settings.arguments as String),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('ERROR: Route not found')),
      );
    });
  }
}