import 'package:baarazon_data/screens/home/components/offers_carousel.dart';
import 'package:flutter/material.dart';

import 'components/internet_providers_list.dart';
import 'orders/orders.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
