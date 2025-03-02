import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

import '../../constants.dart';
import '../../cubits/regions/cubit.dart';
import '../../services/country_service.dart';
import '../../services/preferences_service.dart';

import '../../services/http_service.dart';
import '../../components/phone_number.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  CountryWithPhoneCode? country;
  String? phoneNumber;

  final TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with existing user data

    _intialize(); // Example number
  }

  Future<void> _intialize() async {
    final phoneNumber = await PreferencesService.getPhoneNumber();
    if (phoneNumber != null) {
      _numberController.text = phoneNumber;
    }
    final country = await CountryService().getSomaliaCountryCode();
    setState(() {
      this.country = country;
    });
  }

  Future<void> setPhoneNumber(String phoneNumber) async {
    try {
      await HttpService().post('/update-user-phone-number', body: {
        'phone_number': phoneNumber,
      });
      await PreferencesService.setPhoneNumber(phoneNumber);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update phone number')),
      );
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _saveProfile() {
    // if (!_isValidNumber) {
    //   // Show an error message
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please enter a valid number')),
    //   );
    //   return;
    // }

    // Save the updated profile information
    // Implement your save logic here

    setPhoneNumber(phoneNumber!);

    setState(() {
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  bool validatePhoneNumber(String number) {
    // Implement your validation logic (e.g., regex)
    // This is a simple example checking if the number is 10 digits
    return RegExp(r'^\d{9}$').hasMatch(number);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegionCubit, RegionState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Profile'),
            actions: [
              isEditing
                  ? IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: _saveProfile,
                    )
                  : IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: _toggleEdit,
                    ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header Section with Curved Background and Profile Icon
                Stack(
                  children: [
                    // Curved Background
                    ClipPath(
                      clipper: HeaderClipper(),
                      child: Container(
                        height: 200,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    // Profile Icon
                    const Positioned(
                      top:
                          100, // Adjust this value to position the icon vertically
                      left: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 80),

                        // Replace with your asset image or use NetworkImage
                      ),
                    ),
                  ],
                ),
                // Spacing between header and form
                const SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Number Field
                      // TextField(
                      //   controller: _numberController,
                      //   enabled: isEditing,
                      //   keyboardType: TextInputType.phone,
                      //   decoration: InputDecoration(
                      //     labelText: 'Number',
                      //     border: const OutlineInputBorder(),
                      //     errorText:
                      //         _isValidNumber ? null : 'Enter a valid number',
                      //   ),
                      //   onChanged: (value) async {
                      //     final phoneNumber = context.read<PhoneNumberCubit>();
                      //     setState(() {
                      //       _isValidNumber = validatePhoneNumber(value);
                      //     });

                      //     if (_isValidNumber) {
                      //       await setPhoneNumber(value);
                      //       phoneNumber
                      //           .changePhoneNumber(_numberController.text);
                      //     }
                      //   },
                      // ),
                      PhoneNumber(
                        onPhoneNumberChanged: (val) {
                          setState(() {
                            phoneNumber = val;
                          });
                        },
                        country: country!,
                        controller: _numberController,
                        enabled: isEditing,
                      ),
                      isEditing
                          ? IconButton(
                              onPressed: () {
                                setPhoneNumber(phoneNumber!);
                              },
                              icon: const Icon(Icons.save))
                          : const SizedBox(),

                      const SizedBox(height: 16.0),
                      // Location Dropdown
                      InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Regions>(
                            value:
                                context.watch<RegionCubit>().state.regionName,
                            isExpanded: true,
                            items: Regions.values.map((region) {
                              return DropdownMenuItem<Regions>(
                                value: region,
                                child: Text(region.displayName),
                              );
                            }).toList(),
                            onChanged: isEditing
                                ? (newValue) {
                                    context
                                        .read<RegionCubit>()
                                        .changeRegion(newValue!);
                                  }
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Custom Clipper for the Header
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Creating a curved path for the header
    Path path = Path();
    path.lineTo(0, size.height - 50);

    // Create a quadratic bezier curve for the bottom edge
    path.quadraticBezierTo(
      size.width / 2, // Control point X
      size.height, // Control point Y
      size.width, // End point X
      size.height - 50, // End point Y
    );
    path.lineTo(size.width, 0); // Right edge
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
