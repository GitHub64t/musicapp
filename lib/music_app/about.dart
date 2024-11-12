import 'package:flutter/material.dart';
import 'package:musicapp/music_app/privacy_policy.dart';
import 'package:musicapp/music_app/terms_conditions.dart';
import 'package:musicapp/music_app/version.dart';
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
                    ListTile(
              title:const Text( "Version",style: TextStyle(
                color: AppGradients.whiteColor
              ),),
              trailing:const Icon(Icons.arrow_forward,color:AppGradients.whiteColor,),
              onTap: () {
                Navigator.push(context, 
                MaterialPageRoute(builder: (context)=>const Version()));
              },
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

  // Widget _buildSection(String title, String content) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         title,
  //         style: const TextStyle(
  //             color:AppGradients.whiteColor,
  //             fontSize: 20,
  //             fontWeight: FontWeight.w700),
  //       ),
  //       const SizedBox(height: 5),
  //       Text(
  //         content,
  //         style: const TextStyle(
  //             color: AppGradients.whiteColor,
  //             fontSize: 15,
  //             fontWeight: FontWeight.w400),
  //       ),
  //       const SizedBox(height: 20),
  //     ],
  //   );
  // }
}