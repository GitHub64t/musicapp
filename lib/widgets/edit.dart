import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';

class PlaylistEditor {
  static Future<void> showEditDialog({
    required BuildContext context,
    required String currentPlaylistName,
    required Function(String) onPlaylistRenamed,
  }) async {
    String newPlaylistName = currentPlaylistName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Playlist Name'),
          content: TextField(
            onChanged: (value) {
              newPlaylistName = value;
            },
            decoration: InputDecoration(
              hintText:  currentPlaylistName,
              
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
                    newPlaylistName != currentPlaylistName) {
                  final playlistNamesBox =
                      await Hive.openBox<String>('playlistNames');
                  final index = playlistNamesBox.values
                      .toList()
                      .indexOf(currentPlaylistName);

                  if (index != -1) {
                    // Update playlist name in playlistNames box
                    await playlistNamesBox.putAt(index, newPlaylistName);

                    // Rename playlist box
                    final oldBox =
                        await Hive.openBox<AllSongs>(currentPlaylistName);
                    final newBox =
                        await Hive.openBox<AllSongs>(newPlaylistName);

                    // Copy songs to new box
                    await newBox.addAll(oldBox.values);

                    // Delete the old box
                    await oldBox.deleteFromDisk();

                    // Call callback to update UI
                    onPlaylistRenamed(newPlaylistName);

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
