import 'package:flutter/material.dart';
import 'package:musicapp/widgets/appgraient.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.thirdGradient),
        child: SingleChildScrollView(
          // Move SingleChildScrollView to wrap entire content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                title: const Text(
                  "Terms and Conditions",
                  style: TextStyle(
                      color: AppGradients.whiteColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppGradients.whiteColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection("1. Acceptance of Terms",
                        "By downloading, installing, or using EchoSync, you agree to be bound by these Terms and Conditions. If you do not agree with these terms, please do not use the app."),
                    _buildSection("2. Description of Services",
                        "EchoSync is an offline audio player that allows users to access, play, and manage audio files stored locally on their device. The app operates without internet connectivity and does not provide or stream content from online sources."),
                    _buildSection("3. Intellectual Property",
                        "All rights, title, and interest in EchoSync, including but not limited to graphics, logos, and trademarks, are the property of the app developers. You may not modify, distribute, or use EchoSync’s content without prior written consent from the developers."),
                    _buildSection("4. Updates and Modifications",
                        "EchoSync may be updated periodically to enhance functionality or security. These updates may change some features or functionality of the app. Continued use of EchoSync following any update signifies your acceptance of the changes."),
                    _buildSection("5. Governing Law",
                        "These Terms and Conditions are governed by and construed in accordance with the laws of India. Any disputes arising from the use of EchoSync shall be resolved under the jurisdiction of Indian courts."),
                    _buildSection("6. Contact Information",
                        "If you have any questions or concerns about these terms, please contact us at 323nandhu@gmail.com"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: AppGradients.whiteColor,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 5),
        Text(
          content,
          style: const TextStyle(
              color: AppGradients.whiteColor,
              fontSize: 15,
              fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
