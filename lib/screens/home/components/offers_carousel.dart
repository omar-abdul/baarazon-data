import 'dart:async';

import 'package:baarazon_data/components/Banner/banner_m_style1.dart';
import 'package:baarazon_data/components/dot_indicators.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';

class OffersCarousel extends StatefulWidget {
  const OffersCarousel({
    super.key,
  });

  @override
  State<OffersCarousel> createState() => _OffersCarouselState();
}

class _OffersCarouselState extends State<OffersCarousel> {
  int _selectedIndex = 0;
  late PageController _pageController;
  late Timer _timer;

  // Offers List
  List offers = [
    BannerMStyle1(
      text: "New items with \nFree shipping",
      press: () {},
      image:
          "https://mir-s3-cdn-cf.behance.net/project_modules/fs/d1fa2f93546277.5e67adbfa56c3.jpg",
    ),
    BannerMStyle1(
      text: 'Hello',
      press: () {},
      image:
          'https://thumbs.dreamstime.com/z/modern-banner-gadgets-sale-products-vector-illustration-business-poster-different-d-isometric-items-goods-laptop-161612046.jpg',
    ),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_selectedIndex < offers.length - 1) {
        _selectedIndex++;
      } else {
        _selectedIndex = 0;
      }

      _pageController.animateToPage(
        _selectedIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.87,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: offers.length,
            onPageChanged: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            itemBuilder: (context, index) => offers[index],
          ),
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: SizedBox(
                height: 16,
                child: Row(
                  children: List.generate(
                    offers.length,
                    (index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: defaultPadding / 4),
                        child: DotIndicator(
                          isActive: index == _selectedIndex,
                          activeColor: Colors.white70,
                          inActiveColor:
                              const Color.fromARGB(137, 124, 124, 124)
                                  .withOpacity(0.3),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
