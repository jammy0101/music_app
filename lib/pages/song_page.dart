import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/components/neu_box.dart';
import 'package:music/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayListProvider>(
      builder: (context, value, child) {
        final playlist = value.playList;
        final currentIndex = value.currentSongIndex ?? 0;
        if (playlist.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("No songs in playlist")),
          );
        }

        final currentSong = playlist[currentIndex];

        String formatTime(Duration duration) {
          String twoDigits(int n) => n.toString().padLeft(2, '0');
          final minutes = twoDigits(duration.inMinutes);
          final seconds = twoDigits(duration.inSeconds.remainder(60));
          return "$minutes:$seconds";
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🔙 Top Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const Text(
                          'P L A Y L I S T',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 🎵 Album Artwork
                    // NeuBox(
                    //   child: Column(
                    //     children: [
                    //       ClipRRect(
                    //         borderRadius: BorderRadius.circular(8),
                    //         child: SizedBox(
                    //           height: 250,
                    //           width: double.infinity,
                    //           child: currentSong.albumArtImagePath.startsWith('assets/')
                    //               ? Image.asset(currentSong.albumArtImagePath, fit: BoxFit.cover)
                    //               : Image.file(File(currentSong.albumArtImagePath), fit: BoxFit.cover),
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Expanded(
                    //               child: Column(
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Text(
                    //                     currentSong.songName,
                    //                     style: const TextStyle(
                    //                       fontWeight: FontWeight.bold,
                    //                       fontSize: 20,
                    //                     ),
                    //                     maxLines: 1,
                    //                     overflow: TextOverflow.ellipsis,
                    //                   ),
                    //                   Text(currentSong.artistName),
                    //                 ],
                    //               ),
                    //             ),
                    //             Icon(Icons.favorite,
                    //                 color: value.isFavourite(currentSong)
                    //                     ? Colors.red
                    //                     : Colors.grey),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    NeuBox(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              height: 250,
                              width: double.infinity,
                              child: currentSong.albumArtImagePath.startsWith('assets/')
                                  ? Image.asset(
                                currentSong.albumArtImagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Center(
                                  child: Icon(Icons.music_note,
                                      size: 100, color: Colors.grey),
                                ),
                              )
                                  : Image.file(
                                File(currentSong.albumArtImagePath),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Center(
                                  child: Icon(Icons.music_note,
                                      size: 100, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentSong.songName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(currentSong.artistName),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.favorite,
                                  color: value.isFavourite(currentSong)
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ⏱ Duration + Slider
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(formatTime(value.currentDuration)),
                              const Icon(Icons.shuffle),
                              const Icon(Icons.repeat),
                              Text(formatTime(value.totalDuration)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          ),
                          child: Slider(
                            min: 0,
                            max: value.totalDuration.inSeconds.toDouble(),
                            value: value.currentDuration.inSeconds
                                .toDouble()
                                .clamp(0, value.totalDuration.inSeconds.toDouble()),
                            activeColor: Colors.green,
                            onChanged: (double position) {},
                            onChangeEnd: (double newPosition) {
                              value.seek(Duration(seconds: newPosition.toInt()));
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ▶️ Controls
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: value.playPreviousSong,
                            child: const NeuBox(child: Icon(Icons.skip_previous)),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: value.pauseOrResume,
                            child: NeuBox(
                              child: Icon(
                                  value.isPlaying ? Icons.pause : Icons.play_arrow),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: value.playNextSong,
                            child: const NeuBox(child: Icon(Icons.skip_next)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
