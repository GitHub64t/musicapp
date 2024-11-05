import 'package:flutter/material.dart';
import 'package:musicapp/music_app/home_screen.dart';
import 'package:musicapp/widgets/categorycard.dart';
import 'package:hive/hive.dart';

class CreatingPlaylist extends StatefulWidget {
  const CreatingPlaylist({super.key});

  @override
  State<CreatingPlaylist> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<CreatingPlaylist> {
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
      body: Stack(
        children: [
          // Full screen gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xff704BBE),
                Color(0xff43297A),
                Color.fromARGB(255, 27, 10, 62),
                Color(0xff19093B),
                Colors.black,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
          // Content
          Column(
            children: [
              AppBar(
                title: const Text(
                  "Playlists",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0, // Removes shadow under AppBar
                leading: IconButton(
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
              ),
              Expanded(
                child: playlists.isEmpty
                    ? const Center(
                        child: Text(
                          "No Playlists Added",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(12),
                        child: GridView.builder(
                          itemCount: playlists.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          itemBuilder: (context, index) {
                            return CategoryCard(
                              imageUrl: 'assets/images/playlist_img.jpg',
                              title: playlists[index],
                              subtitle: "Playlist",
                              playlist: playlists[index],
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  void delete() {

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('you want to delete this playlist'),
        content: TextField(
          onChanged: (value) {
          
          },
         
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: (){}
          ),
        ],
      );
    },
  );
}
}
