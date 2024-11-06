

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';
import 'package:musicapp/music_app/play.dart';
import 'package:musicapp/services/audioplayersingleton.dart';
import 'package:musicapp/widgets/addplaylist_widget.dart';
import 'package:musicapp/widgets/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';

class All_Songs extends StatefulWidget {
  const All_Songs({super.key});

  @override
  State<All_Songs> createState() => _AllSongsState();
}

class _AllSongsState extends State<All_Songs> {
  // Initialize the AudioPlayer
  final AudioPlayer _audioPlayer = AudioPlayer();

  final _audioQuery = OnAudioQuery();
  Box<AllSongs>? songBox;
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  final List<AllSongs> _allSongs = []; // All songs fetched from Hive
  List<AllSongs> _filteredSongs = []; // Filtered songs based on search query

  @override
  void initState() {
    super.initState();
    requestPermissions();
    _searchController.addListener(() {
      _filterSongs(_searchController.text);
    });
  
  }

  @override
  void dispose() {
    // Dispose the AudioPlayer when it's no longer needed
    _audioPlayer.dispose();
    _searchController.dispose();
    super.dispose();

  }

  Future<void> fetchAndStoreSongs() async {
    try {
      // Open the Hive box
      await Hive.deleteBoxFromDisk('all_audio_data');
      songBox = await Hive.openBox<AllSongs>('all_audio_data');
      List<SongModel> songs = await _audioQuery.querySongs();
      List<AllSongs> hiveSongs = songs.map((song) {
        return AllSongs(
          id: song.id,
          tittle: song.displayNameWOExt,
          artist: song.artist.toString(),
          uri: song.uri.toString(),
        );
      }).toList();

      await songBox!.clear();
      await songBox!.addAll(hiveSongs);

      setState(() {
        _allSongs.addAll(hiveSongs); // Update the _allSongs list
        _filteredSongs = List.from(_allSongs); // Show all songs initially
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching or storing songs: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> requestPermissions() async {
    final hasPermission = await _audioQuery.checkAndRequest();
    if (hasPermission) {
      await fetchAndStoreSongs(); // Fetch songs after permission is granted
    } else {
      print("Permission not granted.");
      setState(() {
        _isLoading = false; // Stop loading if permission is not granted
      });
    }
  }

  void _filterSongs(String query) {
    List<AllSongs> results = [];
    if (query.isEmpty) {
      results = List.from(_allSongs); // Reset to all songs
    } else {
      results = _allSongs.where((song) {
        return song.tittle.toLowerCase().contains(query.toLowerCase()) ||
            song.artist.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    setState(() {
      _filteredSongs = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If still loading, show a loading indicator
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Ensure songBox is initialized before accessing it
    if (songBox == null) {
      return const Center(child: Text("Error: songBox is not initialized."));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff6A42BF), Color(0xff271748), Colors.black],
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Flexible(
                        child: Text(
                          "All Songs",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 50),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
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
                              Color(0xff1E0D43),
                            ],
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.music_note,
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
                            "All Songs",
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            "Playlist",
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color.fromARGB(255, 0, 0, 0),
              border: Border.all(
                color: const Color.fromARGB(255, 92, 92, 92),
              ),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.grey),
              decoration: const InputDecoration(
                hintText: '  Search music...',
                hintStyle: TextStyle(color: Color.fromARGB(255, 164, 164, 164)),
                border: InputBorder.none,
                suffixIcon: Icon(Icons.search, color: Colors.grey),
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
              ),
              cursorColor: Colors.white,
            ),
          ),
          Expanded(
            

            child: _filteredSongs.isEmpty && _searchController.text.isNotEmpty
                ? const Center(
                    child: Text(
                      "No Songs Found",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : ListView.builder(
                  
                    itemCount: _filteredSongs.length,
                    itemBuilder: (context, index) {
                       var song = _filteredSongs[index];
                    

                      return ListTile(
                        title: Text(
                          song.tittle,
                          style: const TextStyle(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          List<MediaItem> playlist = _filteredSongs.map((s) {
                            return MediaItem(
                              id:  s.uri,
                              title: s.tittle,
                              artist: s.artist,
                              album: s.id.toString()
                            );
                          }).toList();

                          AudioPlayerSingleton().setPlaylist(playlist,index);//chsnged
                          AudioPlayerSingleton().playSong(MediaItem(
                              id: song.uri,
                              title: song.tittle,
                              artist: song.artist,
                              album: song.id.toString(),
                              ));

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Play(
                                songs: playlist,
                                initialIndex: _filteredSongs.indexOf(song),
                            
                              ),
                            ),
                          );
                         
                        },
                        subtitle: Text(
                          song.artist,
                          style: const TextStyle(color: Colors.white60),
                        ),
                        leading: QueryArtworkWidget(
                          id: song.id,
                          type: ArtworkType.AUDIO,
                          artworkHeight: 40,
                          artworkWidth: 40,
                          artworkFit: BoxFit.cover,
                          nullArtworkWidget: const CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 46, 19, 86),
                            child: Icon(
                              Icons.music_note,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        trailing: IconButton(
                            icon: const Icon(Icons.more_vert,
                                color: Colors.white),
                            onPressed: () {
                             AddplaylistWidget.showOptionsBottomSheet(
                              song: song,
                              context: context,
                              songName: song.tittle, 
                              singerName: song.artist);
                            }),
                      );
                    },
                  ),
                  
          ),
          const Align(
          alignment: Alignment.bottomCenter,
          child: MiniPlayer(),
        ),
        ],
      ),
    );
  }
}











// import 'package:audio_service/audio_service.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:musicapp/music_app/add_to.dart';
// import 'package:musicapp/music_app/hive1/all_songs.dart';
// import 'package:musicapp/music_app/play.dart';
// import 'package:musicapp/services/audioplayersingleton.dart';
// import 'package:musicapp/services/fetch_songs.dart';
// import 'package:musicapp/widgets/audioplayer.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// class All_Songs extends StatefulWidget {
//   const All_Songs({super.key});

//   @override
//   State<All_Songs> createState() => _AllSongsState();
// }

// class _AllSongsState extends State<All_Songs> {
//   // Initialize the AudioPlayer
//   final AudioPlayer _audioPlayer = AudioPlayer();

//   final _audioQuery = OnAudioQuery();
//   Box<AllSongs>? songBox;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     requestPermissions();
//   }

//   @override
//   void dispose() {
//     // Dispose the AudioPlayer when it's no longer needed
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   Future<void> fetchAndStoreSongs() async {
//     try {
//       // Open the Hive box
//       await Hive.deleteBoxFromDisk('all_audio_data');
//       songBox = await Hive.openBox<AllSongs>('all_audio_data');
//       List<SongModel> songs = await _audioQuery.querySongs();
//       List<AllSongs> hiveSongs = songs.map((song) {
//         return AllSongs(
//           id: song.id,
//           tittle: song.displayNameWOExt,
//           artist: song.artist.toString(),
//           uri: song.uri.toString(),
//         );
//       }).toList();

//       await songBox!.clear();
//       await songBox!.addAll(hiveSongs);

//       setState(() {
//         _isLoading = false;
//       });
//     } catch (e) {
//       print("Error fetching or storing songs: $e");
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> requestPermissions() async {
//     final hasPermission = await _audioQuery.checkAndRequest();
//     if (hasPermission) {
//       await fetchAndStoreSongs(); // Fetch songs after permission is granted
//     } else {
//       print("Permission not granted.");
//       setState(() {
//         _isLoading = false; // Stop loading if permission is not granted
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // If still loading, show a loading indicator
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     // Ensure songBox is initialized before accessing it
//     if (songBox == null) {
//       return const Center(child: Text("Error: songBox is not initialized."));
//     }

//     List<AllSongs> storedSongs =
//         songBox!.values.toList(); // Use songBox directly

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Column(
//         children: [
//           // Your existing UI code for the header goes here...

//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xff6A42BF), Color(0xff271748), Colors.black],
//                 end: Alignment.bottomCenter,
//                 begin: Alignment.topCenter,
//               ),
//             ),
//             child: Column(
//               children: [
//                 const SizedBox(height: 60),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: const Icon(Icons.arrow_back, color: Colors.white),
//                       ),
//                       const Flexible(
//                         child: Text(
//                           "All Songs",
//                           style: TextStyle(
//                             fontSize: 25,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             decoration: TextDecoration.none,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       const SizedBox(width: 50),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 50),
//                 // Display for "All Songs"
//                 Container(
//                   height: 120,
//                   width: 370,
//                   child: Row(
//                     children: [
//                       Container(
//                         height: 100,
//                         width: 100,
//                         decoration: const BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Color.fromARGB(255, 91, 55, 168),
//                               Color(0xff351F64),
//                               Color(0xff1E0D43),
//                             ],
//                             end: Alignment.bottomCenter,
//                             begin: Alignment.topCenter,
//                           ),
//                         ),
//                         child: const Center(
//                           child: Icon(
//                             Icons.music_note,
//                             color: Colors.white,
//                             size: 40,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 25),
//                       const Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "All Songs",
//                             style: TextStyle(
//                               color: Colors.white,
//                               decoration: TextDecoration.none,
//                               fontWeight: FontWeight.normal,
//                               fontSize: 25,
//                             ),
//                           ),
//                           Text(
//                             "Playlist",
//                             style: TextStyle(
//                               color: Colors.white,
//                               decoration: TextDecoration.none,
//                               fontSize: 20,
//                               fontWeight: FontWeight.w200,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),

//           Container(
//             height: 50,
//             padding: const EdgeInsets.all(8.0),
//             margin: const EdgeInsets.symmetric(horizontal: 16.0),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(30),
//               color: const Color.fromARGB(255, 0, 0, 0),
//               border: Border.all(
//                 color: const Color.fromARGB(255, 92, 92, 92),
//               ),
//             ),
//             child: const TextField(
//               // controller: _searchController,
//               // onChanged: _filterSongs,
//               style: TextStyle(color: Colors.grey),
//               decoration: InputDecoration(
//                 hintText: '  Search music...',
//                 hintStyle: TextStyle(color: Color.fromARGB(255, 164, 164, 164)),
//                 border: InputBorder.none,
//                 suffixIcon: Icon(Icons.search, color: Colors.grey),
//                 labelStyle: TextStyle(color: Colors.white),
//                 fillColor: Colors.white,
//               ),
//               cursorColor: Colors.white,
//             ),
//           ),
//           Expanded(
//             child: storedSongs.isEmpty
//                 ? const Center(
//                     child: Text(
//                       "No Songs Found",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   )
//                 : ListView.builder(
//                     itemCount: storedSongs.length,
//                     itemBuilder: (context, index) {
//                       var song = storedSongs[index];
//                       return ListTile(
//                         title: Text(
//                           song.tittle,
//                           style: const TextStyle(color: Colors.white),
//                            maxLines: 1,  // Limit to 1 line
//     overflow: TextOverflow.ellipsis, 
//                         ),
//                         onTap: () {
//                           // Assuming 'song' contains the file path or URI
//                           String songUri = song.uri;

//                           // Prepare the playlist for the player
//                           List<MediaItem> playlist = storedSongs.map((s) {
//                             return MediaItem(
//                               id: s.uri,
//                               title: s.tittle,
//                               artist: s.artist ?? "Unknown",
//                               // Optionally add artworkUri if available
//                               // artworkUri: s.artworkUri,
//                             );
//                           }).toList();

//                           // Set the playlist in the singleton
//                           AudioPlayerSingleton().setPlaylist(playlist);

//                           // Navigate to the Play screen
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => Play(
//                                 songs: playlist,
//                                 initialIndex: storedSongs.indexOf(
//                                     song), // Start with the tapped song
//                               ),
//                             ),
//                           );
//                         },

//                         subtitle: Text(
//                           getSecondName(song.artist),
//                           style: const TextStyle(color: Colors.white60),
//                         ),
//                         // leading:
//                         //     const Icon(Icons.music_note, color: Colors.white),
//                         // Display album art as leading widget
//                         leading: QueryArtworkWidget(
//                           id: song.id, // Use the song ID to fetch album art
//                           type: ArtworkType.AUDIO,
//                           artworkHeight: 40, // Set dimensions
//                           artworkWidth: 40,
//                           artworkFit: BoxFit.cover,
//                           nullArtworkWidget: CircleAvatar(
//                               backgroundColor:
//                                   const Color.fromARGB(205, 67, 9, 144),
//                               child: const Icon(Icons.music_note,
//                                   color:
//                                       Colors.white)), // Fallback if no artwork
//                         ),
//                         trailing: IconButton(
//                             icon: const Icon(Icons.more_vert,
//                                 color: Colors.white),
//                             onPressed: () {
//                               _showOptionsBottomSheet(context);
//                             }),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   String getSecondName(String artist) {
//     final cleanedName = artist.replaceAll(RegExp(r'[^a-zA-Z\s]'), '');
//     final names = cleanedName.split(' ');

//     return names.length > 1 ? names[1] : "Unknown Artist";
//   }

//   void _showOptionsBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       backgroundColor: const Color.fromARGB(255, 33, 32, 32),
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const ListTile(
//                 title: Text(
//                   'song name',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 leading: Icon(
//                   Icons.music_note,
//                   color: Colors.white,
//                 ),
//                 subtitle: Text(
//                   "singername",
//                   style: TextStyle(
//                     color: Colors.white70,
//                   ),
//                 ),
//               ),
//               const Divider(
//                 thickness: 0.4,
//               ),
//               ListTile(
//                 leading: const Icon(
//                   Icons.remove_circle_outline,
//                   color: Colors.white,
//                 ),
//                 title: const Text(
//                   'Remove from this playlist',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   // Handle Option 2 action
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text(
//                       'Remove from this playlist',
//                       style: TextStyle(color: Colors.white),
//                     )),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(
//                   Icons.add_rounded,
//                   color: Colors.white,
//                 ),
//                 title: const Text(
//                   'add to playlist',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onTap: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => const AddTo()));
//                   // Handle Option 3 action
//                   // ScaffoldMessenger.of(context).showSnackBar(
//                   //   SnackBar(content: Text('')),
//                   // );
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
