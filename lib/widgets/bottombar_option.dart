import 'package:flutter/material.dart';
import 'package:musicapp/music_app/add_to_playlist.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';
import 'package:musicapp/widgets/appgraient.dart';
class SongOptionsHelper2 {
  static void showOptionsBottomSheet({
    required BuildContext context,
    required AllSongs? song,
    required int index,
    required void Function(int) removeCallback,  // Ensure the callback expects an integer (index)
  }) {
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
                title: Text(song?.tittle ?? "Unknown Title",
                    style: const TextStyle(color: Colors.white),
                    maxLines: 1,
        overflow: TextOverflow.ellipsis,),
                leading: const Icon(Icons.music_note,
                    color: AppGradients.whiteColor),
                subtitle: Text(song?.artist ?? "Unknown Artist",
                    style: const TextStyle(color: Colors.white70)),
              ),
              const Divider(thickness: 0.4),
              ListTile(
                leading: const Icon(Icons.remove_circle_outline,
                    color: AppGradients.whiteColor),
                title: const Text('Remove from this playlist',
                    style: TextStyle(color: AppGradients.whiteColor)),
                onTap: () {
                  removeCallback(index); // Call the callback when tapped
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_rounded,
                    color: AppGradients.whiteColor),
                title: const Text('Add to playlist',
                    style: TextStyle(color: AppGradients.whiteColor)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddTo(
                                song: song,
                              )));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}