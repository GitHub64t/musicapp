import 'package:flutter/material.dart';
import 'package:musicapp/widgets/appgraient.dart';

class Version extends StatelessWidget {
  const Version({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.thirdGradient
        ),
        child: SingleChildScrollView(
          // Move SingleChildScrollView to wrap entire content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                title: const Text(
                  "Version",
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
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                                height: 350,
                                width: 350,
                                child: Image.asset(
                                  "assets/images/logo.png",
                                )),
                            // Text(
                            //                           'ECHOSYNC',
                            //                           style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,color: Colors.white),
                            //                         ),
                            //                         SizedBox(height: 8),

                            const Text(
                              'Version 1.0.0',
                              style: TextStyle(
                                  fontSize: 18, color: AppGradients.whiteColor),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              textAlign: TextAlign.center,
                              'EchoSync is a modern music player built with Flutter, offering seamless audio playback, playlist management, and an intuitive user experience.',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 196, 196, 196),
                              ),
                            ),
                            const SizedBox(height: 500),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'EchoSync',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Version 1.0.0',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'EchoSync is a modern music player built with Flutter, offering seamless audio playback, playlist management, and an intuitive user experience.',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 24),
        
//           ],
//         ),
//       ),