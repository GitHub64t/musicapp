import 'package:flutter/material.dart';
import 'package:musicapp/music_app/all_songss.dart';
import 'package:musicapp/music_app/fav.dart';
import 'package:musicapp/music_app/mostly_played_screen.dart';
import 'package:musicapp/music_app/playlist_listscreen.dart';
import 'package:musicapp/music_app/recent.dart';
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
            gradient: LinearGradient(colors: [
          Color(0xff704BBE),
          Color(0xff43297A),
          Color(0xff19093B),
          Colors.black
        ], begin: Alignment.topLeft)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBar(
              // centerTitle: true,
              automaticallyImplyLeading: false,
              title: const Text(
                "  HOME",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900),
              ),
              backgroundColor: Colors.transparent,
              actions: [
                
                IconButton(onPressed: (){}, icon:const Icon(Icons.settings,color: Colors.white,)),
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
                    gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 91, 55, 168),
                          Color(0xff351F64),
                          Color(0xff1E0D43)
                        ],
                        end: Alignment.bottomCenter,
                        begin: Alignment.topCenter)),
                child: const Center(
                  child: ListTile(
                    title: Text(
                      "All Songs",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    leading: Icon(
                      Icons.music_note,
                      size: 60,
                      color: Colors.white,
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
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 91, 55, 168),
                              Color(0xff351F64),
                              Color(0xff1E0D43)
                            ],
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter)),
                    child: const Column(
                      children: [
                        SizedBox(
                          width: 180,
                          height: 120,
                          child: Center(
                            child: Icon(
                              Icons.music_note,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Mostly Played",
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 91, 55, 168),
                              Color(0xff351F64),
                              Color(0xff1E0D43)
                            ],
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter)),
                    child: const Column(
                      children: [
                        SizedBox(
                          width: 180,
                          height: 120,
                          child: Center(
                            child: Icon(
                              Icons.music_note,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Recently Played",
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 91, 55, 168),
                              Color(0xff351F64),
                              Color(0xff1E0D43)
                            ],
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter)),
                    child: const Column(
                      children: [
                        SizedBox(
                          width: 180,
                          height: 120,
                          child: Center(
                            child: Icon(
                              Icons.music_note,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Favorites",
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 91, 55, 168),
                              Color(0xff351F64),
                              Color(0xff1E0D43)
                            ],
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter)),
                    child: const Column(
                      children: [
                        SizedBox(
                          width: 180,
                          height: 120,
                          child: Center(
                            child: Icon(
                              Icons.music_note,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Playlists",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
                height: 150,
                width: 150,
                child: Image.asset(
                  "assets/images/Black_and_White_Flat_Illustrative_Music_Studio_Logo-removebg-preview.png",
                )),
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
