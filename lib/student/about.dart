import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key})
      : super(key: key); // Ensure a proper constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'App Version: 1.0.0',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              'Legal Information:\nLorem ipsum dolor sit amet, consectetur adipiscing elit.',
              style: TextStyle(fontSize: 16),
            ),
            // Add other details as necessary
          ],
        ),
      ),
    );
  }
}
