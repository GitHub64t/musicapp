import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';
import 'package:musicapp/widgets/appgraient.dart';

class AddTo extends StatefulWidget {
  final AllSongs? song;

  const AddTo({super.key, this.song});

  @override
  State<AddTo> createState() => _AddToState();
}

class _AddToState extends State<AddTo> {
  List<String> playlists = [];
  Box<String>? playlistNamesBox;

  @override
  void initState() {
    super.initState();
    _openPlaylistNamesBox();
  }

  Future<void> _openPlaylistNamesBox() async {
    playlistNamesBox = await Hive.openBox<String>('playlistNames');
    setState(() {
      playlists = playlistNamesBox!.values.toList();
    });
  }

  Future<bool> _isSongInPlaylist(String playlistName) async {
    final playlistBox = await Hive.openBox<AllSongs>(playlistName);
    return playlistBox.values.any((song) => song.id == widget.song?.id);
  }

  Future<void> _addSongToPlaylist(String playlistName) async {
    if (widget.song != null) {
      final playlistBox = await Hive.openBox<AllSongs>(playlistName);
      await playlistBox.add(widget.song!);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Song added to $playlistName')),
      );
      setState(() {}); 
    }
  }

  Future<void> _removeSongFromPlaylist(String playlistName) async {
    final playlistBox = await Hive.openBox<AllSongs>(playlistName);
    final songIndex = playlistBox.values.toList().indexWhere((song) => song.id == widget.song?.id);
    if (songIndex != -1) {
      await playlistBox.deleteAt(songIndex);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Song removed from $playlistName')),
      );
      setState(() {}); 
    }
  }

  void _addPlaylist() {
    String newPlaylistName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create new Playlist'),
          content: TextField(
            onChanged: (value) {
              newPlaylistName = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter playlist name',
              hintStyle: TextStyle(color: Color.fromARGB(221, 122, 122, 122)),
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
              child: const Text('Add'),
              onPressed: () async {
                if (newPlaylistName.isNotEmpty) {
                  await Hive.openBox<AllSongs>(newPlaylistName);
                  playlistNamesBox?.add(newPlaylistName);
                  setState(() {
                    playlists.add(newPlaylistName);
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient:  AppGradients.thirdGradient
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              title: const Text(
                "Add to Playlist",
                style: TextStyle(color:AppGradients.whiteColor, fontSize: 25, fontWeight: FontWeight.w600),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: AppGradients.whiteColor,),
              ),
            ),
            const SizedBox(height: 20,),
               SizedBox(
                height: 80,
                width: 80,
                child: Image.asset(
                  "assets/images/logo.png",
                )),
             const SizedBox(height: 10,),   
           const Padding(
              padding:  EdgeInsets.all(20),
              child:  Text(
                          "If you want to add a new playlist, press the button below.",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppGradients.whiteColor,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
            ),
            ElevatedButton(
              onPressed: _addPlaylist,
              child: const Text("New Playlist",style: TextStyle(color: Colors.black)),
            ),
           // const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final playlistName = playlists[index];
                  return FutureBuilder<bool>(
                    future: _isSongInPlaylist(playlistName),
                    builder: (context, snapshot) {
                      final isInPlaylist = snapshot.data ?? false;
                      return ListTile(
                        title: Text(
                          playlistName,
                          style: const TextStyle(color: AppGradients.whiteColor,),
                        ),
                        leading: const CircleAvatar(child: Icon(Icons.library_music)),
                        trailing: IconButton(
                          icon: Icon(
                            isInPlaylist ? Icons.remove_circle : Icons.add_circle,
                            color: AppGradients.whiteColor,
                          ),
                          onPressed: () {
                            if (isInPlaylist) {
                              _removeSongFromPlaylist(playlistName);
                            } else {
                              _addSongToPlaylist(playlistName);
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Done",style: TextStyle(color: Colors.black),),
            ), const SizedBox(height: 45),
          ],
        ),
      ),
    );
}
}


