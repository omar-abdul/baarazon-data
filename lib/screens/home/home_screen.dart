import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/app_version.dart';
import '../../services/app_version_service.dart';
import '../internet_providers/internet_providers_list.dart';
import 'components/offers_carousel.dart';
import 'orders/orders.dart';
import '../../screens/update_required/update_required_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _appVersionService = AppVersionService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkVersion();
    }
  }

  Future<void> _checkVersion() async {
    final check = await _appVersionService.checkVersion();
    if (check.needsUpdate && mounted) {
      if (check.forceUpdate) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => UpdateRequiredScreen(
              appVersion: check.appVersion!,
              forceUpdate: true,
            ),
          ),
        );
      } else {
        _showUpdateDialog(check.appVersion!);
      }
    }
  }

  void _showUpdateDialog(AppVersion version) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text('Update Available'),
        content: Text('Version ${version.versionName} is now available.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () => _launchStore(version.appLinks.storeUrl),
            child: const Text('Update Now'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchStore(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open store'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: OffersCarousel()),
        SliverToBoxAdapter(child: InternetProvidersList()),
        Orders(),
      ],
    );
  }
}
