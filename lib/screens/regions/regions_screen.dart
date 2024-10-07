import 'package:baarazon_data/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './cubit.dart';

class RegionsScreen extends StatelessWidget {
  const RegionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          final selected = context.read<RegionCubit>().state.regionName ==
              regionEnabled.keys.elementAt(index);
          return Card.outlined(
            elevation: 5,
            borderOnForeground: true,
            child: ListTile(
              // enabled: regionEnabled.values.elementAt(index),
              selected: context.watch<RegionCubit>().state.regionName ==
                  regionEnabled.keys.elementAt(index),
              selectedColor: Colors.white,
              selectedTileColor: Theme.of(context).primaryColor,
              onTap: () {
                context
                    .read<RegionCubit>()
                    .changeRegion(regionEnabled.keys.elementAt(index));
              },
              title: Text(
                regionEnabled.keys
                    .elementAt(index)
                    .toString()
                    .split('.')
                    .last
                    .toUpperCase(),
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: selected ? Colors.white : Colors.black),
              ),
            ),
          );
        },
        itemCount: regionEnabled.length,
      ),
    );
  }
}
