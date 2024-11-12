import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicapp/music_app/home_screen.dart';
import 'package:musicapp/music_app/playlist.dart';
import 'package:musicapp/widgets/appgraient.dart';
import 'package:musicapp/widgets/edit.dart';

class PlaylistListscreen extends StatefulWidget {
  const PlaylistListscreen({super.key});

  @override
  State<PlaylistListscreen> createState() => _PlaylistListscreenState();
}

class _PlaylistListscreenState extends State<PlaylistListscreen> {
  List<String> playlists = [];
  late Box<String> playlistNamesBox;

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    playlistNamesBox = await Hive.openBox<String>('playlistNames');
    setState(() {
      playlists = playlistNamesBox.values.toList();
    });
  }

  Future<void> deletePlaylist(int index) async {
    final key = playlistNamesBox.keyAt(index);
    await playlistNamesBox.delete(key);

    // Reload playlists to reflect the changes
    _loadPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppGradients.primaryGradient,
            ),
            child: Column(
              children: [
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
                        color: AppGradients.whiteColor,
                      ),
                    ),
                    const Text(
                      "Playlists",
                      style: TextStyle(
                        fontSize: 25,
                        color: AppGradients.whiteColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    ),
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
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.asset(
                          "assets/images/🔋.jpeg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 25),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Playlists",
                            style: TextStyle(
                              color: AppGradients.whiteColor,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                              fontSize: 25,
                            ),
                          ),
                          Text(
       "${playlists.length} ${playlists.length == 1 ? "playlist is" : "playlists are"} available",

                            style: const TextStyle(
                              color: AppGradients.whiteColor,
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: playlists.isEmpty
                ? const Center(
                    child: Text(
                      'No playlist available',
                      style: TextStyle(color: AppGradients.whiteColor),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      final playlistName = playlists[index];

                      return ListTile(
                          leading:const CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/_ (1).jpeg"),
                           
                          ),
                          title: Text(
                            playlistName,
                            style:
                                const TextStyle(color: AppGradients.whiteColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Playlist(playlistName: playlistName),
                              ),
                            );
                          },
                          subtitle: const Text(
                            "Playlist",
                            style: TextStyle(color: Colors.white60),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  PlaylistEditor.showEditDialog(
                                    context: context,
                                    currentPlaylistName: playlistName,
                                    onPlaylistRenamed: (newName) {
                                      setState(() {
                                        playlists[index] = newName;
                                      });
                                      _loadPlaylists();
                                    },
                                  );
                                },
                                icon: Icon(Icons.edit),
                                color: AppGradients.whiteColor,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: AppGradients.whiteColor),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Delete Playlist"),
                                        content: const Text(
                                            "Are you sure you want to delete this playlist?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deletePlaylist(index);
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Delete"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          )
                          //  IconButton(
                          //     icon: const Icon(Icons.delete, color: AppGradients.whiteColor),
                          //     onPressed: () {
                          //       showDialog(
                          //         context: context,
                          //         builder: (BuildContext context) {
                          //           return AlertDialog(
                          //             title: const Text("Delete Playlist"),
                          //             content: const Text("Are you sure you want to delete this playlist?"),
                          //             actions: [
                          //               TextButton(
                          //                 onPressed: () => Navigator.pop(context),
                          //                 child: const Text("Cancel"),
                          //               ),
                          //               TextButton(
                          //                 onPressed: () {
                          //                   deletePlaylist(index);
                          //                   Navigator.pop(context);
                          //                 },
                          //                 child: const Text("Delete"),
                          //               ),
                          //             ],
                          //           );
                          //         },
                          //       );
                          //     },
                          //   ),
                          );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:musicapp/music_app/home_screen.dart';

// import 'package:musicapp/music_app/playlist.dart';

// class PlaylistListscreen extends StatefulWidget {
//   const PlaylistListscreen({super.key});

//   @override
//   State<PlaylistListscreen> createState() => _PlaylistListscreenState();
// }

// class _PlaylistListscreenState extends State<PlaylistListscreen> {
//   List<String> playlists = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadPlaylists();
//   }

//   Future<void> _loadPlaylists() async {
//     final playlistNamesBox = await Hive.openBox<String>('playlistNames');
//     setState(() {
//       playlists = playlistNamesBox.values.toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Column(children: [
//         Container(
//           decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                   colors: [
//                    Color(0xff704BBE),
//                 Color(0xff43297A),
//                 Color.fromARGB(255, 27, 10, 62),
               
//                 Colors.black,
//                     ],
//                   end: Alignment.bottomCenter,
//                   begin: Alignment.topCenter)),
//           child: Column(children: [
//             const SizedBox(height: 60),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const HomeScreen(),
//                         ),
//                       );
//                     },
//                     icon: const Icon(
//                       Icons.arrow_back,
//                       color: Colors.white,
//                     )),
//                 const Text("Playlists",
//                     style: TextStyle(
//                         fontSize: 25,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         decoration: TextDecoration.none)),
//                 const SizedBox(width: 50),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Container(
//               decoration: const BoxDecoration(color: Colors.transparent),
//               height: 120,
//               width: 370,
//               child: Row(
                
//                 children: [
//                   Container(
//                     height: 100,
//                     width: 100,
//                     decoration: const BoxDecoration(
//                         gradient: LinearGradient(
//                             colors: [
//                           Color.fromARGB(255, 91, 55, 168),
//                           Color(0xff351F64),
//                           Color(0xff1E0D43)
//                         ],
//                             end: Alignment.bottomCenter,
//                             begin: Alignment.topCenter)),
//                     child: const Center(
//                       child: Icon(
//                         Icons.skip_previous_outlined,
//                         color: Colors.white,
//                         size: 40,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 25),
//                   const Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Playlists",
//                         style: TextStyle(
//                             color: Colors.white,
//                             decoration: TextDecoration.none,
//                             fontWeight: FontWeight.normal,
//                             fontSize: 25),
//                       ),
//                       Text("mm",
//                           style: TextStyle(
//                               color: Colors.white,
//                               decoration: TextDecoration.none,
//                               fontSize: 20,
//                               fontWeight: FontWeight.w200))
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//           ]),
//         ),
//         Expanded(
//           child: playlists.isEmpty
//               ? const Center(child: Text('No playlist available'))
//               : ListView.builder(
//                   itemCount: playlists.length,
//                   itemBuilder: (context, index) {
//                     final song = playlists[index];

//                     return ListTile(
//                       title: Text(
//                         song,
//                         style: const TextStyle(color: Colors.white),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     Playlist(playlistName: playlists[index])));
//                       },
//                       subtitle: const Text(
//                         "Playlist",
//                         // song.tittle ,
//                         style:  TextStyle(color: Colors.white60),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       trailing: IconButton(
//   icon: Icon(Icons.delete),
//   onPressed: () {
//     // Show confirmation dialog before deletion
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Delete Playlist"),
//           content: Text("Are you sure you want to delete this playlist?"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context), // Cancel
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 deletePlaylist(playlists[index]); // Call the delete function
//                 Navigator.pop(context); // Close dialog
//                 setState(() {}); // Refresh the playlists screen
//               },
//               child: Text("Delete"),
//             ),
//           ],
//         );
//       },
//     );
//   },
// )

//                     );
//                   },
//                 ),
//         )
//       ]),
//     );
//   }
//   void deletePlaylist(String playlistName) async {
//   var box = await Hive.openBox('playlistsBox');
  
//   // Remove the playlist by its key, which can be its name or a unique ID
//   await box.delete(playlistName);

//   // Close the box after deletion if you no longer need it open
//   box.close();
// }

// }
