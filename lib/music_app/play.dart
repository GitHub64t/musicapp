import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicapp/music_app/add_to.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';
import 'package:musicapp/services/audioplayersingleton.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Play extends StatefulWidget {
  List<MediaItem> songs;
  int initialIndex;

  Play({super.key, required this.songs, required this.initialIndex});

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  final AudioPlayerSingleton _audioPlayerSingleton = AudioPlayerSingleton();
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool isPlaying = false;
  Box<AllSongs>? _favoritesBox;

  @override
  void initState() {
    super.initState();

    _audioPlayerSingleton.setPlaylist(widget.songs, widget.initialIndex);
    _audioPlayerSingleton.currentIndex = widget.initialIndex;
    _audioPlayerSingleton.playSong(widget.songs[widget.initialIndex]);

    _audioPlayerSingleton.audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayerSingleton.audioPlayer.durationStream.listen((duration) {
      setState(() {
        _totalDuration = duration ?? Duration.zero;
      });
    });

    isPlaying = true;

    //_openFavoritesBox(); // Open the favorites box when initializing the state
  }

  Future<void> _openFavoritesBox() async {
    _favoritesBox = await Hive.openBox<AllSongs>('favorites');
  }

  void _togglePlayPause() {
  setState(() {
    if (isPlaying) {
      _audioPlayerSingleton.pause();
    } else {
      // Resume from the current position
      _audioPlayerSingleton.audioPlayer.play();
    }
    isPlaying = !isPlaying;
  });
}

void _seekTo(double value) {
  final newPosition = Duration(milliseconds: (value * _totalDuration.inMilliseconds).toInt());
  _audioPlayerSingleton.audioPlayer.seek(newPosition);
  setState(() {
    _currentPosition = newPosition; // Update the current position
  });
}


  void _toggleFavorite(AllSongs song) async {
    await Hive.openBox<AllSongs>('favorites');
    var favoritesBox = Hive.box<AllSongs>('favorites');

    // Check if the song is already in favorites
    bool isFavorite = favoritesBox.values.any((element) => element.id == song.id);

    if (isFavorite) {
      // If the song is already in favorites, remove it
      int indexToRemove = favoritesBox.values.toList().indexWhere((element) => element.id == song.id);
      if (indexToRemove != -1) {
        await favoritesBox.deleteAt(indexToRemove);
        print("${song.tittle} removed from favorites!");
      }
    } else {
      // If the song is not in favorites, add it
      await favoritesBox.add(song);
      print("${song.tittle} added to favorites!");
    }

    setState(() {
      // Update the UI if needed
    });



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
              Colors.black,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                widget.songs[widget.initialIndex].title,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    print("Current song ID: ${widget.songs[widget.initialIndex].album}");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTo()));
                  },
                  icon: const Icon(Icons.playlist_add),
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 80),
            QueryArtworkWidget(
              id: int.parse(widget.songs[widget.initialIndex].album.toString()),
              type: ArtworkType.AUDIO,
              artworkHeight: 385,
              artworkWidth: 345,
              artworkFit: BoxFit.cover,
              nullArtworkWidget: Container(
                height: 385,
                width: 345,
                color: const Color.fromARGB(255, 56, 32, 108),
                child: const Icon(Icons.music_note, size: 100, color: Colors.white),
              ),
              keepOldArtwork: true,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.songs[widget.initialIndex].title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                var currentSong = AllSongs(
                                  id: int.parse(widget.songs[widget.initialIndex].album.toString()),
                                  tittle: widget.songs[widget.initialIndex].title,
                                  artist: widget.songs[widget.initialIndex].artist ?? 'Unknown',
                                  uri: widget.songs[widget.initialIndex].id
                                );
                                _toggleFavorite(currentSong);
                              },
                              icon: _favoritesBox != null &&
                                      _favoritesBox!.values.any((element) => element.id == int.parse(widget.songs[widget.initialIndex].album.toString()))
                                  ? const Icon(Icons.favorite, color: Colors.red)
                                  : const Icon(Icons.favorite_border, color: Colors.white),
                              iconSize: 25,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.songs[widget.initialIndex].artist ?? 'Unknown',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Slider for tracking and controlling playback position
            Slider(
              value: _totalDuration.inMilliseconds > 0
                  ? _currentPosition.inMilliseconds.toDouble() / _totalDuration.inMilliseconds.toDouble()
                  : 0.0,
              onChanged: (value) {
                _seekTo(value);
              },
              activeColor: const Color(0xff663FB9),
              inactiveColor: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(formatDuration(_currentPosition), style: const TextStyle(color: Colors.white)),
                const SizedBox(width: 70),
                Text(formatDuration(_totalDuration), style: const TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    _audioPlayerSingleton.skipPrevious(context);
                    setState(() {
                      widget.initialIndex = (_audioPlayerSingleton.currentIndex - 1).clamp(0, widget.songs.length - 1);
                    });
                  },
                  icon: const Icon(Icons.skip_previous_outlined),
                  iconSize: 35,
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: _togglePlayPause,
                  icon: isPlaying ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
                  iconSize: 55,
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    _audioPlayerSingleton.skipNext(context);
                    setState(() {
                      widget.initialIndex = (_audioPlayerSingleton.currentIndex + 1).clamp(0, widget.songs.length - 1);
                    });
                  },
                  icon: const Icon(Icons.skip_next_outlined),
                  iconSize: 35,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}



// import 'package:audio_service/audio_service.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:musicapp/music_app/add_to.dart';
// import 'package:musicapp/music_app/hive1/all_songs.dart';
// import 'package:musicapp/services/audioplayersingleton.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// class Play extends StatefulWidget {
//   List<MediaItem> songs;
//   int initialIndex;
 

//   Play({super.key, required this.songs, required this.initialIndex });

//   @override
//   State<Play> createState() => _PlayState();
// }

// class _PlayState extends State<Play> {
//   final AudioPlayerSingleton _audioPlayerSingleton = AudioPlayerSingleton();
//   Duration _currentPosition = Duration.zero;
//   Duration _totalDuration = Duration.zero;
//   bool isPlaying = false;
//    Box<AllSongs>? _favoritesBox;
  

//   @override
//   void initState() {
//     super.initState();
      
//     // Setting the playlist and starting the first song
//     _audioPlayerSingleton.setPlaylist(
//         widget.songs, widget.initialIndex); //changed
//     _audioPlayerSingleton.currentIndex =
//         widget.initialIndex; // Start at the selected song
//     _audioPlayerSingleton
//         .playSong(widget.songs[widget.initialIndex]); // Play the selected song
//     // Listening to position changes to update UI
//     _audioPlayerSingleton.audioPlayer.positionStream.listen((position) {
//       setState(() {
//         _currentPosition = position;
//       });
//     });
//     // Listening to duration changes to update UI
//     _audioPlayerSingleton.audioPlayer.durationStream.listen((duration) {
//       setState(() {
//         _totalDuration = duration ?? Duration.zero;
//       });
//     });


//     // Set isPlaying to true after starting playback
//     isPlaying = true;
// // _openFavoritesBox();
  
//   }
// //  Future<void> _openFavoritesBox() async {
// //     _favoritesBox = await Hive.openBox<AllSongs>('favorites');
// //     // Trigger UI update after opening the box
// //     // setState(() {});
// //   }

// void _togglePlayPause() {
//   setState(() {
//     if (isPlaying) {
//       _audioPlayerSingleton.pause();
//     } else {
//       // Resume from the current position
//       _audioPlayerSingleton.audioPlayer.play();
//     }
//     isPlaying = !isPlaying;
//   });
// }

// void _seekTo(double value) {
//   final newPosition = Duration(milliseconds: (value * _totalDuration.inMilliseconds).toInt());
//   _audioPlayerSingleton.audioPlayer.seek(newPosition);
//   setState(() {
//     _currentPosition = newPosition; // Update the current position
//   });
// }


  

//   Future<ImageProvider> _fetchImage(String? artUri) async {
//   if (artUri != null) {
//     return NetworkImage(artUri); // Fetch image from network
//   }
//   return const AssetImage('assets/default_album_art.png'); // Default image
// }

// // void _toggleFavorite(AllSongs song) async {
// //   await Hive.openBox<AllSongs>('favorites'); 
// //   var favoritesBox = Hive.box<AllSongs>('favorites');

// //   // Check if the song is already in favorites
// //   bool isFavorite = favoritesBox.values.any((element) => element.id == song.id);

// //   if (isFavorite) {
// //     // If the song is already in favorites, find the index and remove it
// //     int indexToRemove = favoritesBox.values.toList().indexWhere((element) => element.id == song.id);
// //     if (indexToRemove != -1) {
// //       await favoritesBox.deleteAt(indexToRemove);
// //       print("${song.tittle} removed from favorites!");
// //     }
// //   } else {
// //     // If the song is not in favorites, add it
// //     await favoritesBox.add(song);
// //     print("${song.tittle} added to favorites!");
// //   }

// //   setState(() {
// //     // Update the UI if needed
// //   });
// // }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xff663FB9),
//               Color(0xff43297A),
//               Color(0XFF19093B),
//               Colors.black,
//               Colors.black,
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           children: [
//             AppBar(
//               backgroundColor: Colors.transparent,
//               title: Text(
//                 widget.songs[widget.initialIndex].title,
//                 style: const TextStyle(color: Colors.white, fontSize: 20),
//               ),
//               leading: IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: const Icon(Icons.arrow_back, color: Colors.white),
//               ),
//               actions: [
//                 IconButton(
//                   onPressed: () {
//                     print("Current song ID: ${widget.songs[widget.initialIndex].album}");

//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => const AddTo()));
//                   },
//                   icon: const Icon(Icons.playlist_add),
//                   color: Colors.white,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 80),
//       QueryArtworkWidget(
//               id: int.parse(widget.songs[widget.initialIndex].album.toString()),
              
//               type: ArtworkType.AUDIO,
//               artworkHeight: 385, // Set the desired height
//               artworkWidth: 345, // Set the desired width
//               artworkFit: BoxFit.cover,
//               nullArtworkWidget: Container(
//                 height: 385,
//                 width: 345,
//                 color: const Color.fromARGB(255, 56, 32, 108),
//                 child: const Icon(Icons.music_note, size: 100, color: Colors.white),
//               ),keepOldArtwork: true,
//             ),
//             const SizedBox(height: 30),
//             Padding(
//               padding: const EdgeInsets.only(left: 30, right: 20),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Flexible(
//                               child: Text(
//                                 widget.songs[widget.initialIndex].title,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                                 maxLines: 1, // Limit to 1 line
//                                 overflow: TextOverflow
//                                     .ellipsis, // Add ellipsis if text overflows
//                               ),
//                             ),
// //       IconButton(
// //   onPressed: () {
// //     var currentSong = AllSongs(
// //       id: int.parse(widget.songs[widget.initialIndex].id),
// //       tittle: widget.songs[widget.initialIndex].title,
// //       artist: widget.songs[widget.initialIndex].artist ?? 'Unknown',
// //       uri: widget.songs[widget.initialIndex].extras?['uri'] ?? '',
// //     );
// //     _toggleFavorite(currentSong);
// //   },
// //   icon: Hive.box<AllSongs>('favorites').values.any((element) => element.id ==  int.parse(widget.songs[widget.initialIndex].id))
// //       ? const Icon(Icons.favorite, color: Colors.red)
// //       : const Icon(Icons.favorite_border, color: Colors.white),
// //   iconSize: 25,
// // ),

//                             IconButton(
//                               onPressed: () {
//                                 // Handle favorite action
//                               },
//                               icon: const Icon(Icons.favorite_border),
//                               color: Colors.white,
//                               iconSize: 25,
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.songs[widget.initialIndex].artist ??
//                                   'Unknown',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w300,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
// // Slider for tracking and controlling playback position
//              Slider(
//               value: _totalDuration.inMilliseconds > 0
//                   ? _currentPosition.inMilliseconds.toDouble() /
//                       _totalDuration.inMilliseconds.toDouble()
//                   : 0.0,
//               onChanged: (value) {
//                 _seekTo(value);
//               },
//               activeColor: const   Color(0xff663FB9),
//               inactiveColor: Colors.grey,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Text(formatDuration(_currentPosition),
//                     style: const TextStyle(color: Colors.white)),
//                 const SizedBox(width: 70),
//                 Text(formatDuration(_totalDuration),
//                     style: const TextStyle(color: Colors.white)),
//               ],
//             ),
//             const SizedBox(height: 40),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     _audioPlayerSingleton.skipPrevious(context);
//                     setState(() {
//                       widget.initialIndex =
//                           (_audioPlayerSingleton.currentIndex - 1)
//                               .clamp(0, widget.songs.length - 1);
//                     });
//                   },
//                   icon: const Icon(Icons.skip_previous_outlined),
//                   iconSize: 35,
//                   color: Colors.white,
//                 ),
//                 IconButton(
//                   onPressed: _togglePlayPause,
//                   icon: isPlaying
//                       ? const Icon(Icons.pause)
//                       : const Icon(Icons.play_arrow),
//                   iconSize: 55,
//                   color: Colors.white,
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     _audioPlayerSingleton.skipNext(context);
//                     setState(() {
//                       widget.initialIndex =
//                           (_audioPlayerSingleton.currentIndex + 1)
//                               .clamp(0, widget.songs.length - 1);
//                     });
//                   },
//                   icon: const Icon(Icons.skip_next_outlined),
//                   iconSize: 35,
//                   color: Colors.white,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$twoDigitMinutes:$twoDigitSeconds';
//   }
// }


