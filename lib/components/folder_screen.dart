import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../models/playlist_provider.dart';

class FolderScreen extends StatelessWidget {
  final String folderName;

  const FolderScreen({super.key, required this.folderName});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayListProvider>(
      builder: (context, provider, child) {
        final songs = provider.folders[folderName] ?? [];

        return Scaffold(
          appBar: AppBar(title: Text("Folder: $folderName")),
          body: ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return ListTile(
                leading: Image.asset(song.albumArtImagePath, width: 40, height: 40),
                title: Text(song.songName),
                subtitle: Text(song.artistName),
                trailing: IconButton(
                  icon: Icon(Icons.drive_file_move),
                  onPressed: () {
                    _showMoveDialog(context, song, folderName, provider);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
void _showMoveDialog(BuildContext context, Song song, String currentFolder, PlayListProvider provider) {
  showDialog(
    context: context,
    builder: (ctx) {
      final availableFolders = provider.folders.keys.where((f) => f != currentFolder).toList();

      return AlertDialog(
        title: Text("Move '${song.songName}'"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: availableFolders.map((folder) {
            return ListTile(
              title: Text(folder),
              onTap: () {
                provider.moveSongToFolder(currentFolder, folder, song);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      );
    },
  );
}

