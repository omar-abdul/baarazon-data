import 'package:flutter/material.dart';

class GolisScreen extends StatelessWidget {
  const GolisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Golis'),
        centerTitle: true,
      ),
      body: const Center(
        child: (Text('Golis')),
      ),
    );
  }
}
