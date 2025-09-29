import 'package:flutter/material.dart';
import 'package:music/models/playlist_provider.dart';
import 'package:music/pages/song_page.dart';
import 'package:music/models/song.dart';
import 'package:provider/provider.dart';

class SongListScreen extends StatelessWidget {
  final String title;
  final List<Song> songs;

  const SongListScreen({super.key, required this.title, required this.songs});

  void _goToSong(BuildContext context, int index) {
    final playlistProvider =
    Provider.of<PlayListProvider>(context, listen: false);

    playlistProvider.currentSongIndex =
        playlistProvider.playList.indexOf(songs[index]);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SongPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlayListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return ListTile(
            title: Text(song.songName,
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle:
            Text(song.artistName, style: const TextStyle(fontSize: 16)),
            leading: CircleAvatar(
              backgroundImage: AssetImage(song.albumArtImagePath),
              radius: 25,
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (valueSelected) {
                if (valueSelected == "favourite") {
                  playlistProvider.toggleFavourite(song);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "favourite",
                  child: Text(playlistProvider.isFavourite(song)
                      ? "Remove from Favourites"
                      : "Add to Favourites"),
                ),
              ],
            ),
            onTap: () => _goToSong(context, index),
          );
        },
      ),
    );
  }
}
