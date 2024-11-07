import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
  Box<AllSongs>? favBox;

  @override
  void initState() {
    super.initState();

    _audioPlayerSingleton.setPlaylist(widget.songs, widget.initialIndex);
    _audioPlayerSingleton.currentIndex = widget.initialIndex;
    _audioPlayerSingleton.playSong(widget.songs[widget.initialIndex]);

    _audioPlayerSingleton.audioPlayer.positionStream.listen((position){
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
    openFavoritesBox();
  }
//   void deletobox() async{
// await Hive.deleteBoxFromDisk('favorites');
//   }

  Future<void> openFavoritesBox() async {
  try {
    favBox = await Hive.openBox<AllSongs>('favorites');
    setState(() {
     const ScaffoldMessenger(child: Text("error"));
    }); // Update the UI after successfully opening the box
  } catch (e) {
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
    int index = favBox!.values.toList().indexWhere((favSong) => favSong.uri == song.id.toString());
    if (index != -1) { // Ensure the song is found
      int key = favBox!.keyAt(index); // Get the key for the song at the found index
      await favBox!.delete(key); // Delete the song using the key
    }
  } else {
    // Add to favorites
    AllSongs newFav = AllSongs(
      id: int.parse((song.album.toString())),  // Handle the id parsing carefully
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
    final newPosition = Duration(milliseconds: (value * _totalDuration.inMilliseconds).toInt());
    _audioPlayerSingleton.audioPlayer.seek(newPosition);
    setState(() {
      _currentPosition = newPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaItem currentSong = widget.songs[widget.initialIndex];

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
                currentSong.title,
                style: const TextStyle(color:Colors.white , fontSize: 20),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
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
                                currentSong.title,
                                style: const TextStyle(
                                  color: Colors.white,
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
                   IconButton(onPressed: (){}, icon:const Icon(Icons.playlist_add),
                iconSize: 25,
                  color: Colors.white,),
                IconButton(
                  onPressed: () {
                    _audioPlayerSingleton.skipPrevious(context);
                    setState(() {
                      widget.initialIndex = (_audioPlayerSingleton.currentIndex - 1).clamp(0, widget.songs.length - 1);
                    });
                  },
                  icon: const Icon(Icons.skip_previous_outlined),
                  iconSize: 45,
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
                  iconSize: 45,
                  color: Colors.white,
                ),
              
                    IconButton(
                              onPressed: () => toggleFavorite(currentSong),
                              icon: Icon(
                                isFavorite(currentSong) ? Icons.favorite : Icons.favorite_border,
                                color: Colors.white,
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
