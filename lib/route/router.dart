import 'package:baarazon_data/screens/login/login_screen.dart';
import 'package:baarazon_data/screens/no_internet_payment/no_internet_payment_screen.dart';
import 'package:baarazon_data/screens/onboarding/onboarding_screen.dart';
import 'package:baarazon_data/screens/otp/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'screen_exports.dart';

/// Returns a route based on [settings.name].
///
/// The following routes are supported:
///
/// * [homeScreenRoute]: The home screen.
/// * [golisOptionsScreenRoute]: The Golis options screen.
/// * [somtelOptionsScreenRoute]: The Somtel options screen.
///
/// If [settings.name] is not recognized, the home screen is returned.
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case entryPointRoute:
      return MaterialPageRoute(builder: (context) => const EntryPoint());
    case homeScreenRoute:
      return MaterialPageRoute(builder: (context) => const HomeScreen());

    case profileScreenRoute:
      return MaterialPageRoute(builder: (context) => const ProfileScreen());
    case loginScreenRoute:
      return MaterialPageRoute(builder: (context) => const LoginPage());
    case onBoardingScreenRoute:
      return MaterialPageRoute(builder: (context) => const OnBoardingScreen());
    case otpVerificationRoute:
      return MaterialPageRoute(
          builder: (context) => const OtpVerificationScreen());
    case servicesAndPlansScreenRoute:
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (context) =>
              ServicesAndPlanScreen(provider: args['provider']));
    case noInternetServicesRoute:
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (context) =>
              NoInternetPaymentScreen(service: args['service']));

    default:
      return MaterialPageRoute(builder: (context) => const HomeScreen());
  }
}
