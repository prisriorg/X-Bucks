import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to Our App!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'By accessing or using our app, you agree to be bound by these terms and conditions. If you disagree with any part of the terms, then you may not access the app.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              _buildSectionTitle('1. Use of Our App'),
              _buildSectionContent(
                'The use of this app is subject to the following terms of use:',
                [
                  'The content of the pages of this app is for your general information and use only. It is subject to change without notice.',
                  'Neither we nor any third parties provide any warranty or guarantee as to the accuracy, timeliness, performance, completeness, or suitability of the information and materials found or offered on this app for any particular purpose.',
                ],
              ),
              _buildSectionTitle('2. Privacy Policy'),
              _buildSectionContent(
                'Your privacy is important to us. Please read our Privacy Policy [link] carefully to understand how we collect, use, and disclose information about you.',
                [],
              ),
              _buildSectionTitle('3. Intellectual Property'),
              _buildSectionContent(
                'This app and its original content, features, and functionality are owned by us and are protected by international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights.',
                [],
              ),
              // Add more sections as needed
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String intro, List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          intro,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        if (points.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: points
                .map(
                  (point) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text('• $point'),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
