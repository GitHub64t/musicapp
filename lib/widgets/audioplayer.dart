import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  // Private constructor
  AudioPlayerService._privateConstructor();

  static final AudioPlayerService _instance = AudioPlayerService._privateConstructor();

  factory AudioPlayerService() {
    return _instance;
  }

  final AudioPlayer player = AudioPlayer(); // Create the AudioPlayer instance
}




