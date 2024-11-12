import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';
import 'package:musicapp/music_app/playlist_listscreen.dart';
import 'package:musicapp/widgets/appgraient.dart';
import 'package:musicapp/widgets/edit.dart';
import 'package:musicapp/widgets/navigation.dart';
import 'package:musicapp/widgets/options.dart';
import 'package:musicapp/widgets/songListtile.dart';

class Playlist extends StatefulWidget {
  String playlistName;
  Playlist({super.key, required this.playlistName});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  List<AllSongs>? playlistSongs = [];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final playlistBox = await Hive.openBox<AllSongs>(widget.playlistName);
    setState(() {
      playlistSongs = playlistBox.values.toList();
    });
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
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlaylistListscreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppGradients.whiteColor,
                    )),
                const Text("Playlists",
                    style: TextStyle(
                        fontSize: 25,
                        color: AppGradients.whiteColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none)),
                const SizedBox(
                  width: 50,
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: AppGradients.secondaryGradient,
              ),
              height: 120,
              width: 370,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 90,
                      width: 90,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // Apply the same radius here
                        child: Image.asset(
                          "assets/images/🧚🏼_♀️.jpeg",
                          fit: BoxFit
                              .cover, // Ensures the image fits within the rounded container
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.playlistName,
                          style: const TextStyle(
                              color: AppGradients.whiteColor,
                              decoration: TextDecoration.none,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                            playlistSongs!.length == 1
                                ? "song: ${playlistSongs!.length}"
                                : "songs: ${playlistSongs!.length}",
                            style: const TextStyle(
                                color: AppGradients.whiteColor,
                                decoration: TextDecoration.none,
                                fontSize: 12,
                                fontWeight: FontWeight.w300))
                      ],
                    ),
                  ]),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            PlaylistEditor.showEditDialog(
                              context: context,
                              currentPlaylistName: widget.playlistName,
                              onPlaylistRenamed: (newName) {
                                setState(() {
                                  widget.playlistName = newName;
                                });
                                _loadSongs();
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: AppGradients.whiteColor,
                          )),
                      const SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ]),
        ),
        Expanded(
          child: playlistSongs!.isEmpty
              ? const Center(
                  child: Text(
                    "No Songs Added",
                    style:
                        TextStyle(color: AppGradients.whiteColor, fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: playlistSongs?.length,
                  itemBuilder: (context, index) {
                    final songs = playlistSongs!.reversed.toList();
                    final song = songs[index];
                    return SongListTile(
                      song: song,
                      index: index,
                      onTap: () {
                        SongNavigationHelper.navigateToPlayScreen(
                            context: context,
                            boxValues: playlistSongs!,
                            index: index);
                      },
                      onOptionsPressed: () {
                        SongOptionsHelper.showOptionsBottomSheet(
                            context: context, song: song);
                      },
                    );
                  },
                ),
        )
      ]),
    );
  }
}
