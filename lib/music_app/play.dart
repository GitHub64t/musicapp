// ignore_for_file: must_be_immutable

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';
import 'package:musicapp/services/audioplayersingleton.dart';

import 'package:musicapp/widgets/appgraient.dart';
import 'package:musicapp/widgets/options.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Play extends StatefulWidget {
  List<MediaItem> songs;
  int initialIndex;
  final Duration currentPosition;

  Play(
      {super.key,
      required this.songs,
      required this.initialIndex,
      required this.currentPosition});

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  final AudioPlayerSingleton _audioPlayerSingleton = AudioPlayerSingleton();
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool isPlaying = false;
  Box<AllSongs>? favBox;
  bool isShuffle = false;

  @override
  void initState() {
    super.initState();

    // Set the current position to the value passed from MiniPlayer or default
    _currentPosition = widget.currentPosition;

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

    _audioPlayerSingleton.audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index >= 0 && index < widget.songs.length) {
        setState(() {
          widget.initialIndex = index;
        });
      }
    });

    _audioPlayerSingleton.audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed &&
          _audioPlayerSingleton.repeatMode == LoopMode.one) {
        // If repeat one is active, manually turn it off after one repeat
        setState(() {
          _audioPlayerSingleton.toggleRepeatMode(); // Disable repeat mode
        });
      }
    });

    isPlaying = true;
    openFavoritesBox();
    setState(() {});
  }

  Future<void> openFavoritesBox() async {
    try {
      favBox = await Hive.openBox<AllSongs>('favorites');
      setState(() {
        const ScaffoldMessenger(child: Text("error"));
      }); // Update the UI after successfully opening the box
    } catch (e) {
      // ignore: avoid_print
      print("Error opening favorites box: $e");
    }
  }

  // Check if the current song is in the favorites playlist
  bool isFavorite(MediaItem song) {
    if (favBox == null) {
      return false;
    }
    // Check if the song is in the favorites box
    return favBox!.values.any((favSong) => favSong.uri == song.id);
  }

  // Add or remove the current song from the favorites playlist
  void toggleFavorite(MediaItem song) async {
    if (isFavorite(song)) {
      // Remove from favorites
      int index = favBox!.values
          .toList()
          .indexWhere((favSong) => favSong.uri == song.id.toString());
      if (index != -1) {
        // Ensure the song is found
        int key =
            favBox!.keyAt(index); // Get the key for the song at the found index
        await favBox!.delete(key); // Delete the song using the key
      }
    } else {
      // Add to favorites
      AllSongs newFav = AllSongs(
        id: int.parse(
            (song.album.toString())), // Handle the id parsing carefully
        tittle: song.title.toString(),
        artist: song.artist.toString(),
        uri: song.id.toString(),
      );
      await favBox!.add(newFav);
    }
    setState(() {});
  }

  void _togglePlayPause() {
    setState(() {
      if (isPlaying) {
        _audioPlayerSingleton.pause();
      } else {
        _audioPlayerSingleton.audioPlayer.play();
      }
      isPlaying = !isPlaying;
    });
  }

  void _seekTo(double value) {
    final newPosition =
        Duration(milliseconds: (value * _totalDuration.inMilliseconds).toInt());
    _audioPlayerSingleton.audioPlayer.seek(newPosition);
    setState(() {
      _currentPosition = newPosition;
    });
  }

  void _toggleRepeat() {
    setState(() {
      _audioPlayerSingleton.toggleRepeatMode();
    });
  }

  void _toggleShuffle() {
    setState(() {
      isShuffle = !isShuffle;
      _audioPlayerSingleton.toggleShuffleMode(); // Enable/disable shuffle
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaItem currentSong = widget.songs[widget.initialIndex];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.thirdGradient),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                currentSong.title,
                style: const TextStyle(
                    color: AppGradients.whiteColor, fontSize: 20),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back,
                    color: AppGradients.whiteColor),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    AllSongs songForOptions = AllSongs(
                      id: int.parse(
                          currentSong.album ?? '0'), // Handle album ID
                      tittle: currentSong.title,
                      artist: currentSong.artist ?? 'Unknown',
                      uri: currentSong.id.toString(),
                    );
                    SongOptionsHelper.showOptionsBottomSheet(
                        context: context, song: songForOptions);
                  },
                  icon: const Icon(Icons.more_vert),
                  iconSize: 25,
                  color: AppGradients.whiteColor,
                ),
              ],
            ),
            const SizedBox(height: 80),
            QueryArtworkWidget(
              id: int.parse(currentSong.album ?? '0'),
              type: ArtworkType.AUDIO,
              artworkHeight: 385,
              artworkWidth: 345,
              artworkFit: BoxFit.cover,
              nullArtworkWidget: Container(
                height: 385,
                width: 345,
                color: const Color.fromARGB(255, 56, 32, 108),
                child: const Icon(Icons.music_note,
                    size: 100, color: AppGradients.whiteColor),
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
                                currentSong.title,
                                style: const TextStyle(
                                  color: AppGradients.whiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              currentSong.artist ?? 'Unknown',
                              style: const TextStyle(
                                color: AppGradients.whiteColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () => toggleFavorite(currentSong),
                    icon: Icon(
                      isFavorite(currentSong)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: AppGradients.whiteColor,
                    ),
                    iconSize: 25,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Slider(
              value: _totalDuration.inMilliseconds > 0
                  ? (_currentPosition.inMilliseconds.toDouble() /
                          _totalDuration.inMilliseconds.toDouble())
                      .clamp(0.0, 1.0)
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
                Text(formatDuration(_currentPosition),
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(width: 70),
                Text(formatDuration(_totalDuration),
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
            //const SizedBox(height: 60),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    _audioPlayerSingleton.repeatMode == LoopMode.one
                        ? Icons.repeat_one // Display repeat one icon
                        : Icons
                            .repeat, // Display regular repeat icon for off mode
                  ),
                  color: _audioPlayerSingleton.repeatMode == LoopMode.one
                      ? Colors.blue // Active color when repeat one is enabled
                      : Colors.grey, // Inactive color when repeat is off
                  onPressed:
                      _toggleRepeat, // Toggle repeat mode on button press
                ),
                IconButton(
                  onPressed: (() {
                    // Conditions for disabling skip-previous functionality
                    final isRepeatOne =
                        _audioPlayerSingleton.repeatMode == LoopMode.one;
                    final isFirstSong =
                        !_audioPlayerSingleton.audioPlayer.shuffleModeEnabled &&
                            _audioPlayerSingleton.currentIndex == 0;

                    // Check if skipping is disabled in repeat mode or at the beginning of the playlist
                    if (isRepeatOne || isFirstSong) {
                      // Show SnackBar if skipping is disabled
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isRepeatOne
                                ? "Skipping is disabled in repeat mode."
                                : "You are at the beginning of the playlist.",
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else {
                      // Normal skip previous functionality
                      _audioPlayerSingleton.skipPrevious(context);
                      setState(() {
                        widget.initialIndex =
                            (_audioPlayerSingleton.currentIndex - 1)
                                .clamp(0, widget.songs.length - 1);
                      });
                    }
                  }),
                  icon: Icon(
                    Icons.skip_previous,
                    color: (() {
                      final isRepeatOne =
                          _audioPlayerSingleton.repeatMode == LoopMode.one;
                      final isFirstSong =
                          _audioPlayerSingleton.currentIndex == 0;

                      return (isRepeatOne ||
                              isFirstSong &&
                                  !_audioPlayerSingleton
                                      .audioPlayer.shuffleModeEnabled)
                          ? const Color.fromARGB(
                              255, 116, 116, 116) // Gray color when disabled
                          : AppGradients.whiteColor;
                    }()),
                  ),
                  iconSize: 45,
                ),
                IconButton(
                  onPressed: _togglePlayPause,
                  icon: isPlaying
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow),
                  iconSize: 55,
                  color: AppGradients.whiteColor,
                ),
                IconButton(
                  onPressed: (() {
                    // Conditions for disabling skip-next functionality
                    final isRepeatOne =
                        _audioPlayerSingleton.repeatMode == LoopMode.one;
                    final isLastSong =
                        !_audioPlayerSingleton.audioPlayer.shuffleModeEnabled &&
                            _audioPlayerSingleton.currentIndex ==
                                widget.songs.length - 1;

                    if (isRepeatOne ||
                        (isLastSong &&
                            !_audioPlayerSingleton
                                .audioPlayer.shuffleModeEnabled)) {
                      // Show SnackBar if skipping is disabled
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isRepeatOne
                                ? "Skipping is disabled in repeat-one mode."
                                : "You have reached the end of the playlist.",
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else {
                      // Normal skip next functionality
                      _audioPlayerSingleton.skipNext(context);
                      setState(() {
                        widget.initialIndex = _audioPlayerSingleton.currentIndex
                            .clamp(0, widget.songs.length - 1);
                      });
                    }
                  }),
                  icon: Icon(
                    Icons.skip_next,
                    color: (() {
                      final isRepeatOne =
                          _audioPlayerSingleton.repeatMode == LoopMode.one;
                      final isLastSong = !_audioPlayerSingleton
                              .audioPlayer.shuffleModeEnabled &&
                          _audioPlayerSingleton.currentIndex ==
                              widget.songs.length - 1;

                      return (isRepeatOne ||
                              (isLastSong &&
                                  !_audioPlayerSingleton
                                      .audioPlayer.shuffleModeEnabled))
                          ? const Color.fromARGB(
                              255, 116, 116, 116) // Gray color when disabled
                          : AppGradients.whiteColor;
                    }()),
                  ),
                  iconSize: 45,
                ),
                IconButton(
                  onPressed: _audioPlayerSingleton.playlistList.length < 5 ||
                          _audioPlayerSingleton.repeatMode == LoopMode.one
                      ? () {
                          // Show a Scaffold message (Snackbar) if shuffle is unavailable due to playlist length or repeat mode
                          String message = '';

                          if (_audioPlayerSingleton.playlistList.length < 5) {
                            message =
                                'Shuffle is unavailable. Playlist must have at least 5 songs.';
                          } else if (_audioPlayerSingleton.repeatMode ==
                              LoopMode.one) {
                            message =
                                'Shuffle is unavailable. Repeat mode is on.';
                          }

                          // Show Snackbar with the message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      : _toggleShuffle, // Enable shuffle when playlist length is >= 5 and repeat mode is off
                  icon: Icon(
                    Icons.shuffle,
                    color: _audioPlayerSingleton.playlistList.length < 5 ||
                            _audioPlayerSingleton.repeatMode == LoopMode.one
                        ? const Color.fromARGB(
                            255, 116, 116, 116) // Gray color when disabled
                        : (_audioPlayerSingleton.audioPlayer.shuffleModeEnabled
                            ? Colors.blue
                            : AppGradients
                                .whiteColor), // Active color for shuffle
                  ),
                  iconSize: 25,
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
