import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';

class AudioPlayerSingleton {
  List<MediaItem> playlistList = [];
  int currentIndex = 0;
  Box<AllSongs>? recentlyPlayedBox;
  Box<AllSongs>? mostlyPlayedBox;

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
  // Future<void> setAudio(List<MediaItem> playlist, int index) async {
  //   setPlaylist(playlist, index);
  //   await playSong(playlist[index]); // Play the song at the given index
  // }

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

  // Open boxes for recently played and mostly played lists
  Future<void> openBoxes() async {
    mostlyPlayedBox = await Hive.openBox<AllSongs>('mostlyPlayed');
  }

  // Method to clean up mostly played list by removing songs with lower play counts
// Future<void> cleanMostlyPlayedList() async {
//   // Ensure the box is open
//   if (mostlyPlayedBox == null) await openBoxes();

//   // Sort and keep only top 10 songs by play count
//   List<AllSongs> sortedSongs = mostlyPlayedBox!.values.toList()
//     ..sort((a, b) => (b.playCount ?? 0).compareTo(a.playCount ?? 0));
  
//   mostlyPlayedBox!.clear(); // Clear the existing box

//   for (int i = 0; i < sortedSongs.length && i < 10; i++) {
//     // Add back only top 10 songs
//     await mostlyPlayedBox!.add(sortedSongs[i]);
//   }
// }

Future<void> addToMostlyPlayed(MediaItem song) async {
  if (mostlyPlayedBox == null) {
    await openBoxes();
  }

  // Locate song in the mostly played box by matching URI
  AllSongs? existingSong;
  int? existingKey;

  // Find song entry by URI
  for (int i = 0; i < mostlyPlayedBox!.length; i++) {
    AllSongs? songInBox = mostlyPlayedBox!.getAt(i);
    if (songInBox?.uri == song.id) {
      existingSong = songInBox;
      existingKey = i;
      break;
    }
  }

  if (existingSong == null) {
    // If song is not found, add it with initial play count
    AllSongs newSong = AllSongs(
      id: int.parse(song.album.toString()),
      tittle: song.title,
      artist: song.artist ?? 'Unknown',
      uri: song.id,
      playCount: 1,
    );
    await mostlyPlayedBox!.add(newSong);
    print("Added new song with initial play count: ${newSong.playCount}");
  } else {
    // If found, increment play count
    existingSong.playCount = (existingSong.playCount ?? 0) + 1;
    await mostlyPlayedBox!.put(existingKey, existingSong); // Update existing entry
    print("Incremented play count for existing song: ${existingSong.playCount}");
  }
}

List<AllSongs> getTopMostlyPlayedSongs(int count) {
  if (mostlyPlayedBox == null) {
    openBoxes();
  }
  // Sort the songs by play count in descending order and return only the top `count` songs
  return mostlyPlayedBox!.values.toList()
    ..sort((a, b) => (b.playCount ?? 0).compareTo(a.playCount ?? 0))
    ..sublist(0, count > mostlyPlayedBox!.length ? mostlyPlayedBox!.length : count);
}
  // Set the playlist
  void setPlaylist(List<MediaItem> songs, int index) {
    playlistList = songs;
    currentIndex = index;
    _audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: songs.map((song) => AudioSource.uri(Uri.parse(song.id))).toList(),
      ),
      initialIndex: currentIndex,
    );
  }
Future<void> playSong(MediaItem song) async {
  try {
    currentIndex = playlistList.indexWhere((element) => element.id == song.id);
    if (currentIndex != -1) {
      _currentSong = song;
      await _audioPlayer.seek(Duration.zero, index: currentIndex);
      await _audioPlayer.play();
      await addToMostlyPlayed(song); 
      await addRecentlyPlayed(song); 
    } else {
      print("Song not found in the playlist.");
    }
  } catch (e) {
    print("Error playing song: $e");
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




