import 'package:flutter/material.dart';

import 'package:musicapp/music_app/hive1/playlist_song_screen.dart';
import 'package:musicapp/music_app/playlist.dart';


class CategoryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String playlist;
  const CategoryCard({super.key, 
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.playlist
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Playlist(playlistName: playlist)));
      },
      child: Container(
        width: 100,
        
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.4), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold,fontSize: 30),
              ),
              Text(subtitle,
              style:const TextStyle(
                color: Color.fromARGB(221, 200, 200, 200),fontSize: 16
              ) ,
              )

            ],
          ),
        ),
      ),
    );
  }
}
