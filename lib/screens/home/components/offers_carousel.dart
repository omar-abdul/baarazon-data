import 'dart:async';
import 'dart:convert';

import 'package:baarazon_data/components/Banner/banner_m_style1.dart';
import 'package:baarazon_data/components/dot_indicators.dart';
import 'package:baarazon_data/components/skeleton.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../constants.dart';
import '../../../cubits/connectivity/connectivity_cubit.dart';
import '../../../logger.dart';

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
  Timer? _timer;

  List _images = [];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _loadImages();

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadImages() async {
    try {
      final hasInternet =
          await context.read<ConnectivityCubit>().checkInternet();
      if (!hasInternet) {
        return;
      }
      final response = await http.get(Uri.parse('$API_URL/get_slider_images'));

      if (response.statusCode != 200) {
        logger.e('API Error: ${response.statusCode}');
        return;
      }

      var images = jsonDecode(response.body);
      logger.i('Received images: $images'); // Debug print

      if (mounted) {
        setState(() {
          _images = images.map((img) {
            logger.i('Processing image URL: $img'); // Debug print
            return BannerMStyle1(
              text: '',
              press: () {},
              image: img,
            );
          }).toList();
        });

        _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
          if (_selectedIndex < _images.length - 1) {
            _selectedIndex++;
          } else {
            _selectedIndex = 0;
          }

          if (_pageController.hasClients) {
            // Add this check
            _pageController.animateToPage(
              _selectedIndex,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
            );
          }
        });
      }
    } catch (e) {
      logger.e('Error loading images: $e');
      if (mounted) {
        setState(() {
          _images = []; // Set empty list on error
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _images.isNotEmpty
        ? AspectRatio(
            aspectRatio: 1.87,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: _images.length,
                  onPageChanged: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => _images[index],
                ),
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: SizedBox(
                      height: 16,
                      child: Row(
                        children: List.generate(
                          _images.length,
                          (index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: defaultPadding / 4),
                              child: DotIndicator(
                                isActive: index == _selectedIndex,
                                activeColor: Colors.white70,
                                inActiveColor:
                                    const Color.fromARGB(137, 124, 124, 124)
                                        .withValues(alpha: 0.3),
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
          )
        : SizedBox(
            height: 50,
            child: Skeleton(),
          );
  }
}
