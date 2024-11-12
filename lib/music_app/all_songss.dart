import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';
import 'package:musicapp/widgets/appgraient.dart';
import 'package:musicapp/widgets/miniplayer.dart';
import 'package:musicapp/widgets/navigation.dart';
import 'package:musicapp/widgets/options.dart';
import 'package:musicapp/widgets/songListtile.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: camel_case_types
class All_Songs extends StatefulWidget {
  const All_Songs({super.key});

  @override
  State<All_Songs> createState() => _AllSongsState();
}

class _AllSongsState extends State<All_Songs> {
  // Initialize the AudioPlayer
  final AudioPlayer _audioPlayer = AudioPlayer();

  final _audioQuery = OnAudioQuery();
  Box<AllSongs>? songBox;
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  final List<AllSongs> _allSongs = []; // All songs fetched from Hive
  List<AllSongs> _filteredSongs = []; // Filtered songs based on search query

  @override
  void initState() {
    super.initState();
    requestPermissions();
    _searchController.addListener(() {
      _filterSongs(_searchController.text);
    });
  }

  @override
  void dispose() {
    // Dispose the AudioPlayer when it's no longer needed
    _audioPlayer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchAndStoreSongs() async {
    try {
      await Hive.deleteBoxFromDisk('all_audio_data');
      songBox = await Hive.openBox<AllSongs>('all_audio_data');
      List<SongModel> songs = await _audioQuery.querySongs();
      List<AllSongs> hiveSongs = songs.map((song) {
        return AllSongs(
          id: song.id,
          tittle: song.displayNameWOExt,
          artist: song.artist.toString(),
          uri: song.uri.toString(),
        );
      }).toList();

      await songBox!.clear();
      await songBox!.addAll(hiveSongs);

      setState(() {
        _allSongs.addAll(hiveSongs); // Update the _allSongs list
        _filteredSongs = List.from(_allSongs); // Show all songs initially
        _isLoading = false;
      });
    } catch (e) {
      // print("Error fetching or storing songs: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> requestPermissions() async {
    final hasPermission = await _audioQuery.checkAndRequest();
    if (hasPermission) {
      await fetchAndStoreSongs(); // Fetch songs after permission is granted
    } else {
      print("Permission not granted.");
      setState(() {
        _isLoading = false; // Stop loading if permission is not granted
      });
    }
  }

  void _filterSongs(String query) {
    List<AllSongs> results = [];
    if (query.isEmpty) {
      results = List.from(_allSongs); // Reset to all songs
    } else {
      results = _allSongs.where((song) {
        return song.tittle.toLowerCase().contains(query.toLowerCase()) ||
            song.artist.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    setState(() {
      _filteredSongs = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If still loading, show a loading indicator
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Ensure songBox is initialized before accessing it
    if (songBox == null) {
      return const Center(child: Text("Error: songBox is not initialized."));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            decoration:
                const BoxDecoration(gradient: AppGradients.primaryGradient),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back,
                            color: AppGradients.whiteColor),
                      ),
                      const Flexible(
                        child: Text(
                          "All Songs",
                          style: TextStyle(
                            fontSize: 25,
                            color: AppGradients.whiteColor,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 50),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  height: 120,
                  width: 370,
                  child: Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                            gradient: AppGradients.secondaryGradient),
                        child: const Center(
                          child: Icon(
                            Icons.music_note,
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
                            "All Songs",
                            style: TextStyle(
                              color: AppGradients.whiteColor,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                              fontSize: 25,
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
                const SizedBox(height: 10),
              ],
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color.fromARGB(255, 0, 0, 0),
              border: Border.all(
                color: const Color.fromARGB(255, 92, 92, 92),
              ),
            ),
            child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                    hintText: '  Search music...',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 164, 164, 164)),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search, color: Colors.grey),
                    labelStyle: TextStyle(color: Colors.white),
                    fillColor: AppGradients.whiteColor),
                cursorColor: AppGradients.whiteColor),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _filteredSongs.isEmpty && _searchController.text.isNotEmpty
                ? const Center(
                    child: Text(
                      "No Songs Found",
                      style: TextStyle(
                        color: AppGradients.whiteColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _filteredSongs.length,
                    itemBuilder: (context, index) {
                      var song = _filteredSongs[index];
                      return SongListTile(
                        song: song,
                        index: index,
                        onTap: () {
                          SongNavigationHelper.navigateToPlayScreen(
                              context: context,
                              boxValues: _filteredSongs.reversed.toList(),
                              index: index);
                        },
                        onOptionsPressed: () {
                          SongOptionsHelper.showOptionsBottomSheet(
                              context: context, song: song);
                        },
                      );
                    },
                  ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }
}
