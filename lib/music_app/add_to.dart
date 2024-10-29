import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';

class AddTo extends StatefulWidget {
  final AllSongs? song;

  const AddTo({super.key, this.song});

  @override
  State<AddTo> createState() => _AddToState();
}

class _AddToState extends State<AddTo> {
  List<String> playlists = [];
  Box<String>? playlistNamesBox;

  @override
  void initState() {
    super.initState();
    _openPlaylistNamesBox();
  }

  Future<void> _openPlaylistNamesBox() async {
    playlistNamesBox = await Hive.openBox<String>('playlistNames');
    setState(() {
      playlists = playlistNamesBox!.values.toList(); // Fetch playlist names
    });
  }

  void _addPlaylist() {
    String newPlaylistName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create new Playlist'),
          content: TextField(
            onChanged: (value) {
              newPlaylistName = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter playlist name',
              hintStyle: TextStyle(color: Color.fromARGB(221, 122, 122, 122)),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                if (newPlaylistName.isNotEmpty) {
                  await Hive.openBox<AllSongs>(newPlaylistName); // Open or create a box
                  playlistNamesBox?.add(newPlaylistName); // Add to playlist names box
                  setState(() {
                    playlists.add(newPlaylistName);
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addSongToPlaylist(String playlistName) async {
    if (widget.song != null) {
      final playlistBox = await Hive.openBox<AllSongs>(playlistName);
      await playlistBox.add(widget.song!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Song added to $playlistName')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No song to add')),
      );
    }
  }

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
          ),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              title: const Text(
                "Add to Playlist",
                style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addPlaylist,
              child: const Text("New Playlist"),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      playlists[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                    leading: const CircleAvatar(child: Icon(Icons.library_music)),
                    trailing: IconButton(
                      icon: const Icon(Icons.circle, color: Colors.white),
                      onPressed: () => _addSongToPlaylist(playlists[index]),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}







// import 'package:flutter/material.dart';

// class AddTo extends StatefulWidget {
  
//   const AddTo({super.key});

//   @override
//   State<AddTo> createState() => _AddToState();
// }

// class _AddToState extends State<AddTo> {
//   void _addPlaylist() {
//       String newPlaylistName = '';

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Create new Playlist'),
//           content: TextField(
//             onChanged: (value) {
//               // newPlaylistName = value;
//             },
//             decoration: const InputDecoration(
//                 hintText: 'Enter playlist name',
//                 hintStyle:
//                     TextStyle(color: Color.fromARGB(221, 122, 122, 122))),
//           ),
//           actions: [
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Add'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//             gradient: LinearGradient(
//           colors: [
//             Color(0xff663FB9),
//             Color(0xff43297A),
//             Color(0XFF19093B),
//             Colors.black,
//             Colors.black
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         )),
//         child: Column(
//           children: [
//             AppBar(
//               backgroundColor: Colors.transparent,
//               title: const Text(
//                 "Add to playlist",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 25,
//                     fontWeight: FontWeight.w600),
//               ),
//               leading: IconButton(
//                   onPressed: () {
//                     // Navigator.push(context, MaterialPageRoute(builder: (context)=> ))
//                     Navigator.pop(context);
//                   },
//                   icon: const Icon(
//                     Icons.arrow_back,
//                     color: Colors.white,
//                   )),
//             ),
//             const SizedBox(
//               height: 100,
//             ),
//             Center(
//               child: ElevatedButton(
//                   onPressed: () {
//                     _addPlaylist();
//                   },
//                   child: const Text("New Playlist")),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             Container(
//               height: 500,
//               child: Container(
//                 height: 500,
//                 child: ListView.builder(itemBuilder:itembuilder)
                  
                 
                  
                
//               ),
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text("Done")),
//           ],
//         ),
//       ),
//     );
//   }
// }
