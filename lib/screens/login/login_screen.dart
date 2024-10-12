import 'package:baarazon_data/route/route_constants.dart';
import 'package:baarazon_data/screens/profile/cubit/cubit/phone_number_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../entry_point.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneNumberController = TextEditingController();
  bool? numberExists;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _loadStoredValue();
  }

  Future<void> _loadStoredValue() async {
    final prefs = await SharedPreferences.getInstance();
    final storedValue = prefs.getString('phoneNumber');
    if (storedValue != null) {
      setState(() {
        numberExists = true;
      });
    }
  }

  // Add a form key to manage the form
  @override
  Widget build(BuildContext context) {
    if (numberExists == true) {
      return const EntryPoint();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              // Wrap with Form widget
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png', // Your logo image here
                    height: 150,
                  ),
                  const SizedBox(height: 50),

                  // Phone Number Input
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixText: '+252 ', // Unchangeable prefix
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: _validatePhoneNumber, // Add validator here
                  ),
                  const SizedBox(height: 30),

                  // Login Button
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final navigator = Navigator.of(context);
                        final phoneNumberCubit =
                            context.read<PhoneNumberCubit>();
                        // If the form is valid, perform the login action
                        final pref = await SharedPreferences.getInstance();

                        await pref.setString(
                            'phoneNumber', phoneNumberController.text);
                        phoneNumberCubit
                            .changePhoneNumber(phoneNumberController.text);
                        navigator.pushReplacementNamed(entryPointRoute);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          const Size(double.infinity, 50), // Full width
                      backgroundColor: Colors.green, // Custom color for button
                    ),
                    child: const Text('Login',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Validation logic for phone number
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    if (value.length != 9) {
      // Phone numbers without country code should be 9 digits for Somalia
      return 'Enter a 9-digit phone number';
    }
    return null;
  }
}
