import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/music_app/add_to.dart';
import 'package:hive/hive.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';
import 'package:musicapp/music_app/play.dart';
import 'package:musicapp/widgets/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Fav extends StatefulWidget {
  const Fav({super.key});

  @override
  State<Fav> createState() => _FavState();
}

class _FavState extends State<Fav> {
  Box<AllSongs>? _favoritesBox;

  @override
  void initState() {
    super.initState();
    _openFavoritesBox();
  }

  Future<void> _openFavoritesBox() async {
    // Open the favorites box
    _favoritesBox = await Hive.openBox<AllSongs>('favorites');
    setState(() {}); // Ensure UI is updated after opening the box
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
              begin: Alignment.topCenter,
            ),
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
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Favorites",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(width: 50),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
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
                          Color(0xff1E0D43),
                        ],
                        end: Alignment.bottomCenter,
                        begin: Alignment.topCenter,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.favorite_border_outlined,
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
                        "Favorites",
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal,
                          fontSize: 35,
                        ),
                      ),
                      Text(
                        "Playlist",
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ]),
        ),
        Expanded(
          child: _favoritesBox == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _favoritesBox!.isEmpty
                  ? const Center(
                      child: Text(
                        "No Favorites Added",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _favoritesBox!.length,
                      itemBuilder: (context, index) {
                       final song = _favoritesBox!.getAt(index);
                      
                        return ListTile(
                           onTap: () {
                            // Create a list of MediaItems from favorites
                            List<MediaItem> favoriteSongs = _favoritesBox!.values.map((favorite) {
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
                            song?.tittle ?? "Unknown Title",
                            style: const TextStyle(color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            song?.artist ?? "Unknown Artist",
                            style: const TextStyle(color: Colors.white),
                          ),
                          leading: QueryArtworkWidget(
                            id: song?.id ?? 1,
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
                            onPressed: () => _showOptionsBottomSheet(context, song, index),
                          ),
                        );
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

  void _showOptionsBottomSheet(BuildContext context, AllSongs? song, int index) {
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
                title: Text(song?.tittle ?? "Unknown Title", style: const TextStyle(color: Colors.white)),
                leading: const Icon(Icons.music_note, color: Colors.white),
                subtitle: Text(song?.artist ?? "Unknown Artist", style: const TextStyle(color: Colors.white70)),
              ),
              const Divider(thickness: 0.4),
              ListTile(
                leading: const Icon(Icons.remove_circle_outline, color: Colors.white),
                title: const Text('Remove from this playlist', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _removeFromFavorites(index);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_rounded, color: Colors.white),
                title: const Text('Add to playlist', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddTo(song:song,)));
                },
              ),
           
            ],
          ),
        );
      },
    );
  }

  void _removeFromFavorites(int index) {
    setState(() {
      _favoritesBox?.deleteAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed from favorites')),
    );
  }
}
