import 'package:baarazon_data/components/custom_modal_bottom_sheet.dart';
import 'package:baarazon_data/constants.dart';
import 'package:baarazon_data/screens/payment/payment_screen.dart';
import 'package:baarazon_data/screens/regions/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/data_options/option_export.dart';

class DataOptions extends StatefulWidget {
  final String provider;

  const DataOptions({super.key, required this.provider});

  @override
  State<DataOptions> createState() => _DataOptionsState();
}

class _DataOptionsState extends State<DataOptions> {
  Set<PackageType> _packageSet = {};
  PackageType _package = PackageType.none;

  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _buttonKeys = [];

  @override
  void initState() {
    // TODO: implement initState
    _packageSet = providerPackageTypes[widget.provider]
            ?[context.read<RegionCubit>().state.regionName] ??
        {};
    if (_packageSet.isNotEmpty) {
      _package = _packageSet.first;
    }
    super.initState();
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
      Offset buttonPosition = renderBox.localToGlobal(Offset.zero);

      double buttonWidth = renderBox.size.width;
      double screenWidth = MediaQuery.of(context).size.width;

      double targetOffset = _scrollController.offset +
          buttonPosition.dx -
          (screenWidth / 2) +
          (buttonWidth / 2);

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
    return BlocBuilder<RegionCubit, RegionState>(
      builder: (context, state) {
        final regionEnum = state.regionName;

        final List<Option> options =
            generateOption(widget.provider, regionEnum.displayName, _package);
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
            Column(
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
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return DataOptionCard(option: option);
                  },
                  itemCount: options.length,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class DataOptionCard extends StatelessWidget {
  const DataOptionCard({
    super.key,
    required this.option,
  });

  final Option option;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => customModalBottomSheet(context,
            child: PaymentBottomSheet(
              option: option,
            )),
        child: Padding(
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
                Container(
                  height: 95,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(option.title,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Theme.of(context).primaryColor)),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
        ),
      ),
    );
  }
}