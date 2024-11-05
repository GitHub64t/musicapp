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


