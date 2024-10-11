import 'package:baarazon_data/screens/payment/bloc/cubit/payment_and_data_option_cubit.dart';
import 'package:baarazon_data/screens/payment/components/payment_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/data_options/option_export.dart';
import '../../../models/payment_options/payment_options.dart';

class PaymentComplete extends StatefulWidget {
  const PaymentComplete({super.key, required this.option, required this.entry});
  final Option option;
  final MapEntry<PaymentOptions, PaymentOption> entry;

  @override
  State<PaymentComplete> createState() => PaymentCompleteState();
}

class PaymentCompleteState extends State<PaymentComplete> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController1 = TextEditingController();
  final _phoneController2 = TextEditingController();

  static const Map<String, String> providerLogoMap = {
    'amtel': 'assets/company_logo/amtel.png',
    'somtel': 'assets/company_logo/Somtel.png',
  };

  @override
  void dispose() {
    _phoneController1.dispose();
    _phoneController2.dispose();
    super.dispose();
  }

  // Basic phone number validation (can be extended)

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    if (value.length != 10) {
      return 'Enter a 10-digit phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String fromUrl = widget.entry.value.imageUrl;
    String toUrl = providerLogoMap[widget.option.id.split('_')[0]]!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 40),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Text(widget.option.title,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Theme.of(context).primaryColor)),
                  ),
                  Expanded(
                    child: Container(
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.option.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.option.currency == 'USD' ? '\$' : widget.option.currency}   ${widget.option.amount.toStringAsFixed(2)}',
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
                      widget.option.duration,
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
                child: Text(
              'Change Payment',
              style: Theme.of(context).textTheme.titleMedium!,
            )),
          ),
          PaymentCard(
              title: widget.entry.key.displayName,
              url: widget.entry.value.imageUrl,
              onTap: (option) {
                context.read<PaymentAndDataOptionCubit>().changePayment();
              },
              option: widget.option),
          const SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First phone number input
                TextFormField(
                  controller: _phoneController1,
                  decoration: InputDecoration(
                      labelText: 'Enter Sender Number',
                      border: const OutlineInputBorder(),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: SizedBox(
                            width: 20,
                            child: Image.asset(
                              fromUrl,
                              fit: BoxFit.contain,
                            )),
                      )),
                  keyboardType: TextInputType.phone,
                  validator: _validatePhoneNumber,
                ),
                const SizedBox(height: 16.0),
                // Second phone number input
                TextFormField(
                  controller: _phoneController2,
                  decoration: InputDecoration(
                      labelText: 'Enter Recharge Number',
                      border: const OutlineInputBorder(),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: SizedBox(
                            width: 20,
                            child: Image.asset(
                              toUrl,
                              fit: BoxFit.contain,
                            )),
                      )),
                  keyboardType: TextInputType.phone,
                  validator: _validatePhoneNumber,
                ),
                const SizedBox(height: 20.0),
                // Submit Button
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Process valid input
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')));
                          }
                        },
                        child: const Text('Pay'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
