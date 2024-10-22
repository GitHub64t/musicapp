import 'package:flutter/material.dart';

class AddTo extends StatefulWidget {
  
  const AddTo({super.key});

  @override
  State<AddTo> createState() => _AddToState();
}

class _AddToState extends State<AddTo> {
  void _addPlaylist() {
    //  String newPlaylistName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create new Playlist'),
          content: TextField(
            onChanged: (value) {
              // newPlaylistName = value;
            },
            decoration: const InputDecoration(
                hintText: 'Enter playlist name',
                hintStyle:
                    TextStyle(color: Color.fromARGB(221, 122, 122, 122))),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color(0xff663FB9),
            Color(0xff43297A),
            Color(0XFF19093B),
            Colors.black,
            Colors.black
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              title: const Text(
                "Add to playlist",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600),
              ),
              leading: IconButton(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> ))
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
            ),
            const SizedBox(
              height: 100,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    _addPlaylist();
                  },
                  child: const Text("New Playlist")),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 500,
              child: Container(
                height: 500,
                child: ListView(
                  controller: ScrollController(),
                  children: [
                    ListTile(
                      title: const Text(
                        "playlist 1",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        "12 songs",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w200),
                      ),
                      leading: Container(
                        color: Colors.white,
                        width: 60,
                      ),
                      trailing: const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        "playlist 1",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        "12 songs",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w200),
                      ),
                      leading: Container(
                        color: Colors.white,
                        width: 60,
                      ),
                      trailing: const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        "playlist 1",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        "12 songs",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w200),
                      ),
                      leading: Container(
                        color: Colors.white,
                        width: 60,
                      ),
                      trailing: const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        "playlist 1",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        "12 songs",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w200),
                      ),
                      leading: Container(
                        color: Colors.white,
                        width: 60,
                      ),
                      trailing: const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        "playlist 1",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        "12 songs",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w200),
                      ),
                      leading: Container(
                        color: Colors.white,
                        width: 60,
                      ),
                      trailing: const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        "playlist 1",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        "12 songs",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w200),
                      ),
                      leading: Container(
                        color: Colors.white,
                        width: 60,
                      ),
                      trailing: const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        "playlist 1",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        "12 songs",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w200),
                      ),
                      leading: Container(
                        color: Colors.white,
                        width: 60,
                      ),
                      trailing: const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Done")),
          ],
        ),
      ),
    );
  }
}
