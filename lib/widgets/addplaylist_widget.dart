import 'package:flutter/material.dart';
import 'package:musicapp/music_app/add_to.dart';

class AddplaylistWidget {

 void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 33, 32, 32),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'song name',
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons.music_note,
                  color: Colors.white,
                ),
                subtitle: Text(
                  "singername",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
              const Divider(
                thickness: 0.4,
              ),
              ListTile(
                leading: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.white,
                ),
                title: const Text(
                  'Remove from this playlist',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Handle Option 2 action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                      'Remove from this playlist',
                      style: TextStyle(color: Colors.white),
                    )),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                ),
                title: const Text(
                  'add to playlist',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddTo()));
                  // Handle Option 3 action
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('')),
                  // );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}