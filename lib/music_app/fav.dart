import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';
import 'package:musicapp/widgets/appgraient.dart';
import 'package:musicapp/widgets/bottombar_option.dart';
import 'package:musicapp/widgets/miniplayer.dart';
import 'package:musicapp/widgets/navigation.dart';
import 'package:musicapp/widgets/songListtile.dart';

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
                  ),
                ),
                const Text(
                  "Favorites",
                  style: TextStyle(
                    fontSize: 20,
                    color: AppGradients.whiteColor,
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
                      gradient: AppGradients.secondaryGradient,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.favorite_border_outlined,
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
                        "Favorites",
                        style: TextStyle(
                          color: AppGradients.whiteColor,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal,
                          fontSize: 35,
                        ),
                      ),
                      Text(
                        "Playlist",
                        style: TextStyle(
                          color: AppGradients.whiteColor,
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
                        style: TextStyle(
                            color: AppGradients.whiteColor, fontSize: 20),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _favoritesBox!.length,
                      itemBuilder: (context, index) {
                        final songs =
                            _favoritesBox!.values.toList().reversed.toList();
                        final reversedIndex = _favoritesBox!.length - 1 - index;
                        final song = songs[index];
                        //    final song = _favoritesBox!.getAt(index);
                        //  final  songs = song(index)
                        return SongListTile(
                            song: song,
                            index: index,
                            onOptionsPressed: () {
                              SongOptionsHelper2.showOptionsBottomSheet(
                                context: context,
                                song: song,
                                index: reversedIndex,
                                removeCallback: _removeFromFavorites,
                              );
                            },
                            onTap: () {
                              SongNavigationHelper.navigateToPlayScreen(
                                  context: context,
                                  index: index,
                                  boxValues: _favoritesBox!.values.toList());
                            });
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

  void _removeFromFavorites(int index) {
    setState(() {
      _favoritesBox?.deleteAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed from favorites')),
    );
  }
}
