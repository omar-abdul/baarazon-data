import 'package:baarazon_data/screens/regions/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/internet_providers/internet_providers_model.dart';

class InternetProvidersList extends StatelessWidget {
  const InternetProvidersList({super.key});

  // Create a list of internet providers

  @override
  Widget build(BuildContext context) {
    final filteredProviders = internetProviderMap.entries
        .where((entry) => entry.value.regions
            .contains(context.watch<RegionCubit>().state.regionName))
        .toList();

    return Padding(
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
            itemCount: filteredProviders.length,
            itemBuilder: (context, index) {
              final entry = filteredProviders[index];
              final InternetProvider provider = entry.value;

              return Material(
                child: InkWell(
                  onTap: () {
                    // Handle the tap
                    if (!provider.isAvailable) {
                      return;
                    } else {
                      Navigator.pushNamed(context, provider.route);
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
                                opacity: provider.isAvailable
                                    ? const AlwaysStoppedAnimation(1)
                                    : const AlwaysStoppedAnimation(.2),
                                provider.logoPath,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: provider.isAvailable
                                ? Colors.white
                                : Colors.transparent,
                            border: const Border(
                                top: BorderSide(color: Colors.grey, width: .3)),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(12.0),
                            ),
                          ),
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: Text(
                              provider.isAvailable
                                  ? provider.name
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
    );
  }
}
