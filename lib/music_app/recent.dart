import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';
import 'package:musicapp/widgets/appgraient.dart';
import 'package:musicapp/widgets/miniplayer.dart';
import 'package:musicapp/widgets/navigation.dart';
import 'package:musicapp/widgets/options.dart';
import 'package:musicapp/widgets/songListtile.dart';

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
                        SongOptionsHelper.showOptionsBottomSheet(
                            context: context, song: song);
                      },
                      onTap: () {
                        SongNavigationHelper.navigateToPlayScreen(
                          context: context,
                          boxValues: recentlyPlayedBox!.values.toList(),
                          index: index,
                        );
                      },
                    );
                  }),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: MiniPlayer(),
        ),
      ]),
    );
  }
}
