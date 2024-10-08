import 'package:baarazon_data/components/Banner/banner_m_style1.dart';
// import 'package:baarazon_data/components/custom_button.dart';
import 'package:baarazon_data/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baarazon_data/models/data_options/option_export.dart';
import '../../regions/cubit.dart';

class AmtelScreen extends StatefulWidget {
  const AmtelScreen({super.key});

  @override
  State<AmtelScreen> createState() => _AmtelScreenState();
}

class _AmtelScreenState extends State<AmtelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amtel'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: AmtelBanner()),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
            SliverToBoxAdapter(child: AmtelOptions()),
          ],
        ),
      ),
    );
  }
}

class AmtelBanner extends StatelessWidget {
  const AmtelBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BannerMStyle1(
      image:
          'https://example.com/amtel_banner_image.jpg', // Replace with Amtel's banner image URL
      press: () {},
      text: 'Amtel',
    );
  }
}

class AmtelOptions extends StatefulWidget {
  const AmtelOptions({super.key});

  @override
  State<AmtelOptions> createState() => _AmtelOptionsState();
}

class _AmtelOptionsState extends State<AmtelOptions> {
  Set<PackageType> _packageSet = {};
  late PackageType _package;

  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _buttonKeys = [];

  @override
  void initState() {
    super.initState();
    _packageSet = providerPackageTypes['Amtel']
            ?[BlocProvider.of<RegionCubit>(context).state.regionName] ??
        {};
    if (_packageSet.isNotEmpty) {
      _package = _packageSet.first;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildSegmentedButtons() {
    _buttonKeys.clear();

    List<Widget> buttons = [];

    for (var package in _packageSet) {
      GlobalKey key = GlobalKey();
      _buttonKeys.add(key);

      buttons.add(
        GestureDetector(
          key: key,
          onTap: () {
            setState(() {
              _package = package;
            });
            _scrollToButton(key);
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              color: _package == package
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              package.displayName,
              style: TextStyle(
                color: _package == package ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    return Row(children: buttons);
  }

  void _scrollToButton(GlobalKey key) {
    RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null && _scrollController.hasClients) {
      // Position of the button relative to the screen
      Offset buttonPosition = renderBox.localToGlobal(Offset.zero);

      // Width of the button
      double buttonWidth = renderBox.size.width;

      // Get the screen width
      double screenWidth = MediaQuery.of(context).size.width;

      // Calculate the target scroll offset
      double targetOffset = _scrollController.offset +
          buttonPosition.dx -
          (screenWidth / 2) +
          (buttonWidth / 2);

      // Ensure the target offset is within scroll bounds
      double maxScrollExtent = _scrollController.position.maxScrollExtent;
      double minScrollExtent = _scrollController.position.minScrollExtent;

      if (targetOffset < minScrollExtent) targetOffset = minScrollExtent;
      if (targetOffset > maxScrollExtent) targetOffset = maxScrollExtent;

      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Segmented Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: buildSegmentedButtons(),
          ),
        ),
        BlocBuilder<RegionCubit, RegionState>(
          builder: (context, state) {
            final regionEnum =
                BlocProvider.of<RegionCubit>(context).state.regionName;

            final List<Option> options = generateAmtelOption(
              regionEnum.displayName,
              _package,
            );

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on,
                        color: Theme.of(context).primaryColor),
                    const SizedBox(width: 8.0),
                    Text(
                      regionEnum.displayName,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Left Section: Option Title
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 40),
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Text(
                                option.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context).primaryColor),
                              ),
                            ),
                            // Center Section: Option Name and Amount
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      '${option.currency == 'USD' ? '\$' : option.currency}   ${option.amount.toStringAsFixed(2)}',
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
                            // Right Section: Option Duration
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
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
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
