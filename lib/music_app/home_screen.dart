import 'package:flutter/material.dart';
import 'package:musicapp/music_app/about.dart';
import 'package:musicapp/music_app/all_songss.dart';
import 'package:musicapp/music_app/fav.dart';
import 'package:musicapp/music_app/hive1/creating_playlist.dart';
import 'package:musicapp/music_app/recent.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _pages = [
    HomeScreen(),
  
    About(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _pages[index]),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color(0xff704BBE),
      //   title:Text("Home") ,
      // ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabTapped,
        // backgroundColor:Colors.black ,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
         
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
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
            ),
            const SizedBox(
              height: 30,
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
                          builder: (context) => const All_Songs()),
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
                    child: Column(
                      children: [
                        Container(
                          width: 180,
                          height: 120,
                          child: const Center(
                            child: Icon(
                              Icons.music_note,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "All Songs",
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
                          builder: (context) => Recent())
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
                    child: Column(
                      children: [
                        Container(
                          width: 180,
                          height: 120,
                          child: const Center(
                            child: Icon(
                              Icons.music_note,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
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
                    child: Column(
                      children: [
                        Container(
                          width: 180,
                          height: 120,
                          child: const Center(
                            child: Icon(
                              Icons.music_note,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
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
                          builder: (context) => CreatingPlaylist()),
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
                    child: Column(
                      children: [
                        Container(
                          width: 180,
                          height: 120,
                          child: const Center(
                            child: Icon(
                              Icons.music_note,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Playlists",
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
                height: 250,
                width: 250,
                child: Center(
                  child: Center(
                    child: Image.asset(
                        "assets/images/Black_and_White_Flat_Illustrative_Music_Studio_Logo-removebg-preview.png"),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
