import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicapp/music_app/add_to.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';
import 'package:musicapp/music_app/play.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Recent extends StatefulWidget {
  const Recent({super.key});

  @override
  State<Recent> createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  Box<AllSongs>? recentlyPlayedBox;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff6A42BF), Color(0xff271748), Colors.black],
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter)),
          child: Column(children: [
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                const Text("Recents",
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
                        "Recently Played",
                        style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                            fontSize: 25),
                      ),
                      Text("Playlist",
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
            const SizedBox(height: 30),
          ]),
        ),
        Expanded(
          child:// recentlyPlayedBox == null
          FutureBuilder<Box<AllSongs>>(
        future: Hive.openBox<AllSongs>('recentlyPlayed'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final box = snapshot.data!;
            final songs = box.values.toList().reversed.toList();

            return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                        title: Text(
                          song.tittle,
                          style: const TextStyle(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      onTap: () {
                            // Create a list of MediaItems from favorites
                            List<MediaItem> recentlyplayed = recentlyPlayedBox!.values.map((recent) {
                              return MediaItem(
                                id: recent.uri,
                                title: recent.tittle,
                                artist: recent.artist,
                                album: recent.id.toString(),
                              );
                            }).toList();

                            // Navigate to the Play screen and pass the favorite songs list and the selected index
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Play(
                                  songs: recentlyplayed,
                                  initialIndex: index,
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
                            //  AddplaylistWidget.showOptionsBottomSheet(
                            //   song: song,
                            //   context: context,
                            //   songName: song.tittle, 
                            //   singerName: song.artist);
                            }
                            ),
                      );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
          ),
        )
      ]
      ));
      
      //         ? const Center(child: CircularProgressIndicator())
      //         : ListView.builder(
      //             itemCount: recentlyPlayedBox!.length,
                  
      //             reverse: true,  // Show most recent at the top
      //             itemBuilder: (context, index) {
      //               AllSongs song = recentlyPlayedBox!.getAt(index)!;
      //               return ListTile(
      //                 onTap: () {
      //                   // Navigate to Play screen with the selected song
      //                 },
      //                 title: Text(
      //                   song.tittle,
      //                   style: const TextStyle(color: Colors.white),
      //                 ),
      //                 subtitle: Text(
      //                   song.artist ?? "Unknown Artist",
      //                   style: const TextStyle(color: Colors.white),
      //                 ),
      //                 leading: const Icon(
      //                   Icons.music_note,
      //                   color: Colors.white,
      //                 ),
      //                 trailing: IconButton(
      //                   icon: const Icon(
      //                     Icons.more_vert,
      //                     color: Colors.white,
      //                   ),
      //                   onPressed: () => _showOptionsBottomSheet(context, song),
      //                 ),
      //               );
      //             },
      //           ),
      //   )
      // ]),
    
  }

  void _showOptionsBottomSheet(BuildContext context, AllSongs song) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 33, 32, 32),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  song.tittle,
                  style: const TextStyle(color: Colors.white),
                ),
                leading: const Icon(Icons.music_note, color: Colors.white),
                subtitle: Text(
                  song.artist ?? "Unknown Artist",
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              const Divider(thickness: 0.4),
              ListTile(
                leading: const Icon(Icons.remove_circle_outline, color: Colors.white),
                title: const Text('Remove from this playlist', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  await recentlyPlayedBox!.delete(song.id);
                  Navigator.of(context).pop();
                  setState(() {});  // Refresh the list after removal
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Removed from playlist',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_rounded, color: Colors.white),
                title: const Text('Add to playlist', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTo()));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:musicapp/music_app/add_to.dart';


// class Recent extends StatefulWidget {
//   const Recent({super.key});

//   @override
//   State<Recent> createState() => _RecentState();
// }

// class _RecentState extends State<Recent> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Column(children: [
//         Container(
//           decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                   colors: [Color(0xff6A42BF), Color(0xff271748), Colors.black],
//                   end: Alignment.bottomCenter,
//                   begin: Alignment.topCenter)),
//           child: Column(children: [
//             const SizedBox(
//               height: 60,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: const Icon(
//                       Icons.arrow_back,
//                       color: Colors.white,
//                     )),
//                 const Text("Recents",
//                     style: TextStyle(
//                         fontSize: 25,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         decoration: TextDecoration.none)),
//                 const SizedBox(
//                   width: 50,
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 20,
//             ),
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
//                   const SizedBox(
//                     width: 25,
//                   ),
//                   const Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Recently Played",
//                         style: TextStyle(
//                             color: Colors.white,
//                             decoration: TextDecoration.none,
//                             fontWeight: FontWeight.normal,
//                             fontSize: 25),
//                       ),
//                       Text("Playlist",
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
//             const SizedBox(
//               height: 30,
//             ),
//           ]),
//         ),
//         Expanded(
//             child: ListView.builder(
//                   itemCount: 10,
//                   itemBuilder: (context, index) {
//         return ListTile(
//           onTap: () {
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(builder: (context) => const Play()),
//             // );
//           },
//           title: const Text(
//             "song name",
//             style: TextStyle(color: Colors.white),
//           ),
//           subtitle: const Text("Unknown Artist",
//               style: TextStyle(color: Colors.white)),
//           leading: const Icon(
//             Icons.music_note,
//             color: Colors.white,
//           ),
//           trailing: IconButton(
//             icon: const Icon(
//               Icons.more_vert,
//               color: Colors.white,
//             ),
//              onPressed: () => _showOptionsBottomSheet(context),
//           ),
//         );
//                   },
//                 ))
//       ]),
//     );
//   }
//    void _showOptionsBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       backgroundColor: const Color.fromARGB(255, 33, 32, 32),
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding:const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//             const  ListTile(
//                 title: Text('song name',style: TextStyle(color: Colors.white),),
//                 leading: Icon(Icons.music_note,color: Colors.white,),
//                 subtitle: Text("singername",style: TextStyle(color:Colors.white70,),),
              
               
//               ),
//             const  Divider( thickness: 0.4,
              
//               ),
//               ListTile(
//                 leading:const Icon(Icons.remove_circle_outline,color: Colors.white,),
//                 title:const Text('Remove from this playlist',style: TextStyle(color: Colors.white),),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   // Handle Option 2 action
//                   ScaffoldMessenger.of(context).showSnackBar(
//                    const SnackBar(content: Text('Remove from this playlist',style: TextStyle(color: Colors.white),)),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading:const Icon(Icons.add_rounded,color: Colors.white,),
//                 title:const Text('add to playlist',style: TextStyle(color: Colors.white),),
//                 onTap: () {
//                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddTo()));
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
