import 'package:flutter/material.dart';
import 'package:musicapp/music_app/privacy_policy.dart';
import 'package:musicapp/music_app/terms_conditions.dart';
import 'package:musicapp/widgets/appgraient.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.thirdGradient
        ),
        child: 
        Column(
          children: [
            AppBar(
                backgroundColor: Colors.transparent,
                title: const Text(
                  "About",
                  style: TextStyle(color:AppGradients.whiteColor , fontSize: 25, fontWeight: FontWeight.w600),
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
              const SizedBox(
                height: 25,
              ),
               SizedBox(
                height: 170,
                width: 170,
                child: Image.asset(
                  "assets/images/logo.png",
                )),
                const SizedBox(
                height: 25,
              ),
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
                     const SizedBox(height: 10,),
                           const Divider(
                          endIndent: 25,
                          indent: 25,
                          thickness: 0.5,
                          height: 40,
                           ),
            ListTile(
              title:const Text( "Terms and Conditions",style: TextStyle(
                color: AppGradients.whiteColor
              ),),
              trailing:const Icon(Icons.arrow_forward,color: AppGradients.whiteColor,),
              onTap: () {
                Navigator.push(context, 
                MaterialPageRoute(builder: (context)=> const TermsConditions()));
              },
            ),
             ListTile(
              title:const Text( "Privacy Policy",style: TextStyle(
                color:AppGradients.whiteColor
              ),),
              trailing:const Icon(Icons.arrow_forward,color: AppGradients.whiteColor,),
              onTap: () {
                Navigator.push(context, 
                MaterialPageRoute(builder: (context)=> const PrivacyPolicy()));
              },
            ),
            
          
          ],
        )
      ),
    );
  }
}