import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../cubits/auth/auth_cubit.dart';
import '../../route/screen_exports.dart';
import '../../services/auth_service.dart';
import '../../services/preferences_service.dart';
import '../profile/cubit/cubit/phone_number_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneNumberController = TextEditingController();
  String? phoneNumber;
  String? token;
  final _formKey = GlobalKey<FormState>();
  late FToast fToast;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();

    _loadStoredValue();
    fToast = FToast();
  }

  _showToast(String message, bool? error) {
    fToast.showToast(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
              color: error == false ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(25.0)),
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
        toastDuration: const Duration(seconds: 2),
        gravity: ToastGravity.BOTTOM);
  }

  Future<void> _loadStoredValue() async {
    final storedValue = await PreferencesService.getPhoneNumber();
    final token = await PreferencesService.getToken();
    if (storedValue != null) {
      setState(() {
        phoneNumber = storedValue;
      });
    }
    if (token != null) {
      setState(() {
        this.token = token;
      });
    }
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.login(phoneNumberController.text);
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(entryPointRoute);
        }
      } catch (e) {
        if (mounted) {
          _showToast(e.toString(), true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isAuthenticated) {
          // Navigate to home screen or main app screen
          Navigator.of(context).pushReplacementNamed(entryPointRoute);
        }
        if (state.error != null) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      child: Scaffold(
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
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            const Size(double.infinity, 50), // Full width
                        backgroundColor:
                            Colors.green, // Custom color for button
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
