
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:musicapp/music_app/play.dart';
import 'package:musicapp/services/audioplayersingleton.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final AudioPlayerSingleton _audioPlayerSingleton = AudioPlayerSingleton();
  bool isPlaying = false;
  MediaItem? currentSong;
  Duration currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Listen to changes in the playback state
    _audioPlayerSingleton.audioPlayer.playingStream.listen((playing) {
      setState(() {
        isPlaying = playing;
      });
    });

    // Listen to changes in the current song
    _audioPlayerSingleton.audioPlayer.currentIndexStream.listen((index) {
      setState(() {
        if (index != null) {
          currentSong = _audioPlayerSingleton.playlistList[index];
        }
      });
    });

    // Listen to changes in the song position
    _audioPlayerSingleton.audioPlayer.positionStream.listen((position) {
      setState(() {
        currentPosition = position;
      });
    });
  }

  void _togglePlayPause() {
    if (isPlaying) {
      _audioPlayerSingleton.pause();
    } else {
      _audioPlayerSingleton.audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return currentSong == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 6),
            child: GestureDetector(
            onTap: () {
  // Pass the current song, initial index, and current position to the play screen
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Play(
        songs: _audioPlayerSingleton.playlistList,
        initialIndex: _audioPlayerSingleton.audioPlayer.currentIndex ?? 0,
       
      ),
    ),
  );
},

              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 62, 43, 100),
                        Color.fromARGB(255, 53, 32, 100),
                        Color.fromARGB(255, 37, 17, 80),
                        Color.fromARGB(255, 23, 5, 57)
                      ],
                      end: Alignment.topCenter,
                      begin: Alignment.bottomCenter,
                    )),
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Song Info
                    Row(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            child: const Icon(Icons.music_note,
                                color: Colors.white)),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Marquee effect for the title
                            SizedBox(
                              width: 150,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  currentSong?.title ?? "Unknown Title",
                                  style: const TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Text(
                              currentSong?.artist ?? "Unknown Artist",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Control buttons
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous,
                              color: Colors.white),
                          onPressed: () =>
                              _audioPlayerSingleton.skipPrevious(context),
                        ),
                        IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: _togglePlayPause,
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next, color: Colors.white),
                          onPressed: () =>
                              _audioPlayerSingleton.skipNext(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

