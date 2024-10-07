import 'package:baarazon_data/components/Banner/banner_m_style1.dart';
// import 'package:baarazon_data/components/custom_button.dart';
import 'package:baarazon_data/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baarazon_data/models/data_options/option_export.dart';
import '../../regions/cubit.dart';

class SomtelScreen extends StatefulWidget {
  const SomtelScreen({super.key});

  @override
  State<SomtelScreen> createState() => _SomtelScreenState();
}

class _SomtelScreenState extends State<SomtelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Somtel'),
        centerTitle: true,
      ),
      body: const SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SomtelBanner()),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          SliverToBoxAdapter(child: SomtelOptions())
        ],
      )),
    );
  }
}

class SomtelBanner extends StatelessWidget {
  const SomtelBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BannerMStyle1(
      image:
          'https://media-exp1.licdn.com/dms/image/C4D1BAQGCBEqsfs0ESw/company-background_10000/0/1625908078920?e=2147483647&v=beta&t=aazI6Qozdgj4RYcQKwZcFGRmoP2LHfohWzvDoceV3KU',
      press: () {},
      text: 'Somtel',
    );
  }
}

class SomtelOptions extends StatefulWidget {
  const SomtelOptions({super.key});

  @override
  State<SomtelOptions> createState() => _SomtelOptionsState();
}

class _SomtelOptionsState extends State<SomtelOptions> {
  Set<PackageType> _packageSet = {};
  PackageType _package = PackageType.prepaid;

  @override
  void initState() {
    super.initState();
    _packageSet = providerPackageTypes['Somtel'] ?? {};
  }

  @override
  Widget build(BuildContext context) {
    List<ButtonSegment<PackageType>> getButtonSegments() {
      return _packageSet
          .map((package) => ButtonSegment<PackageType>(
              value: package, label: Text(package.displayName)))
          .toList();
    }

    return Column(
      children: [
        SegmentedButton<PackageType>(
          segments: getButtonSegments(),
          selected: _packageSet,
          onSelectionChanged: (newSelected) {
            setState(() {
              _package = newSelected.first;
            });
          },
        ),
        BlocBuilder(
            builder: (context, state) {
              final regionEnum =
                  BlocProvider.of<RegionCubit>(context).state.regionName;

              final List<Option> options = generateSomtelOption(
                regionEnum.displayName,
                _package,
              );

              return SizedBox(
                height: 500,
                child: Column(
                  children: [
                    Text(regionEnum.displayName,
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 10),
                    ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final option = options[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor, // Green background color
                                borderRadius: BorderRadius.circular(
                                    20.0), // Rounded corners
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // Left Section: "PREPAID"
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 30),
                                    decoration: const BoxDecoration(
                                        color: Colors.white),
                                    child: Text(option.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                  ),
                                  // Center Section: "UNLIMITED CALL" and "$0.22"
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:
                                              Theme.of(context).primaryColor),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            option.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '\$${option.amount.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Right Section: "24/h"
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Text(
                                      option.duration,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: options.length),
                  ],
                ),
              );
            },
            bloc: BlocProvider.of<RegionCubit>(context)),
      ],
    );
  }
}
