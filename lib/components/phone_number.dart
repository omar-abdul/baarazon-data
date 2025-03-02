import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

import '../cubits/regions/cubit.dart';

import '../constants.dart';
import '../logger.dart';

final textHintMap = {
  Regions.puntland: "090777777",
  Regions.somaliland: "0634444444",
  Regions.southSomalia: '061888888'
};

class PhoneNumber extends StatefulWidget {
  final Function(String?) onPhoneNumberChanged;
  final CountryWithPhoneCode country;
  final TextEditingController controller;
  final String? initialValue;
  final String? labelText;
  final bool? showHint;
  final Widget? prefixIcon;
  final bool? enabled;

  const PhoneNumber(
      {super.key,
      required this.onPhoneNumberChanged,
      required this.country,
      required this.controller,
      this.initialValue,
      this.labelText,
      this.showHint = true,
      this.prefixIcon,
      this.enabled = true});

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  bool _hasError = false;
  var hintText = '';

  @override
  void initState() {
    super.initState();
    hintText = textHintMap[context.read<RegionCubit>().state.regionName] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          enabled: widget.enabled,
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.labelText ?? 'Phone Number',
            hintText: widget.showHint! ? hintText : '',
            prefixIcon: widget.prefixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: _hasError
                ? const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  )
                : null,
          ),
          keyboardType: TextInputType.phone,
          onChanged: (value) async {
            try {
              final parsed =
                  await parse(value, region: widget.country.countryCode);
              setState(() {
                _hasError = false;
              });
              logger.d(parsed);
              widget.onPhoneNumberChanged(parsed['e164']);
            } catch (e) {
              setState(() => _hasError = true);
              widget.onPhoneNumberChanged(null);
            }
          },
        ),
        if (_hasError) ...[
          const SizedBox(height: 8),
          const Text(
            'Please enter a valid phone number',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
