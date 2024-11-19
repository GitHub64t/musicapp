import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';
import 'package:musicapp/music_app/play.dart';
import 'package:musicapp/widgets/appgraient.dart';
import 'package:musicapp/widgets/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MostlyPlayedScreen extends StatefulWidget {
  const MostlyPlayedScreen({super.key});

  @override
  State<MostlyPlayedScreen> createState() => _MostlyPlayedScreenState();
}

class _MostlyPlayedScreenState extends State<MostlyPlayedScreen> {
  Box<AllSongs>? mostlyPlayedBox;

  @override
  void initState() {
    super.initState();
    loadMostlyPlayedSongs();
  }

  //  Future<List<AllSongs>> _fetchMostlyPlayedSongs() async {
  //  // return AudioPlayerSingleton().getMostlyPlayed();
  // }
  Future<void> loadMostlyPlayedSongs() async {
    mostlyPlayedBox = await Hive.openBox<AllSongs>('mostlyPlayed');

    setState(() {}); // Refresh the UI after loading
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.primaryGradient,
          ),
          child: Column(children: [
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppGradients.whiteColor,
                    )),
                const Text("Mostly played",
                    style: TextStyle(
                        fontSize: 25,
                        color: AppGradients.whiteColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none)),
                const SizedBox(width: 50),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: const BoxDecoration(color: Colors.transparent),
              height: 120,
              width: 370,
              child: Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      gradient: AppGradients.secondaryGradient,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.skip_previous_outlined,
                        color: AppGradients.whiteColor,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 25),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mostly Played",
                        style: TextStyle(
                            color: AppGradients.whiteColor,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                            fontSize: 25),
                      ),
                      Text("Playlist",
                          style: TextStyle(
                              color: AppGradients.whiteColor,
                              decoration: TextDecoration.none,
                              fontSize: 20,
                              fontWeight: FontWeight.w200))
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ]),
        ),
        Expanded(
          child: mostlyPlayedBox == null || mostlyPlayedBox!.isEmpty
              ? const Center(
                  child: Text('No mostly played songs available',
                      style: TextStyle(color: AppGradients.whiteColor)))
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  // itemCount: mostlyPlayedBox!.length < 11 
                  //     ? mostlyPlayedBox!.length
                  //     : 10,
                  itemCount:  mostlyPlayedBox!.length,
                  itemBuilder: (context, index) {
                    final songs = mostlyPlayedBox!.values.toList()
                      ..sort((a, b) =>
                          (b.playCount ?? 0).compareTo(a.playCount ?? 0));
                    final song = songs[index];
                    return song.playCount! >= 5
                      
    ? ListTile(
        title: Text(
          'This song played ${song.playCount} times',
          style: const TextStyle(color: AppGradients.whiteColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          List<MediaItem> songList = songs
              .map((item) => MediaItem(
                    id: item.uri,
                    title: item.tittle,
                    artist: item.artist,
                    album: item.id.toString(),
                  ))
              .toList();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Play(
                songs: songList,
                initialIndex: index,
                currentPosition: Duration.zero,
              ),
            ),
          );
        },
        subtitle: Text(
          song.tittle,
          style: const TextStyle(color: Colors.white60),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: QueryArtworkWidget(
          id: song.id,
          type: ArtworkType.AUDIO,
          artworkHeight: 40,
          artworkWidth: 40,
          artworkFit: BoxFit.cover,
          nullArtworkWidget: const CircleAvatar(
            backgroundColor: Color.fromARGB(255, 46, 19, 86),
            child: Icon(
              Icons.music_note,
              color: AppGradients.whiteColor,
            ),
          ),
        ),
      )
   :const SizedBox();  // If playCount is less than 5, show an empty container
                  },
                ),
                
        ),
       const Align(
            alignment: Alignment.bottomCenter,
            child: MiniPlayer(),
          ),    
      ]),
    );
  }
}
