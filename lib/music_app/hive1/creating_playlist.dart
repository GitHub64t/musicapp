import 'package:flutter/material.dart';
import 'package:musicapp/widgets/categorycard.dart';
import 'package:musicapp/widgets/songListtile.dart';
 import 'package:hive/hive.dart';
 import 'package:musicapp/music_app/hive1/playlist_song_screen.dart';




class CreatingPlaylist extends StatefulWidget {
  const CreatingPlaylist({super.key});

  @override
  State<CreatingPlaylist> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<CreatingPlaylist> {
  List<String> playlists = [];

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    final playlistNamesBox = await Hive.openBox<String>('playlistNames');
    setState(() {
      playlists = playlistNamesBox.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Playlists"),
        backgroundColor: const Color.fromARGB(255, 153, 108, 108),
      ),
      body: playlists.isEmpty
          ? const Center(
              child: Text(
                "No Playlists Added",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: playlists.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items per row
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.8, // Adjust to fit the aspect of CategoryCard
                ),
                itemBuilder: (context, index) {
                  return CategoryCard(
                    imageUrl: 'assets/images/adhi..jpeg', // Replace with your asset path
                    title: playlists[index],
                    subtitle: "Playlist",
                    playlist: playlists[index],
                  );
                },
              ),
            ),
    );
  }
}


// class CategoryCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;

//   const CategoryCard({
//     Key? key,
//     required this.imageUrl,
//     required this.title,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Image.asset(
//           imageUrl,
//           width: 100,
//           height: 80,
//           fit: BoxFit.cover,
//         ),
//         const SizedBox(height: 8),
//         Text(
//           title,
//           style: const TextStyle(color: Colors.white),
//         ),
//       ],
//     );
//   }
// }


// class CreatingPlaylist extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF240046), // Background gradient color start
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header with Search Icon
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Browse',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.search, color: Colors.white),
//                     onPressed: () {
//                       // Handle search action
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Category Cards
//               SizedBox(
//                 height: 120,
//               //  child: ListView.builder(itemBuilder: itemBuilder),
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   children: const [  CategoryCard(
//                       imageUrl:'assets/images/adhi..jpeg' , // Replace with your asset"
//                       title: 'Clear Mind',
//                       subtitle: 'Instrumental',
//                     ),
//                       CategoryCard(
//                       imageUrl:'assets/images/madhav1.jpeg' , // Replace with your asset"
//                       title: 'Clear Mind',
//                       subtitle: 'Instrumental',
//                     ),
                    
//                     CategoryCard(
//                       imageUrl:'assets/images/adhi..jpeg' , // Replace with your asset"
//                       title: 'Clear Mind',
//                       subtitle: 'Instrumental',
//                     ),
//                     CategoryCard(
//                       imageUrl: 'assets/images/madhav1.jpeg',
//                       title: 'Urban Mood',
//                       subtitle: 'Hip-Hop',
//                     ),
//                     CategoryCard(
//                       imageUrl: 'assets/images/madhav1.jpeg',
//                       title: 'Summer Days',
//                       subtitle: 'Club Music',
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Recommendations Header
//               const Text(
//                 'Recommendation',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // Song Recommendations List
//               Expanded(
//                 child: ListView(
//                   children:const [
                  
//                     SongListTile(
//                       imageUrl: 'assets/images/madhav1.jpeg',
//                       title: 'Butter',
//                       artist: 'BTS',
//                     ),
//                     SongListTile(
//                       imageUrl: 'assets/images/adhi..jpeg',
//                       title: 'Night Changes',
//                       artist: 'One Direction',
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';


// class  CreatingPlaylist extends StatefulWidget {
//   const CreatingPlaylist({super.key});

//   @override
//   State<CreatingPlaylist> createState() => _PlaylistScreenState();
// }

// class _PlaylistScreenState extends State<CreatingPlaylist> {
//   List<String> playlists = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadPlaylists();
//   }

//   Future<void> _loadPlaylists() async {
//     final playlistNamesBox = await Hive.openBox<String>('playlistNames');
//     setState(() {
//       playlists = playlistNamesBox.values.toList();
//     });
//   }
//     @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("playlists"),
//         backgroundColor: const Color.fromARGB(255, 153, 108, 108),
//       ),
//       body: playlists.isEmpty
//           ? const Center(
//               child: Text(
//                 "No Songs Added",
//                 style: TextStyle(color: Colors.white, fontSize: 18),
//               ),
//             )
//           : Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 color: Colors.blue,
//                       height: 120,
//                 child: ListView.builder(
//                     itemCount:playlists.length,
//                     itemBuilder: (context, index) {
   
                
//                   return  ListView(
                                        
//                                         children:  [  CategoryCard(
//                        imageUrl:'assets/images/adhi..jpeg' , // Replace with your asset"
//                        title:playlists[index],
                       
//                      ),
                                      
                                     
//                     const SizedBox(height: 20),
//                   ]
//                       );
//                       // return SizedBox(
//                       // height: 120,
//                       //               //  child: ListView.builder(itemBuilder: itemBuilder),
//                       // child: ListView(
//                       //   scrollDirection: Axis.horizontal,
//                       //   children:  [  CategoryCard(
//                       //       imageUrl:'assets/images/adhi..jpeg' , // Replace with your asset"
//                       //       title:playlists[index],
                            
//                       //     ),
//                       //   ],
//                       // ),
//                       // );
                   
//                     },
//                   ),
//               ),
//             ],
//           ),
//     );
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     appBar: AppBar(
//   //       title: const Text("Playlists"),
//   //       backgroundColor: Colors.black,
//   //     ),
//   //     body: playlists.isEmpty
//   //         ? const Center(
//   //             child: Text(
//   //               "No Playlists Created",
//   //               style: TextStyle(color: Color.fromARGB(255, 10, 7, 7), fontSize: 18),
//   //             ),
//   //           )
//   //         : ListView.builder(
//   //             itemCount: playlists.length,
//   //             itemBuilder: (context, index) {
//   //               return ListTile(
//   //                 title: Text(
//   //                   playlists[index],
//   //                   style: const TextStyle(color: Color.fromARGB(255, 4, 3, 3)),
//   //                 ),
//   //                 onTap: () => Navigator.push(
//   //                   context,
//   //                   MaterialPageRoute(
//   //                     builder: (context) => PlaylistSongsScreen(playlistName: playlists[index]),
//   //                   ),
//   //                 ),
//   //                 leading: const Icon(Icons.library_music, color: Color.fromARGB(255, 27, 15, 15)),
//   //               );
//   //             },
//   //           ),
//   //   );
//   // }
// }




// class ImageLayout extends StatelessWidget {
//   final String leadingImage;
//   final List<String> otherImages;

//   const ImageLayout({
//     super.key,
//     required this.leadingImage,
//     required this.otherImages,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Leading Image
//         Image.asset(
//           leadingImage,
//           width: double.infinity,
//           height: 200,
//           fit: BoxFit.cover,
//         ),

//         // Row of 4 Smaller Images
//         SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: otherImages.map((image) {
//             return Expanded(
//               child: Image.asset(
//                 image,
//                 width: 100,
//                 height: 100,
//                 fit: BoxFit.cover,
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
