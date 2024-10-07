import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPress, required this.text});
  final void Function() onPress;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(onPressed: onPress, child: Text(text));
  }
}
