import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/regions/cubit.dart';
import '../../../models/payment_options/payment_options.dart';
import '../../../models/services.dart';

class PaymentSelectionScreen extends StatelessWidget {
  const PaymentSelectionScreen({
    super.key,
    required this.service,
    required this.onSelectPayment,
  });

  final ServiceModel service;
  final void Function(
          MapEntry<PaymentOptions, PaymentOption> entry, BuildContext context)
      onSelectPayment;

  @override
  Widget build(BuildContext context) {
    final filteredPaymentOptions = paymentOptions.entries
        .where((entry) => entry.value.region
            .contains(context.watch<RegionCubit>().state.regionName))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            'Select Payment Method',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          )),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              final paymentOption = filteredPaymentOptions[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: PaymentCard(
                  title: paymentOption.key.displayName,
                  url: paymentOption.value.imageUrl,
                  service: service,
                  onTap: (_) => onSelectPayment(paymentOption, context),
                ),
              );
            },
            itemCount: filteredPaymentOptions.length,
          ),
        ),
      ],
    );
  }
}

class PaymentCard extends StatelessWidget {
  final String title;
  final String url;
  final ServiceModel service;
  final void Function(ServiceModel service) onTap;

  const PaymentCard(
      {super.key,
      required this.title,
      required this.url,
      required this.onTap,
      required this.service});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // To ensure the material effect works well
      child: InkWell(
        onTap: () => onTap(service),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 0), // Add padding to ensure content doesn't stick out
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    20), // Optional rounded corners for the image
                child: SizedBox(
                  height: 65,
                  width: 65,
                  child: Image.asset(url, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(
                  width:
                      20.0), // Keep a consistent space between image and text
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
