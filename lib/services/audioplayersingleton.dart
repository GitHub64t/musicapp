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
  Box<AllSongs>? mostlyPlayedBox;

  // AudioPlayerSingleton._privateConstructor();
  LoopMode _repeatMode = LoopMode.off;
  LoopMode get repeatMode => _repeatMode;
  //AudioPlayerSingleton._privateConstructor();
  AudioPlayerSingleton._privateConstructor() {
    // Listen for playback completion to handle repeat modes
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        if (_repeatMode == LoopMode.one) {
          // Repeat current song
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.play();
        }
        // For LoopMode.all, let the playlist loop automatically
      }
    });
  }

  // Single instance of AudioPlayerSingleton
  static final AudioPlayerSingleton _instance =
      AudioPlayerSingleton._privateConstructor();

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

  Future<void> setAudio(List<MediaItem> playlist, int index) async {
    setPlaylist(playlist, index);
    await playSong(playlist[index]); // Play the song at the given index
  }

  void toggleShuffleMode() {
    audioPlayer.setShuffleModeEnabled(!audioPlayer.shuffleModeEnabled);
  }

  // Toggle repeat mode: None -> All -> One
  void toggleRepeatMode() {
    if (_repeatMode == LoopMode.off) {
      _repeatMode = LoopMode.one; // Set to repeat the current song
    } else {
      _repeatMode = LoopMode.off; // Disable repeat mode
    }
    _audioPlayer.setLoopMode(_repeatMode);
  }

  // Getter to access the current repeat mode

  Future<void> openRecentlyPlayedBox() async {
    recentlyPlayedBox = await Hive.openBox<AllSongs>('recentlyPlayed');
  }

  Future<void> addRecentlyPlayed(MediaItem song) async {
    if (recentlyPlayedBox == null) {
      await openRecentlyPlayedBox();
    }

    // Check if the song is already in the recently played list
    int existingIndex = recentlyPlayedBox!.values
        .toList()
        .indexWhere((item) => item.uri == song.id);

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
     
    } else {
      // If found, increment play count

      existingSong.playCount = (existingSong.playCount ?? 0) + 1;
      await mostlyPlayedBox!
          .put(existingKey, existingSong); // Update existing entry
      
    }
  }

  List<AllSongs> getTopMostlyPlayedSongs(int count) {
    if (mostlyPlayedBox == null) {
      openBoxes();
    }
    // Sort the songs by play count in descending order and return only the top `count` songs
    return mostlyPlayedBox!.values.toList()
      ..sort((a, b) => (b.playCount ?? 0).compareTo(a.playCount ?? 0))
      ..sublist(
          0, count > mostlyPlayedBox!.length ? mostlyPlayedBox!.length : count);
  }

  Future<void> playSong(MediaItem song) async {
    try {
      currentIndex =
          playlistList.indexWhere((element) => element.id == song.id);
      if (currentIndex != -1) {
        _currentSong = song;
        await _audioPlayer.seek(Duration.zero, index: currentIndex);
        await _audioPlayer.play();
        await addToMostlyPlayed(song);
        await addRecentlyPlayed(song);
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
  //Skip to the next song

  void skipNext(BuildContext context) async {
    try {
      if (_repeatMode == LoopMode.one) {
        // Restart the current song
        await _audioPlayer.seek(Duration.zero);
        await _audioPlayer.play();
      } else if (_audioPlayer.shuffleModeEnabled) {
        // Shuffle playback
        final shuffledIndexes = _audioPlayer.effectiveIndices;
        final currentIndex = _audioPlayer.currentIndex;

        if (currentIndex != null && shuffledIndexes != null) {
          final nextIndex = (shuffledIndexes.indexOf(currentIndex) + 1) %
              shuffledIndexes.length;
          await _audioPlayer.seek(Duration.zero,
              index: shuffledIndexes[nextIndex]);
        } else {
          if (kDebugMode) {
            print("Error: No shuffled indexes or current index available.");
          }
        }
      } else {
        // Normal playback
        if (_audioPlayer.hasNext) {
          await _audioPlayer.seekToNext();
        } else if (_repeatMode == LoopMode.all) {
          await _audioPlayer.seek(Duration.zero, index: 0); // Loop to start
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Playlist reached the end')),
          );
        }
      }

      _updateCurrentSong();
    } catch (e) {
      if (kDebugMode) {
        print("Error in skipNext: $e");
      }
    }
  }

  void skipPrevious(BuildContext context) async {
    try {
      if (_repeatMode == LoopMode.one) {
        await _audioPlayer.seek(Duration.zero);
        await _audioPlayer.play();
      } else if (_audioPlayer.shuffleModeEnabled) {
        final shuffledIndexes = _audioPlayer.effectiveIndices;
        final currentIndex = _audioPlayer.currentIndex;

        if (currentIndex != null && shuffledIndexes != null) {
          final previousIndex = (shuffledIndexes.indexOf(currentIndex) -
                  1 +
                  shuffledIndexes.length) %
              shuffledIndexes.length;
          await _audioPlayer.seek(Duration.zero,
              index: shuffledIndexes[previousIndex]);
        } else {
          if (kDebugMode) {
            print("Error: No shuffled indexes or current index available.");
          }
        }
      } else {
        if (_audioPlayer.hasPrevious) {
          await _audioPlayer.seekToPrevious();
        } else if (_repeatMode == LoopMode.all) {
          await _audioPlayer.seek(Duration.zero,
              index: playlistList.length - 1);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Reached the beginning of the playlist')),
          );
        }
      }

      _updateCurrentSong();
    } catch (e) {
      if (kDebugMode) {
        print("Error in skipPrevious: $e");
      }
    }
  }

  void _updateCurrentSong() {
    final currentIndex = _audioPlayer.currentIndex;
    if (currentIndex != null && playlistList.isNotEmpty) {
      this.currentIndex = currentIndex;
      _currentSong = playlistList[currentIndex];
     
    }
  }

  Future<void> setPlaylist(List<MediaItem> songs, int index,
      {bool shuffle = false}) async {
    playlistList = songs;
    currentIndex = index;
    await _audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children:
            songs.map((song) => AudioSource.uri(Uri.parse(song.id))).toList(),
      ),
      initialIndex: currentIndex,
    );

    // Enable shuffle and repeat
    if (shuffle) toggleShuffleMode();
    _audioPlayer.setLoopMode(LoopMode.all); // Ensure repeat-all is default
  }

  // Dispose of the AudioPlayer instance
  void dispose() {
    _audioPlayer.dispose();
  }
}
