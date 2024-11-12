
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicapp/music_app/add_to.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';
import 'package:musicapp/widgets/appgraient.dart';
import 'package:musicapp/widgets/miniplayer.dart';
import 'package:musicapp/widgets/navigation.dart';
import 'package:musicapp/widgets/options.dart';
import 'package:musicapp/widgets/songListtile.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Recent extends StatefulWidget {
  const Recent({super.key});

  @override
  State<Recent> createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  Box<AllSongs>? recentlyPlayedBox;

  @override
  void initState() {
    super.initState();
    openRecentlyPlayedBox();
  }

  Future<void> openRecentlyPlayedBox() async {
    recentlyPlayedBox = await Hive.openBox<AllSongs>('recentlyPlayed');
    setState(() {}); // Trigger UI rebuild after opening box
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
                const Text("Recents",
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
                        "Recently Played",
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
          child: recentlyPlayedBox == null
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: recentlyPlayedBox!.values.length,
                  itemBuilder: (context, index) {
                    // final song = recentlyPlayedBox!.getAt(index);
                    final songs =
                        recentlyPlayedBox!.values.toList().reversed.toList();
                    final song = songs[index];
                    return SongListTile(
                      song: song,
                      index: index,
                      onOptionsPressed: () {
                        SongOptionsHelper.showOptionsBottomSheet(context: context, song: song);
                      },
                      onTap: () {
                        SongNavigationHelper.navigateToPlayScreen(
                          context: context,
                    boxValues:
                              recentlyPlayedBox!.values.toList(),
                          index: index,
                        );
                      },
                    );

                    //   onOptionsPressed: onOptionsPressed)
                    // return ListTile(
                    //   title: Text(
                    //     song.tittle ,
                    //     style: const TextStyle(color: AppGradients.whiteColor),
                    //     maxLines: 1,
                    //     overflow: TextOverflow.ellipsis,
                    //   ),
                    //   onTap: () {
                    //     List<MediaItem> recentlyPlayed = recentlyPlayedBox!.values.map((recent) {
                    //       return MediaItem(
                    //         id: recent.uri,
                    //         title: recent.tittle,
                    //         artist: recent.artist,
                    //         album: recent.id.toString(),
                    //       );
                    //     }).toList().reversed.toList()
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => Play(
                    //           songs: recentlyPlayed,
                    //           initialIndex: index,
                    //            currentPosition: Duration.zero,
                    //         ),
                    //       ),
                    //     );
                    //   },
                    //   subtitle: Text(
                    //     song.artist ,
                    //     style: const TextStyle(color: Colors.white60),
                    //   ),
                    //   leading: QueryArtworkWidget(
                    //     id: song.id,
                    //     type: ArtworkType.AUDIO,
                    //     artworkHeight: 40,
                    //     artworkWidth: 40,
                    //     artworkFit: BoxFit.cover,
                    //     nullArtworkWidget: const CircleAvatar(
                    //       backgroundColor: Color.fromARGB(255, 46, 19, 86),
                    //       child: Icon(
                    //         Icons.music_note,
                    //         color: AppGradients.whiteColor,
                    //       ),
                    //     ),
                    //   ),
                    //   trailing: IconButton(
                    //     icon: const Icon(Icons.more_vert, color: AppGradients.whiteColor),
                    //     onPressed: () {
                    //       _showOptionsBottomSheet(context, song);
                    //     },
                    //   ),
                  }),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: MiniPlayer(),
        ),
      ]),
    );
  }

  void _showOptionsBottomSheet(BuildContext context, AllSongs song) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 33, 32, 32),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  song.tittle,
                  style: const TextStyle(color: AppGradients.whiteColor),
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
                // leading: const Icon(Icons.music_note, color: Colors.white),
                subtitle: Text(
                  song.artist,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              const Divider(thickness: 0.4),
              ListTile(
                leading: const Icon(Icons.add_rounded,
                    color: AppGradients.whiteColor),
                title: const Text('Add to playlist',
                    style: TextStyle(color: AppGradients.whiteColor)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddTo()));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
