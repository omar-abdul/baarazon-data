import 'package:baarazon_data/constants.dart';

import 'package:baarazon_data/route/route_constants.dart';
import 'package:baarazon_data/cubits/regions/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../database/sqlite_db.dart';
import '../../models/models.dart';

class InternetProvidersList extends StatefulWidget {
  const InternetProvidersList({super.key});

  @override
  State<InternetProvidersList> createState() => _InternetProvidersListState();
}

class _InternetProvidersListState extends State<InternetProvidersList> {
  List<ProviderModel> _providers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    final SqliteDb db = SqliteDb();
    final ProviderDbHelper providerHelper = ProviderDbHelper(db: db);
    final providers = await providerHelper.getAllByRegion(
        context.read<RegionCubit>().state.regionName.displayName.toUpperCase());

    if (mounted) {
      setState(() {
        _providers =
            providers.where((provider) => provider.showInApp == true).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegionCubit, RegionState>(
      listener: (context, state) {
        // Reload providers when region changes
        _loadProviders();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Internet Data',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1, // Adjusted ratio for better look
              ),
              itemCount: _providers.length,
              itemBuilder: (context, index) {
                final provider = _providers[index];

                return Material(
                  child: InkWell(
                    onTap: () {
                      // Handle the tap
                      if (!provider.available) {
                        return;
                      } else {
                        Navigator.pushNamed(
                            context, servicesAndPlansScreenRoute,
                            arguments: {'provider': provider});
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[
                                    300], // Placeholder color for background
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12.0),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12.0),
                                ),
                                child: Image.asset(
                                  opacity: provider.available
                                      ? const AlwaysStoppedAnimation(1)
                                      : const AlwaysStoppedAnimation(.2),
                                  provider.imagePath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: provider.available
                                  ? Colors.white
                                  : Colors.transparent,
                              border: const Border(
                                  top: BorderSide(
                                      color: Colors.grey, width: .3)),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(12.0),
                              ),
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Center(
                              child: Text(
                                provider.available
                                    ? provider.displayName
                                    : 'Coming soon',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
