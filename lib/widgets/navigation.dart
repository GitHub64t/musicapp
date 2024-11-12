// Helper class for navigation
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/music_app/play.dart';

class SongNavigationHelper {
  static void navigateToPlayScreen({
    required BuildContext context,
    required List<dynamic> boxValues, // Replace with actual type
    required int index,
  }) {
    List<MediaItem> song = boxValues
        .map((item) => MediaItem(
              id: item.uri,
              title: item.tittle,
              artist: item.artist,
              album: item.id.toString(),
            ))
        .toList()
        .reversed
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Play(
          songs: song,
          initialIndex: index,
          currentPosition: Duration.zero,
        ),
      ),
    );
  }
}
