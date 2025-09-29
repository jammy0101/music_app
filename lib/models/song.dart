
import 'package:hive/hive.dart';

part 'song.g.dart';

@HiveType(typeId: 0)
class Song {
  @HiveField(0)
  final String songName;

  @HiveField(1)
  final String artistName;

  @HiveField(2)
  final String albumArtImagePath;

  @HiveField(3)
  final String audioPath;

  Song({
    required this.songName,
    required this.artistName,
    required this.albumArtImagePath,
    required this.audioPath,
  });
}
