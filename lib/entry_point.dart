import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import 'components/custom_bottom_navigation/custom_bottom_navigation.dart';
import 'cubits/connectivity/connectivity_cubit.dart';
import './constants.dart';
import './route/screen_exports.dart';
import './services/app_version_service.dart';
import 'logger.dart';
import 'models/app_version.dart';
import 'screens/update_required/update_required_screen.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  final List _pages = const [
    HomeScreen(),
    ProvidersList(),
    ContactUsScreen(),
    ProfileScreen()
  ];

  int _currentIndex = 0;
  final _appVersionService = AppVersionService();
  Timer? _versionCheckTimer;

  @override
  void initState() {
    super.initState();
    _checkVersion();
    // Check version every 24 hours
    _versionCheckTimer = Timer.periodic(const Duration(hours: 1), (_) {
      _checkVersion();
    });
  }

  Future<void> _checkVersion() async {
    final versionCheck = await _appVersionService.checkVersion();
    logger.d('CHECK VERSION TIMER : ${versionCheck.needsUpdate}');
    if (versionCheck.needsUpdate && mounted) {
      if (versionCheck.forceUpdate) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => UpdateRequiredScreen(
              appVersion: versionCheck.appVersion!,
              forceUpdate: true,
            ),
          ),
        );
      } else {
        _showUpdateDialog(versionCheck.appVersion!);
      }
    }
  }

  void _showUpdateDialog(AppVersion version) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text('Update Available'),
        content: Text('New version is available.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          TextButton(
            onPressed: () {
              var url = '';
              if (Platform.isAndroid) {
                url = version.appLinks
                    .where((link) => link.platform == 'android')
                    .first
                    .storeUrl;
              } else if (Platform.isIOS) {
                url = version.appLinks
                    .where((link) => link.platform == 'ios')
                    .first
                    .storeUrl;
              }
              _launchStore(url);
              Navigator.pop(context);
            },
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
  void dispose() {
    _versionCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectionStatus>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: const SizedBox(),
            leadingWidth: 0,
            centerTitle: false,
            title: SizedBox(
              height: 100,
              width: 100,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
            actions: const [],
          ),
          body: PageTransitionSwitcher(
            duration: defaultDuration,
            child: _pages[_currentIndex],
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
              return FadeThroughTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
          ),

          bottomNavigationBar: CustomBtmNavigation(
            onItemSelected: (index) {
              if (_currentIndex != index) {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
            selectedIndex: _currentIndex,
          ),
          // body: const HomeScreen(),
          // floatingActionButton: FloatingActionButton.large(
          //   shape: const CircleBorder(side: BorderSide.none),
          //   elevation: 8,
          //   onPressed: () {
          //     customModalBottomSheet(
          //       context,
          //       isDismissible: true,
          //       child: const Center(
          //         child: RegionsScreen(),
          //       ),
          //     );
          //   },
          //   child: const Icon(Icons.location_on_outlined),
          // ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
