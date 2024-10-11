import 'package:flutter/material.dart';
// For SVG support

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Get in Touch!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Feel free to reach out to us through any of the following ways:',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),

          // Contact details
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.green),
            title: const Text(
              '+252 907798752',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              // Add functionality to make a phone call (if desired)
            },
          ),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.blue),
            title: const Text(
              'email@example.com',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              // Add functionality to send an email (if desired)
            },
          ),
          ListTile(
            leading: const Icon(Icons.facebook),
            title: const Text(
              'facebook.com/yourpage',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              // Add functionality to open social media
            },
          ),

          // You can add more contact options here (Instagram, LinkedIn, etc.)

          const SizedBox(height: 40),

          // Address section
          const Text(
            'Our Office',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.location_on, color: Colors.red),
            title: const Text(
              'New Bosaso Karaama Road',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              // Add functionality to open map
            },
          ),
        ],
      ),
    );
  }
}
