// // song_database.dart

// import 'package:hive/hive.dart';
// import 'package:musicapp/music_app/hive1/all_songs.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// // Import your AllSongs class

// class SongDatabase {
//   Box<AllSongs>? songBox;

//   Future<void> initDatabase() async {
//     songBox = await Hive.openBox<AllSongs>('all_audio_data');
//   }

//   Future<void> fetchAndStoreSongs(OnAudioQuery audioQuery) async {
//     try {
//       List<SongModel> songs = await audioQuery.querySongs();
//       List<AllSongs> hiveSongs = songs.map((song) {
//         return AllSongs(
//           id: song.id,
//           tittle: song.displayNameWOExt,
//           artist: song.artist.toString(),
//           uri: song.uri.toString(),
//         );
//       }).toList();

//       await songBox!.clear();
//       await songBox!.addAll(hiveSongs);
//     } catch (e) {
//       print("Error fetching or storing songs: $e");
//     }
//   }

//   List<AllSongs> getAllSongs() {
//     return songBox?.values.toList() ?? [];
//   }

//   void closeDatabase() {
//     songBox?.close();
//   }
// }
