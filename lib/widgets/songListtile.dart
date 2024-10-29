import 'package:flutter/material.dart';

class SongListTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String artist;

  const SongListTile({super.key, 
    required this.imageUrl,
    required this.title,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        decoration:BoxDecoration(
     borderRadius: BorderRadius.circular(8.0),
        ) ,
   
        child: Image.asset(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        artist,
        style: const TextStyle(color: Colors.white70),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert, color: Colors.white),
        onPressed: () {
          // Handle more actions
        },
      ),
    );
  }
}