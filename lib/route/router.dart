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
    case golisOptionsScreenRoute:
      return MaterialPageRoute(builder: (context) => const GolisScreen());
    case somtelOptionsScreenRoute:
      return MaterialPageRoute(builder: (context) => const SomtelScreen());

    case hormuudOptionsScreenRoute:
      return MaterialPageRoute(builder: (context) => const HormuudScreen());
    case amtelOptionsScreenRoute:
      return MaterialPageRoute(builder: (context) => const AmtelScreen());

    case profileScreenRoute:
      return MaterialPageRoute(builder: (context) => const ProfileScreen());

    default:
      return MaterialPageRoute(builder: (context) => const HomeScreen());
  }
}
