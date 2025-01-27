import 'package:baarazon_data/components/options_list_card.dart';
import 'package:baarazon_data/screens/payment/cubit/payment_and_data_option_cubit.dart';
import 'package:baarazon_data/screens/payment/components/payment_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../database/sqlite_db.dart';
import '../../../models/models.dart';
import '../../../models/payment.dart';
import '../cubit/payment_cubit.dart';

class PaymentComplete extends StatefulWidget {
  const PaymentComplete(
      {super.key, required this.service, required this.entry});
  final ServiceModel service;
  final MapEntry<PaymentOptions, PaymentOption> entry;

  @override
  State<PaymentComplete> createState() => PaymentCompleteState();
}

class PaymentCompleteState extends State<PaymentComplete> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController1 = TextEditingController();
  final _phoneController2 = TextEditingController();
  late FToast fToast;
  String? providerLogo;
  String? phoneNumber;

  // static const Map<String, String> providerLogoMap = {
  //   'amtel': 'assets/company_logo/amtel.png',
  //   'somtel': 'assets/company_logo/Somtel.png',
  //   'golis': 'assets/company_logo/Golis.png'
  // };

  @override
  void dispose() {
    _phoneController1.dispose();
    _phoneController2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _getProviderLogo();
  }

  _getProviderLogo() async {
    SqliteDb db = SqliteDb();
    ProviderDbHelper providerDbHelper = ProviderDbHelper(db: db);
    final provider =
        await providerDbHelper.getProvider(widget.service.providerId);

    if (mounted) {
      setState(() {
        providerLogo = provider?.imagePath;
      });
    }
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

  _processPayment() {
    context.read<PaymentCubit>().processPayment(PaymentRequest(
          payFrom: _phoneController1.text,
          payProvider: widget.entry.key.name,
          topupTo: _phoneController2.text,
          providerId: widget.service.providerId,
          service: PaymentService(
            id: widget.service.id!,
            amount: widget.service.advertisedPrice.toDouble(),
          ),
        ));
  }

  // Basic phone number validation (can be extended)

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Fadlan geli lambar';
    }
    if (value.length != 10) {
      return 'Fadlan geli lambar dhamaystiran';
    }

    print(value);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String fromUrl = widget.entry.value.imageUrl;
    String? toUrl = providerLogo;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                DataOptionCard(service: widget.service, presentational: true),
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
                    service: widget.service),
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
                            prefixIcon: providerLogo != null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: SizedBox(
                                        width: 20,
                                        child: Image.asset(
                                          toUrl!,
                                          fit: BoxFit.contain,
                                        )),
                                  )
                                : null),
                        keyboardType: TextInputType.phone,
                        validator: _validatePhoneNumber,
                      ),
                      const SizedBox(height: 20.0),
                      // Submit Button
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: _processPayment,
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
