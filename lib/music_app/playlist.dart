import 'package:flutter/material.dart';
import 'package:musicapp/music_app/add_to.dart';
import 'package:musicapp/music_app/home_screen.dart';


class Playlist extends StatefulWidget {
  const Playlist({super.key});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff6A42BF), Color(0xff271748), Colors.black],
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter)),
          child: Column(children: [
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>const HomeScreen()));
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                const Text("Playlists",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none)),
                const SizedBox(
                  width: 50,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 91, 55, 168),
                    Color(0xff351F64),
                    Color(0xff1E0D43)
                  ], end: Alignment.bottomCenter, begin: Alignment.topCenter)),
              height: 120,
              width: 370,
              child: Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent),
                    child:const Center(
                      child: Icon(
                        Icons.music_note,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Playlist 1 ",
                        style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      Text("Songs 11   ",
                          style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: 12,
                              fontWeight: FontWeight.w300))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 70,
                      ),
                      IconButton(
                          onPressed: _edit,
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ]),
        ),
        Expanded(
            child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) =>const Play()),
            // );
          },
          title:const Text(
            "song name",
            style: TextStyle(color: Colors.white),
          ),
          subtitle:
            const  Text("Unknown Artist", style: TextStyle(color: Colors.white)),
          leading:const Icon(
            Icons.music_note,
            color: Colors.white,
          ),
          trailing: IconButton(
            icon:const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () => _showOptionsBottomSheet(context),
          ),
        );
                  },
                ))
      ]),
    );
  }
  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 33, 32, 32),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding:const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            const  ListTile(
                title: Text('song name',style: TextStyle(color: Colors.white),),
                leading: Icon(Icons.music_note,color: Colors.white,),
                subtitle: Text("singername",style: TextStyle(color:Colors.white70,),),
              
               
              ),
            const  Divider( thickness: 0.4,
              
              ),
              ListTile(
                leading:const Icon(Icons.remove_circle_outline,color: Colors.white,),
                title:const Text('Remove from this playlist',style: TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.of(context).pop();
                  // Handle Option 2 action
                  ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Remove from this playlist',style: TextStyle(color: Colors.white),)),
                  );
                },
              ),
              ListTile(
                leading:const Icon(Icons.add_rounded,color: Colors.white,),
                title:const Text('add to playlist',style: TextStyle(color: Colors.white),),
                onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddTo()));
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
   void _edit() {
   // TextEditingController nameController = TextEditingController(text: name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Name'),
          content: TextField(
          //  controller: nameController,
            decoration: InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without saving
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // setState(() {
                //   name = nameController.text; // Save the new name
                // });
                Navigator.pop(context); // Close the dialog after saving
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
