import 'package:baarazon_data/components/options_list_card.dart';
import 'package:baarazon_data/components/phone_number.dart';
import 'package:baarazon_data/screens/payment/cubit/payment_and_data_option_cubit.dart';
import 'package:baarazon_data/screens/payment/components/payment_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../database/sqlite_db.dart';
import '../../../models/models.dart';
import '../../../models/payment.dart';
import '../../../services/country_service.dart';
import '../../thank_you/thank_you_screen.dart';
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
  bool isLoading = false;

  String? senderNumber;
  String? rechargeNumber;
  CountryWithPhoneCode? country;

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
    _getCountry();
  }

  _getCountry() async {
    final country = await CountryService().getSomaliaCountryCode();
    setState(() {
      this.country = country;
    });
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

  _showToast(String message, {bool isError = false}) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: isError ? Colors.redAccent : Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isError ? Icons.error : Icons.check),
          const SizedBox(width: 12.0),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 4),
    );
  }

  _processPayment() {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });

    if (senderNumber == null || rechargeNumber == null) {
      setState(() {
        isLoading = false;
      });
      _showToast('Please enter both sender and  recharge numbers',
          isError: true);
      return;
    }

    context.read<PaymentCubit>().processPayment(PaymentRequest(
          payFrom: senderNumber!,
          payProvider: widget.entry.key.name,
          topupTo: rechargeNumber!,
          providerId: widget.service.providerId,
          service: PaymentService(
            id: widget.service.id!,
            amount: widget.service.advertisedPrice.toDouble(),
          ),
        ));

    if (context.read<PaymentCubit>().state.status == PaymentStatus.success) {
      setState(() {
        isLoading = false;
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ThankYouScreen()));
    }
    if (context.read<PaymentCubit>().state.status == PaymentStatus.failure) {
      setState(() {
        isLoading = false;
      });

      _showToast('Payment failed', isError: true);
    }
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

                      country != null
                          ? PhoneNumber(
                              onPhoneNumberChanged: (value) {
                                setState(() {
                                  senderNumber = value;
                                });
                              },
                              country: country!,
                              controller: _phoneController1,
                              labelText: 'Enter Sender Number',
                              showHint: false,
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: SizedBox(
                                    width: 20,
                                    child: Image.asset(
                                      fromUrl,
                                      fit: BoxFit.contain,
                                    )),
                              ),
                            )
                          : CircularProgressIndicator(),
                      const SizedBox(height: 16.0),
                      // Second phone number input

                      country != null
                          ? PhoneNumber(
                              onPhoneNumberChanged: (value) {
                                setState(() {
                                  rechargeNumber = value;
                                });
                              },
                              country: country!,
                              controller: _phoneController2,
                              labelText: 'Enter Recharge Number',
                              showHint: false,
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: SizedBox(
                                    width: 20,
                                    child: Image.asset(
                                      toUrl!,
                                      fit: BoxFit.contain,
                                    )),
                              ),
                            )
                          : const CircularProgressIndicator(),
                      const SizedBox(height: 20.0),
                      // Submit Button
                      Row(
                        children: [
                          Expanded(
                            child: isLoading
                                ? const SizedBox(
                                    height: 50,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ))
                                : FilledButton(
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
