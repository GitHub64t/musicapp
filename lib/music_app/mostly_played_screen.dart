import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';
import 'package:musicapp/music_app/play.dart';
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
              gradient: LinearGradient(
                  colors: [Color(0xff6A42BF), Color(0xff271748), Colors.black],
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter)),
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
                      color: Colors.white,
                    )),
                const Text("Mostly played",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
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
                        gradient: LinearGradient(
                            colors: [
                          Color.fromARGB(255, 91, 55, 168),
                          Color(0xff351F64),
                          Color(0xff1E0D43)
                        ],
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter)),
                    child: const Center(
                      child: Icon(
                        Icons.skip_previous_outlined,
                        color: Colors.white,
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
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                            fontSize: 25),
                      ),
                      Text("Playlist",
                          style: TextStyle(
                              color: Colors.white,
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
                      style: TextStyle(color: Colors.white)))
              : ListView.builder(
                  itemCount: mostlyPlayedBox!.length<11 ? mostlyPlayedBox!.length:10,
                  itemBuilder: (context, index) {
                    final songs = mostlyPlayedBox!.values.toList()
                      ..sort((a, b) =>
                          (b.playCount ?? 0).compareTo(a.playCount ?? 0));
                    final song = songs[index];
                    return ListTile(
                      title: Text(
                        'Played this song ${song.playCount} ${song.playCount == 1 ? "time" : "times"}',
                        style: const TextStyle(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        List<MediaItem> recentlyPlayed =
                            songs.map((recent) {
                          return MediaItem(
                            id: recent.uri,
                            title: recent.tittle,
                            artist: recent.artist,
                            album: recent.id.toString(),
                          );
                        }).toList();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Play(
                              songs: recentlyPlayed,
                              initialIndex: index,
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
                            color: Colors.white,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onPressed: () {},
                      ),
                    );
                  },
                ),
        )
      ]),
    );
  }
}
