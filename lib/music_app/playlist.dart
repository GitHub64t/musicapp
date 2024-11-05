import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicapp/music_app/add_to.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';
import 'package:musicapp/music_app/hive1/creating_playlist.dart';

import 'package:musicapp/music_app/play.dart';
import 'package:musicapp/music_app/playlist_listscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Playlist extends StatefulWidget {
   String playlistName;
   Playlist({super.key, required this.playlistName});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  List<AllSongs>? playlistSongs;

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
              gradient: LinearGradient(
            colors: [
              Color(0xff704BBE),
              Color(0xff43297A),
              Color(0xff19093B),
              Colors.black
            ],
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter,
          )),
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
                      color: Colors.white,
                    )),
                const Text("Playlists",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
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
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 91, 55, 168),
                    Color(0xff351F64),
                    Color(0xff1E0D43)
                  ], end: Alignment.bottomCenter, begin: Alignment.topCenter)),
              height: 120,
              width: 370,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent),
                      child: const Center(
                        child: Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   width: 15,
                    // ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.playlistName,
                          style: const TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                               maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                  
                            
                        ),
                        Text("Songs: ${playlistSongs!.isNotEmpty ? playlistSongs?.length : 0}",
                            style: const TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: 12,
                                fontWeight: FontWeight.w300))
                      ],
                    ),
                  ]),

                  Row(
                    children: [
                      IconButton(
                          onPressed: _edit,
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     const SizedBox(
                  //       width: 10,
                  //     ),
                  //     IconButton(
                  //         onPressed:_edit,
                  //         icon: const Icon(
                  //           Icons.edit,
                  //           color: Colors.white,
                  //         )),

                  //     const SizedBox(
                  //       width: 20,
                  //     )
                  //   ],
                  // )
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
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: playlistSongs?.length,
                  itemBuilder: (context, index) {
                    final song = playlistSongs![index];
                    return ListTile(
                      onTap: () {
                        // Create a list of MediaItems from favorites
                        List<MediaItem> favoriteSongs =
                            playlistSongs!.map((favorite) {
                          return MediaItem(
                            id: favorite.uri,
                            title: favorite.tittle,
                            artist: favorite.artist,
                            album: favorite.id.toString(),
                          );
                        }).toList();

                        // Navigate to the Play screen and pass the favorite songs list and the selected index
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Play(
                              songs: favoriteSongs,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                      title: Text(
                        song.tittle,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        song.artist,
                        style: const TextStyle(color: Colors.white),
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
                          icon:
                              const Icon(Icons.more_vert, color: Colors.white),
                          onPressed: () {}
                          // _showOptionsBottomSheet(context, , index),
                          ),
                    );
                  },
                ),
        )
      ]),
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 33, 32, 32),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'song name',
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons.music_note,
                  color: Colors.white,
                ),
                subtitle: Text(
                  "singername",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
              const Divider(
                thickness: 0.4,
              ),
              ListTile(
                leading: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.white,
                ),
                title: const Text(
                  'Remove from this playlist',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Handle Option 2 action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                      'Remove from this playlist',
                      style: TextStyle(color: Colors.white),
                    )),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                ),
                title: const Text(
                  'add to playlist',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddTo()));
                  // Handle Option 3 action
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('')),
                  // );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _edit() {
    String newPlaylistName = widget.playlistName;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Playlist Name'),
          content: TextField(
            onChanged: (value) {
              newPlaylistName = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter new playlist name',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                if (newPlaylistName.isNotEmpty &&
                    newPlaylistName != widget.playlistName) {
                  final playlistNamesBox =
                      await Hive.openBox<String>('playlistNames');
                  final index = playlistNamesBox.values
                      .toList()
                      .indexOf(widget.playlistName);

                  if (index != -1) {
                    // Update playlist name in playlistNames box
                    await playlistNamesBox.putAt(index, newPlaylistName);

                    // Rename playlist box
                    final oldBox =
                        await Hive.openBox<AllSongs>(widget.playlistName);
                    final newBox =
                        await Hive.openBox<AllSongs>(newPlaylistName);

                    // Copy songs to new box
                    await newBox.addAll(oldBox.values);

                    // Delete the old box
                    await oldBox.deleteFromDisk();

                    setState(() {
                      widget.playlistName = newPlaylistName;
                      playlistSongs = newBox.values.toList();
                    });
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
