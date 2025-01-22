import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants.dart';
import '../../cubits/regions/cubit.dart';

class RegionsScreen extends StatelessWidget {
  const RegionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final regionList = regionEnabled.keys.toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: regionList.length,
        itemBuilder: (context, index) {
          final region = regionList[index];
          final selected =
              context.watch<RegionCubit>().state.regionName == region;

          return RegionListItem(
            region: region,
            selected: selected,
            onTap: () {
              context.read<RegionCubit>().changeRegion(region);
            },
          );
        },
      ),
    );
  }
}

class RegionListItem extends StatelessWidget {
  final Regions region;
  final bool selected;
  final VoidCallback onTap;

  const RegionListItem({
    super.key,
    required this.region,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: selected ? 6 : 3,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          leading: Icon(
            Icons.location_on,
            color: selected ? Colors.white : Colors.grey,
          ),
          title: Text(
            region.displayName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : Colors.black87,
                ),
          ),
          trailing: selected
              ? const Icon(Icons.check_circle, color: Colors.white)
              : null,
          onTap: onTap,
        ),
      ),
    );
  }
}
