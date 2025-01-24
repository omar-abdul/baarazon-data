import 'package:flutter/material.dart';

import '../../services/background_sync_service.dart';
import '../../services/firebase_messaging_service.dart';
import '../internet_providers/internet_providers_list.dart';
import 'components/offers_carousel.dart';
import 'orders/orders.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _initBgServiesAndFirebase();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _initBgServiesAndFirebase() async {
    await BackgroundSyncService.initialize();
    await BackgroundSyncService.registerPeriodicSync();
    final firebaseService = FirebaseService();
    await firebaseService.initialize();
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
