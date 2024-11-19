import 'package:flutter/material.dart';
import 'package:musicapp/music_app/add_to_playlist.dart';
import 'package:musicapp/music_app/hive1/all_songs.dart';
import 'package:musicapp/widgets/appgraient.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongOptionsHelper {
  static void showOptionsBottomSheet({
    required BuildContext context,
    required AllSongs song, // Replace `AllSongs` with the actual type if different
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
                title: Text(
                  song.tittle,
                  style: const TextStyle(color: AppGradients.whiteColor,),
                  maxLines: 1,
        overflow: TextOverflow.ellipsis,
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
                      color: AppGradients.whiteColor,
                    ),
                  ),
                ),
                subtitle: Text(
                  song.artist,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              const Divider(thickness: 0.4),
              ListTile(
                leading: const Icon(Icons.add_rounded,
                    color: AppGradients.whiteColor),
                title: const Text('Add to playlist',
                    style: TextStyle(color: AppGradients.whiteColor)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  AddTo(song: song,)),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

