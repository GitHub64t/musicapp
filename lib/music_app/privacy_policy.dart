import 'package:flutter/material.dart';
import 'package:musicapp/widgets/appgraient.dart';


class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
 
   return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.thirdGradient
        ),
        child: SingleChildScrollView( // Move SingleChildScrollView to wrap entire content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                title: const Text(
                  "Privacy Policy",
                  style: TextStyle(color: AppGradients.whiteColor, fontSize: 25, fontWeight: FontWeight.w600),
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
                    _buildSection("1. Data Collection and Usage:", 
                    "EchoSync is an offline audio player. This app does not collect, store, or share any personal data, as it operates solely on locally stored audio files on your device. The app requires access to internal storage solely for the purpose of identifying and playing audio files. No data is transmitted to any server or third-party service."),
                    _buildSection("2. Permissions:", 
                      "The only permission EchoSync requests is access to your device’s internal storage to fetch and play audio files. This permission is essential for the app’s core functionality, allowing it to identify your locally stored audio. EchoSync does not access, use, or store any other data on your device."),
                    _buildSection("3. Security Measures:", 
                      "EchoSync prioritizes your privacy and security. Since it functions entirely offline, there is no internet usage, which minimizes data exposure risks. The app only interacts with audio files stored in your device’s internal storage, adhering to standard security practices to prevent unauthorized access."),
                    _buildSection("4. User Control:", 
                      "EchoSync allows users complete control over the audio files it plays. You can freely add, remove, or organize audio files within your device’s storage, as EchoSync reads only the audio files present on your device."),
                    _buildSection("5. Changes to Privacy Policy:", 
                      "Any changes to this Privacy Policy will be promptly updated here. Since EchoSync functions offline, updates are minimal, but any necessary changes will be clearly communicated."),
                   
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
              color:AppGradients.whiteColor,
              fontSize: 15,
              fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

}