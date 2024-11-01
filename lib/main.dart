import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:musicapp/music_app/hive1/all_songs.dart';
import 'package:musicapp/music_app/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.initFlutter();
  Hive.registerAdapter(AllSongsAdapter());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home:  SplashScreen(),
    );
  }
}
