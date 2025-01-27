import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/custom_bottom_navigation/custom_bottom_navigation.dart';
import 'cubits/connectivity/connectivity_cubit.dart';
import './constants.dart';
import './route/screen_exports.dart';

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
