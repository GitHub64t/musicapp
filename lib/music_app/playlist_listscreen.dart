import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicapp/music_app/home_screen.dart';

import 'package:musicapp/music_app/playlist.dart';

class PlaylistListscreen extends StatefulWidget {
  const PlaylistListscreen({super.key});

  @override
  State<PlaylistListscreen> createState() => _PlaylistListscreenState();
}

class _PlaylistListscreenState extends State<PlaylistListscreen> {
  List<String> playlists = [];

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    final playlistNamesBox = await Hive.openBox<String>('playlistNames');
    setState(() {
      playlists = playlistNamesBox.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                   Color(0xff704BBE),
                Color(0xff43297A),
                Color.fromARGB(255, 27, 10, 62),
               
                Colors.black,
                    ],
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter)),
          child: Column(children: [
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                const Text("Playlists",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none)),
                const SizedBox(width: 50),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: const BoxDecoration(color: Colors.transparent),
              height: 120,
              width: 370,
              child: Row(
                
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          Color.fromARGB(255, 91, 55, 168),
                          Color(0xff351F64),
                          Color(0xff1E0D43)
                        ],
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter)),
                    child: const Center(
                      child: Icon(
                        Icons.skip_previous_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 25),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Playlists",
                        style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                            fontSize: 25),
                      ),
                      Text("mm",
                          style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: 20,
                              fontWeight: FontWeight.w200))
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ]),
        ),
        Expanded(
          child: playlists.isEmpty
              ? const Center(child: Text('No playlist available'))
              : ListView.builder(
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    final song = playlists[index];

                    return ListTile(
                      title: Text(
                        song,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Playlist(playlistName: playlists[index])));
                      },
                      subtitle: const Text(
                        "Playlist",
                        // song.tittle ,
                        style:  TextStyle(color: Colors.white60),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                          icon:
                              const Icon(Icons.more_vert, color: Colors.white),
                          onPressed: () {}),
                    );
                  },
                ),
        )
      ]),
    );
  }
}