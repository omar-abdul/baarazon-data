import 'package:flutter/material.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Baarazon Data'),
      ),
      body: Center(
          child: Row(
        children: [
          Text('Thank You, your data is being processed'),
          Icon(Icons.check_circle, color: Colors.green),
        ],
      )),
    );
  }
}
