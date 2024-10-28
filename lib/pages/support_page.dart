import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How Can We Help You?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildSupportOption(
              context,
              'Contact Us',
              'Have a question or need assistance? Contact our support team.',
              () {
                // Implement contact us functionality
              },
            ),
            _buildSupportOption(
              context,
              'FAQs',
              'Find answers to frequently asked questions.',
              () {
                // Implement FAQs functionality
              },
            ),
            _buildSupportOption(
              context,
              'Report an Issue',
              'Encountered a problem? Let us know so we can assist you.',
              () {
                // Implement report issue functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportOption(BuildContext context, String title,
      String description, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // Border radius for the container
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold, // Text color
                ),
              ),
              SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16, // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
