import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerSingleton {
  List<MediaItem> playlistList = [];
  int currentIndex = 0;

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

//   // Future<void> setAudio(List<MediaItem> playlist, int index) async {
//   //   // Load the playlist into the audio player
//   //   try {
//   //     // Create a ConcatenatingAudioSource from the playlist
//   //     final playlistSource = ConcatenatingAudioSource(
//   //       children: playlist.map((item) => AudioSource.uri(Uri.parse(item.artUri.toString()))).toList(),
//   //     );

//   //     // Set the audio source
//   //     await _audioPlayer.setAudioSource(playlistSource, initialIndex: index);
//   //     // Play the audio
//   //     _audioPlayer.play();
//   //   } catch (e) {
//   //     print("Error setting audio: $e");
//   //   }
//   // }

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
