// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_songs.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AllSongsAdapter extends TypeAdapter<AllSongs> {
  @override
  final int typeId = 0;

  @override
  AllSongs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllSongs(
      id: fields[0] as int,
      tittle: fields[1] as String,
      artist: fields[2] as String,
      uri: fields[3] as String,
      playCount: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, AllSongs obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tittle)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.uri)
      ..writeByte(4)
      ..write(obj.playCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllSongsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
