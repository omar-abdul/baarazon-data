import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/services.dart';

class NoInternetPaymentScreen extends StatelessWidget {
  NoInternetPaymentScreen({super.key, required this.service});
  final ServiceModel service;

  late final Map<String, String> _paymentMethods = {
    'assets/payment_logos/Sahal.png':
        '*883*09044444*${service.advertisedPrice}#',
    'assets/payment_logos/zaad.png':
        '*880*063111111*${service.advertisedPrice}#',
    'assets/payment_logos/eDahab.png':
        '*110*066188888*${service.advertisedPrice}#',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service.description),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _paymentMethods.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20,
              children: [
                SizedBox(
                    width: 40,
                    child: Image.asset(_paymentMethods.keys.elementAt(index),
                        fit: BoxFit.contain)),
                Text(
                  _paymentMethods.values.elementAt(index),
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () {
                    final Uri telUri = Uri(
                      scheme: 'tel',
                      path: _paymentMethods.values.elementAt(index),
                    );
                    launchUrl(telUri);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
