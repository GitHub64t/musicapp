// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:musicapp/widgets/appgraient.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongListTile extends StatelessWidget {
  final dynamic song; // Replace with your actual song type
  final int index;
  final VoidCallback onTap;
  final VoidCallback? onOptionsPressed;

  const SongListTile({
    super.key,
    required this.song,
    required this.index,
    required this.onTap,
    this.onOptionsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        song.tittle,
        style: const TextStyle(color: AppGradients.whiteColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
      subtitle: Text(
        song.artist,
        style: const TextStyle(color: Colors.white60),
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
      trailing: IconButton(
        icon: const Icon(Icons.more_vert, color: AppGradients.whiteColor),
        onPressed: onOptionsPressed,
      ),
    );
  }
}
