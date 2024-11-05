import 'package:hive/hive.dart';

part 'all_songs.g.dart';

@HiveType(typeId: 0) // Use a unique type ID
class AllSongs {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String tittle;

  @HiveField(2)
  final String artist;
   
  @HiveField(3)
  final String uri;

  @HiveField(4)
  int? playCount;
  
  AllSongs({required this.id, required this.tittle, required this.artist,required this.uri,this.playCount});
}
