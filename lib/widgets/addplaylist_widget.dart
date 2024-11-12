// import 'package:flutter/material.dart';
// import 'package:musicapp/music_app/add_to.dart';
// import 'package:musicapp/music_app/hive1/all_songs.dart';

// class AddplaylistWidget {
//   static void showOptionsBottomSheet({
//     required AllSongs? song,
//     required BuildContext context,
//     required String songName,
//     required String singerName,
//   }) {
//     showModalBottomSheet(
//       backgroundColor: const Color.fromARGB(255, 33, 32, 32),
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: Text(
//                   songName,
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 leading: const Icon(
//                   Icons.music_note,
//                   color: Colors.white,
//                 ),
//                 subtitle: Text(
//                   singerName,
//                   style: const TextStyle(
//                     color: Colors.white70,
//                   ),
//                 ),
//               ),
//               const Divider(
//                 thickness: 0.4,
//                 color: Colors.white70,
//               ),
//               ListTile(
//                 leading: const Icon(
//                   Icons.remove_circle_outline,
//                   color: Colors.white,
//                 ),
//                 title: const Text(
//                   'Remove from this playlist',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text(
//                         'Removed from playlist',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(
//                   Icons.add_rounded,
//                   color: Colors.white,
//                 ),
//                 title: const Text(
//                   'Add to playlist',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => AddTo(song: song,)),
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }


// }

