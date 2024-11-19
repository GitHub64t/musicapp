import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp/services/audioplayersingleton.dart';
import 'package:musicapp/widgets/appgraient.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

// In the MiniPlayer widget
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
                              color: AppGradients.whiteColor)),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 150,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                currentSong?.title ?? "Unknown Title",
                                style: const TextStyle(
                                    color: AppGradients.whiteColor),
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
                  Row(
                    children: [
                      IconButton(
  icon: Icon(
    Icons.skip_previous,
    color: _audioPlayerSingleton.repeatMode == LoopMode.one ||
            _audioPlayerSingleton.currentIndex <= 0
        ? const Color.fromARGB(255, 116, 116, 116) // Gray color when repeat mode is on or already at the start
        : AppGradients.whiteColor, // Normal color when repeat mode is off and not at the start of the playlist
  ),
  onPressed: _audioPlayerSingleton.repeatMode == LoopMode.one || 
            _audioPlayerSingleton.currentIndex <= 0
      ? null // Disable the button if repeat mode is on or at the start of the playlist
      : () {
          _audioPlayerSingleton.skipPrevious(context);
          setState(() {});
        },
),

                      IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: AppGradients.whiteColor,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                     IconButton(
  icon: Icon(
    Icons.skip_next,
    color: _audioPlayerSingleton.repeatMode == LoopMode.one ||
            _audioPlayerSingleton.currentIndex >= _audioPlayerSingleton.playlistList.length - 1
        ? const Color.fromARGB(255, 116, 116, 116) // Gray color when repeat mode is on or already at the last song
        : AppGradients.whiteColor, // Normal color when repeat mode is off and not at the end of the playlist
  ),
  onPressed: _audioPlayerSingleton.repeatMode == LoopMode.one || 
            _audioPlayerSingleton.currentIndex >= _audioPlayerSingleton.playlistList.length - 1
      ? null // Disable the button if repeat mode is on or at the last song
      : () {
          _audioPlayerSingleton.skipNext(context);
          setState(() {});
        },
),

                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
