import 'package:baarazon_data/screens/internet_providers/screens/components/options_list_card.dart';
import 'package:baarazon_data/screens/payment/bloc/cubit/payment_and_data_option_cubit.dart';
import 'package:baarazon_data/screens/payment/components/payment_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  late FToast fToast;

  static const Map<String, String> providerLogoMap = {
    'amtel': 'assets/company_logo/amtel.png',
    'somtel': 'assets/company_logo/Somtel.png',
    'golis': 'assets/company_logo/Golis.png'
  };

  @override
  void dispose() {
    _phoneController1.dispose();
    _phoneController2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  _showToast(String message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text(message),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 4),
    );
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                DataOptionCard(option: widget.option, presentational: true),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
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
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //     const SnackBar(
                                  //         content: Text('Processing Data')));
                                  _showToast('Recharge Successful');
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
          ),
        ),
      ),
    );
  }
}
