import 'package:baarazon_data/components/custom_modal_bottom_sheet.dart';
import 'package:baarazon_data/constants.dart';
import 'package:baarazon_data/models/services.dart';
import 'package:baarazon_data/screens/payment/payment_screen.dart';
import 'package:baarazon_data/cubits/regions/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataOptions extends StatefulWidget {
  final List<ServiceModel> services;
  const DataOptions({super.key, required this.services});

  @override
  State<DataOptions> createState() => _DataOptionsState();
}

class _DataOptionsState extends State<DataOptions> {
  Set<String> _packageSet = {};
  String _package = '';

  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _buttonKeys = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _packageSet = widget.services.map((e) => e.type).toSet();
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
              package,
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

        final List<ServiceModel> services =
            widget.services.where((e) => e.type == _package).toList();
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
                    final service = services[index];
                    return DataOptionCard(service: service);
                  },
                  itemCount: services.length,
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
    required this.service,
    this.presentational = false,
  });

  final ServiceModel service;
  final bool presentational;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => !presentational
            ? customModalBottomSheet(context,
                child: PaymentBottomSheet(
                  service: service,
                ))
            : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 25),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(service.type,
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          service.description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${service.advertisedPrice.toStringAsFixed(2)} ${service.currency}',
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
                    '',
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
