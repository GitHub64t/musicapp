import 'package:flutter/material.dart';
import 'package:musicapp/music_app/about.dart';
import 'package:musicapp/music_app/all_songss.dart';
import 'package:musicapp/music_app/fav.dart';
import 'package:musicapp/music_app/mostly_played_screen.dart';
import 'package:musicapp/music_app/playlist_listscreen.dart';
import 'package:musicapp/music_app/recent.dart';
import 'package:musicapp/widgets/appgraient.dart';
import 'package:musicapp/widgets/miniplayer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient:AppGradients.thirdGradient
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBar(
              // centerTitle: true,
              automaticallyImplyLeading: false,
              title: const Text(
                "  HOME",
                style: TextStyle(
                    color: AppGradients.whiteColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w900),
              ),
              backgroundColor: Colors.transparent,
              actions: [
                
                IconButton(onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const  About()));
                }, icon:const Icon(Icons.settings,color: AppGradients.whiteColor,)),
                const SizedBox(width: 10,),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const All_Songs()),
                );
              },
              child: Container(
                height: 150,
                width: 370,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    gradient: AppGradients.secondaryGradient,
                        ),
                child: const Center(
                  child: ListTile(
                    title: Text(
                      "All Songs",
                      style: TextStyle(color:AppGradients.whiteColor, fontSize: 20),
                    ),
                    leading: Icon(
                      Icons.music_note,
                      size: 60,
                      color:AppGradients.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 18,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MostlyPlayedScreen()),
                    );
                  },
                  child: Container(
                    height: 180,
                    width: 180,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        gradient: AppGradients.secondaryGradient,
                            ),
                    child: const Column(
                      children: [
                        SizedBox(
                          width: 180,
                          height: 120,
                          child: Center(
                            child: Icon(
                              Icons.music_note,
                              size: 60,
                              color: AppGradients.whiteColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Mostly Played",
                          style: TextStyle(color:AppGradients.whiteColor, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Recent()));
                  },
                  child: Container(
                    height: 180,
                    width: 180,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        gradient: AppGradients.secondaryGradient,
                            ),
                    child: const Column(
                      children: [
                        SizedBox(
                          width: 180,
                          height: 120,
                          child: Center(
                            child: Icon(
                              Icons.music_note,
                              size: 60,
                              color: AppGradients.whiteColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Recently Played",
                          style: TextStyle(color: AppGradients.whiteColor, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 18,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Fav()),
                    );
                  },
                  child: Container(
                    height: 180,
                    width: 180,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        gradient: AppGradients.secondaryGradient,
                            ),
                    child: const Column(
                      children: [
                        SizedBox(
                          width: 180,
                          height: 120,
                          child: Center(
                            child: Icon(
                              Icons.music_note,
                              size: 60,
                              color: AppGradients.whiteColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Favorites",
                          style: TextStyle(color: AppGradients.whiteColor, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PlaylistListscreen()),
                    );
                  },
                  child: Container(
                    height: 180,
                    width: 180,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        gradient: AppGradients.secondaryGradient,),
                    child: const Column(
                      children: [
                        SizedBox(
                          width: 180,
                          height: 120,
                          child: Center(
                            child: Icon(
                              Icons.music_note,
                              size: 60,
                              color:AppGradients.whiteColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Playlists",
                          style: TextStyle(color: AppGradients.whiteColor, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
             const SizedBox(
                  height: 30,
                ),
            SizedBox(
                height: 80,
                width: 80,
                child: Image.asset(
                  "assets/images/logo.png",
                )),
                const SizedBox(
                  height: 30,
                ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: MiniPlayer(),
            ),
          ],
        ),
      ),
    );
  }
}
