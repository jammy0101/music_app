import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../models/playlist_provider.dart';
import '../models/song.dart';
/// Screen to show songs inside a folder or favourites
class FolderSongsScreen extends StatelessWidget {
  final String folderName;
  final List<Song> songs;

  const FolderSongsScreen({
    super.key,
    required this.folderName,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlayListProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(folderName)),
      body: songs.isEmpty
          ? const Center(child: Text("No songs in this folder"))
          : ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return ListTile(
            title: Text(song.songName),
            subtitle: Text(song.artistName),
            leading: CircleAvatar(
              backgroundImage: AssetImage(song.albumArtImagePath),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                provider.folders[folderName]?.remove(song);
                provider.notifyListeners();
              },
            ),
          );
        },
      ),
    );
  }
}