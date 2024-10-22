import 'package:flutter/material.dart';
import 'package:musicapp/music_app/add_to.dart';


class Recent extends StatefulWidget {
  const Recent({super.key});

  @override
  State<Recent> createState() => _RecentState();
}

class _RecentState extends State<Recent> {
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
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                const Text("Recents",
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
              decoration: const BoxDecoration(color: Colors.transparent),
              height: 120,
              width: 370,
              child: Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          Color.fromARGB(255, 91, 55, 168),
                          Color(0xff351F64),
                          Color(0xff1E0D43)
                        ],
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter)),
                    child: const Center(
                      child: Icon(
                        Icons.skip_previous_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recently Played",
                        style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                            fontSize: 25),
                      ),
                      Text("Playlist",
                          style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: 20,
                              fontWeight: FontWeight.w200))
                    ],
                  ),
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
            //   MaterialPageRoute(builder: (context) => const Play()),
            // );
          },
          title: const Text(
            "song name",
            style: TextStyle(color: Colors.white),
          ),
          subtitle: const Text("Unknown Artist",
              style: TextStyle(color: Colors.white)),
          leading: const Icon(
            Icons.music_note,
            color: Colors.white,
          ),
          trailing: IconButton(
            icon: const Icon(
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
}
