import 'package:flutter/material.dart';

import '../../../database/sqlite_db.dart';
import '../../../models/models.dart';
import 'components/options_list_card.dart';

class ServicesAndPlanScreen extends StatefulWidget {
  final ProviderModel provider;
  const ServicesAndPlanScreen({super.key, required this.provider});

  @override
  State<ServicesAndPlanScreen> createState() => _ServicesAndPlanScreenState();
}

class _ServicesAndPlanScreenState extends State<ServicesAndPlanScreen> {
  List<ServiceModel> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getServices();
  }

  Future<void> _getServices() async {
    SqliteDb db = SqliteDb();
    ServicesDbHelper servicesDbHelper = ServicesDbHelper(db: db);
    final services =
        await servicesDbHelper.getAllServicesByProviderId(widget.provider.id!);

    if (mounted) {
      setState(() {
        _services = services;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.provider.displayName),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 10),
                  ),
                  SliverToBoxAdapter(
                    child: DataOptions(
                      services: _services,
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
