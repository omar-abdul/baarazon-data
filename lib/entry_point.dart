import 'package:baarazon_data/components/custom_modal_bottom_sheet.dart';
// import 'package:baarazon_data/constants.dart';
import 'package:baarazon_data/screens/home/home_screen.dart';
import 'package:baarazon_data/screens/regions/regions_screen.dart';

import 'package:flutter/material.dart';
// import 'package:animations/animations.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  // final List _pages = const [HomeScreen()];

  // final int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.receipt_long),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.account_circle),
          )
        ],
      ),
      // body: PageTransitionSwitcher(
      //   duration: defaultDuration,
      //   child: _pages[_currentIndex],
      //   transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
      //     return FadeThroughTransition(
      //       animation: primaryAnimation,
      //       secondaryAnimation: secondaryAnimation,
      //       child: child,
      //     );
      //   },
      // ),
      body: const HomeScreen(),
      floatingActionButton: FloatingActionButton.large(
        shape: const CircleBorder(side: BorderSide.none),
        elevation: 8,
        onPressed: () {
          customModalBottomSheet(
            context,
            isDismissible: true,
            child: const Center(
              child: RegionsScreen(),
            ),
          );
        },
        child: const Icon(Icons.location_on_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
