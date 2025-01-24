import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../components/phone_number.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../logger.dart';
import '../../route/screen_exports.dart';
import '../../services/preferences_service.dart';

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
  bool loading = false;
  CountryWithPhoneCode? _country;

  @override
  void initState() {
    super.initState();

    _loadStoredValue();
    _initializeCountry();
    fToast = FToast();
    // Initialize fToast with context in the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fToast.init(context);
    });
  }

  Future<void> _initializeCountry() async {
    final regions = await getAllSupportedRegions();
    final region = regions['SO']!;
    setState(() {
      _country = region;
    });
  }

  _showToast(String message, bool? error) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
          color: error == false ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(25.0)),
      child: Text(message, style: const TextStyle(color: Colors.white)),
    );

    fToast.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 2),
      gravity: ToastGravity.BOTTOM,
    );
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
    setState(() {
      loading = true;
    });
    context.read<AuthCubit>().loginWithPhone(phoneNumberController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).pushReplacementNamed(entryPointRoute);
          setState(() {
            loading = false;
          });
        }
        if (state.status == AuthStatus.error) {
          logger.e(state.error);
          _showToast('An unknown error occurred', true);
          setState(() {
            loading = false;
          });
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

                    _country != null
                        ? PhoneNumber(
                            country: _country!,
                            controller: phoneNumberController,
                            onPhoneNumberChanged: (value) {},
                            initialValue: phoneNumber,
                          )
                        : const CircularProgressIndicator(),
                    const SizedBox(height: 30),

                    // Login Button
                    ElevatedButton(
                      onPressed: loading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            const Size(double.infinity, 50), // Full width
                        backgroundColor:
                            Colors.green, // Custom color for button
                      ),
                      child: loading
                          ? CircularProgressIndicator()
                          : const Text('Login',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
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
}
