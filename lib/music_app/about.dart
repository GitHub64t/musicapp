import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color(0xff663FB9),
            Color(0xff43297A),
            Color(0XFF19093B),
            Colors.black,
            Colors.black
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              title: const Text(
                "About",
                style: TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.w600),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
            ),
            
          const Padding(
              padding: EdgeInsets.only(left: 30, right: 30,top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "1.⁠ ⁠Acceptance of Terms",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                    SizedBox(height: 5,),
                  Text(
                    'By downloading and using the Echosync application ("App"), you agree to comply with and be bound by the following terms and conditions ("Terms of Service"). If you do not agree with these terms, please do not use the App',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "2. Use Of app",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),SizedBox(height: 5,),
                  Text(
                    'You agree to use Echosync for lawful purposes only. The App is designed to allow you to play music files stored on your device. You may not use Echosync in any way that is unlawful, fraudulent, or harmful, or in connection with any unlawful, fraudulent, or harmful purpose or activity. ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                   SizedBox(
                    height: 20,
                  ),
                  Text(
                    "3.⁠ ⁠User Content ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),SizedBox(height: 5,),
                  Text(
                    'Echo sync  does not upload or share your music files. All music files remain on your device, and you retain full ownership of the content. We do not claim any rights over the music files you play using Echo sync .',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                   SizedBox(
                    height: 20,
                  ),
                  Text(
                    "4. Privacy policy",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),SizedBox(height: 5,),
                  Text(
                    'Echo sync  respects your privacy. As an offline music player, the App does not collect, store, or share any personal information. For more details on our commitment to privacy, please review .',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                   SizedBox(
                    height: 20,
                  ),
                  Text(
                    "5. Contact Information ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    'If you have any questions or concerns about these terms, please contact us at 323nandhu@gmail.com',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
