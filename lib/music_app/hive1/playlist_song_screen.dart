import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';

class PlaylistSongsScreen extends StatefulWidget {
  final String playlistName;

  const PlaylistSongsScreen({super.key, required this.playlistName});

  @override
  State<PlaylistSongsScreen> createState() => _PlaylistSongsScreenState();
}

class _PlaylistSongsScreenState extends State<PlaylistSongsScreen> {
  List<AllSongs> playlistSongs = [];

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
      appBar: AppBar(
        title: Text(widget.playlistName),
        backgroundColor: Colors.black,
      ),
      body: playlistSongs.isEmpty
          ? const Center(
              child: Text(
                "No Songs Added",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: playlistSongs.length,
              itemBuilder: (context, index) {
                final song = playlistSongs[index];
                return ListTile(
                  title: Text(song.tittle),
                  subtitle: Text(playlistSongs[index].artist),
                );
              },
            ),
    );
  }
}
