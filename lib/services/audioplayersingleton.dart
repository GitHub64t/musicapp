import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';

class AudioPlayerSingleton {
  List<MediaItem> playlistList = [];
  int currentIndex = 0;
  Box<AllSongs>? recentlyPlayedBox;

  // Private constructor for Singleton pattern
  AudioPlayerSingleton._privateConstructor();

  // Single instance of AudioPlayerSingleton
  static final AudioPlayerSingleton _instance = AudioPlayerSingleton._privateConstructor();

  // AudioPlayer instance
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Currently playing song
  MediaItem? _currentSong;

  // Single instance access
  factory AudioPlayerSingleton() {
    return _instance;
  }

  // Method to get the AudioPlayer instance
  AudioPlayer get audioPlayer => _audioPlayer;

  // Method to get the currently playing song
  MediaItem? get currentSong => _currentSong;

  // Load playlist and play from the given index
  Future<void> setAudio(List<MediaItem> playlist, int index) async {
    setPlaylist(playlist,index);
    await playSong(playlist[index]); // Play the song at the given index
  }

  Future<void> openRecentlyPlayedBox() async {
    recentlyPlayedBox = await Hive.openBox<AllSongs>('recentlyPlayed');
  }

Future<void> addRecentlyPlayed(MediaItem song) async {
  if (recentlyPlayedBox == null) {
    await openRecentlyPlayedBox();
  }

  // Check if the song is already in the recently played list
  int existingIndex = recentlyPlayedBox!.values.toList().indexWhere((item) => item.uri == song.id);
  
  // Remove the song if it already exists to avoid duplicates
  if (existingIndex != -1) {
    await recentlyPlayedBox!.deleteAt(existingIndex);
  }

  // Create a new song entry
  AllSongs newPlayed = AllSongs(
    id: int.parse(song.album.toString()),
    tittle: song.title,
    artist: song.artist ?? 'Unknown',
    uri: song.id,
  );

  // Add the new song at the end of the list
  await recentlyPlayedBox!.add(newPlayed);

  // Check the length and remove the first song if it exceeds the limit of 10
  if (recentlyPlayedBox!.length > 10) {
    await recentlyPlayedBox!.deleteAt(0);
  }
}



  //   Future<void> addRecentlyPlayed(MediaItem song) async {
  //   if (recentlyPlayedBox == null) {
  //     await openRecentlyPlayedBox();
      
  //   }
    

  //   // Check if the song is already in the recently played list
  //   bool exists = recentlyPlayedBox!.values.any((item) => item.uri == song.id);
  //   if (!exists) {
  //    AllSongs newPlayed =AllSongs(
  //       id: int.parse(song.album.toString()),
  //       tittle: song.title,
  //       artist: song.artist ?? 'Unknown',
  //       uri: song.id,
  //     );

  //     // Add the new song at the beginning of the list
  //     await recentlyPlayedBox!.put(0, newPlayed); // This adds to the top

  //     // Move existing items down (shift them)
  //     List<AllSongs> existingSongs = recentlyPlayedBox!.values.toList();
  //     for (int i = 0; i < existingSongs.length; i++) {
  //        if(existingSongs.length > 7){
  //            await recentlyPlayedBox!.deleteAt(existingSongs.length);
  //         await recentlyPlayedBox!.put(i, existingSongs[i]);
  //         print("working");
  //         }else{
  //            print("dddddd");
          
  //            await recentlyPlayedBox!.put(i, existingSongs[i]);
  //         }
  //     }

  //     // Remove the old key if necessary
  //     // if (existingSongs.length > 7) { // Limit the size of the list if needed
        
  //     //   await recentlyPlayedBox!.deleteAt(existingSongs.length);
        
  //     // }
  //   }
  // }

  // Future<void> addRecentlyPlayed(MediaItem song) async {
  //   if (recentlyPlayedBox == null) {
  //     await openRecentlyPlayedBox();
  //   }

  //   // Check if the song is already in the recently played list
  //   bool exists = recentlyPlayedBox!.values.any((item) => item.uri == song.id);
  //   if (!exists) {
  //     AllSongs newPlayed = AllSongs(
  //       id: int.parse(song.album.toString()),
  //       tittle: song.title,
  //       artist: song.artist ?? 'Unknown',
  //       uri: song.id,
  //     );

  //     // Add the new song at the beginning of the list
  //     await recentlyPlayedBox!.put(0, newPlayed); // This adds to the top

  //     // Move existing items down (shift them)
  //     List<AllSongs> existingSongs = recentlyPlayedBox!.values.toList();
  //     for (int i = 0; i < existingSongs.length; i++) {
  //       await recentlyPlayedBox!.put(i, existingSongs[i]);
  //     }

  //     // Remove the old key if necessary
  //     if (existingSongs.length >= 10) { // Limit the size of the list if needed
  //       await recentlyPlayedBox!.deleteAt(existingSongs.length);
  //     }
  //   }
  // }

  // Set the playlist
  void setPlaylist(List<MediaItem> songs , int index ) {
    playlistList = songs;
    currentIndex = index; // Reset to the first song
    _audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: songs.map((song) => AudioSource.uri(Uri.parse(song.id))).toList(),
      ),
      initialIndex: currentIndex,
    );
  }

  // Play the selected song
  Future<void> playSong(MediaItem song) async {
    try {
      // Find the index of the song in the playlist
      currentIndex = playlistList.indexWhere((element) => element.id == song.id);
      if (currentIndex != -1) { // Ensure the song is found in the playlist
        _currentSong = song;
        await _audioPlayer.seek(Duration.zero, index: currentIndex); // Seek to the start of the song
        await _audioPlayer.play(); // Play the current song
         await addRecentlyPlayed(song); 
        print("Now Playing: ${_currentSong?.id}");
        
      } else {
        print("Song not found in the playlist.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error playing song: $e");
      }
    }
  }

  // Pause the currently playing song
  void pause() {
    _audioPlayer.pause();
  }

  // Skip to the next song
  void skipNext(BuildContext context) async {
    if (_audioPlayer.hasNext) {
      await _audioPlayer.seekToNext();
      currentIndex++;
      _currentSong = playlistList[currentIndex];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Playlist reached the end')),
      );
    }
  }

  // Skip to the previous song
  void skipPrevious(BuildContext context) async {
    if (_audioPlayer.hasPrevious) {
      await _audioPlayer.seekToPrevious();
      currentIndex--;
      _currentSong = playlistList[currentIndex];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reached the beginning of the playlist')),
      );
    }
  }

  // Dispose of the AudioPlayer instance
  void dispose() {
    _audioPlayer.dispose();
  }
}





// import 'package:audio_service/audio_service.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';

// class AudioPlayerSingleton {
//   List<MediaItem> playlistList = [];
//   int currentIndex = 1;

//   // Private constructor for Singleton pattern
//   AudioPlayerSingleton._privateConstructor();

//   // Single instance of AudioPlayerSingleton
//   static final AudioPlayerSingleton _instance = AudioPlayerSingleton._privateConstructor();

//   // AudioPlayer instance
//   final AudioPlayer _audioPlayer = AudioPlayer();

//   // Currently playing song
//   MediaItem? _currentSong;

//   // Single instance access
//   factory AudioPlayerSingleton() {
//     return _instance;
//   }

//   // Method to get the AudioPlayer instance
//   AudioPlayer get audioPlayer => _audioPlayer;

//   // Method to get the currently playing song
//   MediaItem? get currentSong => _currentSong;
//    Future<void> setAudio(List<MediaItem> playlist, int index) async {
//   setPlaylist(playlist, initialIndex: index);
//   await _audioPlayer.play();
// }

  // Future<void> setAudio(List<MediaItem> playlist, int index) async {
  //   // Load the playlist into the audio player
  //   try {
  //     // Create a ConcatenatingAudioSource from the playlist
  //     final playlistSource = ConcatenatingAudioSource(
  //       children: playlist.map((item) => AudioSource.uri(Uri.parse(item.artUri.toString()))).toList(),
  //     );

  //     // Set the audio source
  //     await _audioPlayer.setAudioSource(playlistSource, initialIndex: index);
  //     // Play the audio
  //     _audioPlayer.play();
  //   } catch (e) {
  //     print("Error setting audio: $e");
  //   }
  // }

//   // Load playlist
//   void setPlaylist(List<MediaItem> songs, {int initialIndex = 0}) {
//   playlistList = songs;
//   currentIndex = initialIndex; // Start at the initial index passed
//   _audioPlayer.setAudioSource(
//     ConcatenatingAudioSource(
//       children: songs.map((song) => AudioSource.uri(Uri.parse(song.id))).toList(),
//     ),
//     initialIndex: currentIndex, // Ensure the correct song is played
//   );
// }

//   // void setPlaylist(List<MediaItem> songs) {
//   //   playlistList = songs;
//   //   currentIndex = 0; // Start at the first song
//   //   _audioPlayer.setAudioSource(
//   //     ConcatenatingAudioSource(
//   //       children: songs.map((song) => AudioSource.uri(Uri.parse(song.id))).toList(),
//   //     ),
//   //     initialIndex: currentIndex,
//   //   );
//   // }

//   //====


// //====
//   Future<void> playSong(MediaItem song) async {
//   try {
//     // Check if the current song is already playing
//     if (_currentSong?.id != song.id) {
//       // Only seek if it's a different song
//       currentIndex = playlistList.indexWhere((element) => element.id == song.id);
//       await _audioPlayer.seek(Duration.zero, index: currentIndex); // Seek to the current song
//       _currentSong = song;
      
//       // Debugging: Print current song ID
//       print("Now Playing: ${_currentSong?.id}");
//     }
    
//     await _audioPlayer.play(); // Play the current song
//     print("Playback started.");
//   } catch (e) {
//     if (kDebugMode) {
//       print("Error playing song: $e");
//     }
//   }
// }


//   // Pause the currently playing song
//   void pause() {
//     _audioPlayer.pause();
//   }

//   // Skip to the next song
//   void skipNext(BuildContext context) async {
//     try {
//       if (_audioPlayer.hasNext) {
//         await _audioPlayer.seekToNext();
//         currentIndex++;
//         _currentSong = playlistList[currentIndex];
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Playlist reached the end')),
//         );
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error skipping to next track: $e');
//       }
//     }
//   }

//   // Skip to the previous song
//   void skipPrevious(BuildContext context) async {
//     try {
//       if (_audioPlayer.hasPrevious) {
//         await _audioPlayer.seekToPrevious();
//         currentIndex--;
//         _currentSong = playlistList[currentIndex];
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Reached the beginning of the playlist')),
//         );
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error skipping to previous track: $e');
//       }
//     }
//   }

//   // Dispose of the AudioPlayer instance
//   void dispose() {
//     _audioPlayer.dispose();
//   }
// }
