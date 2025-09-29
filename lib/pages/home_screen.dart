
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music/models/playlist_provider.dart';
import 'package:music/models/song.dart';
import 'package:music/pages/song_page.dart';
import 'package:provider/provider.dart';
import '../components/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final PlayListProvider playlistProvider;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlayListProvider>(context, listen: false);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // 🔥 rebuilds when tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void getToSong(int songIndex, List<Song> sourceList) {
    playlistProvider.currentSongIndex =
        playlistProvider.playList.indexOf(sourceList[songIndex]);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SongPage()),
    );
  }

  // void _showCreateFolderDialog(BuildContext context) {
  //   final TextEditingController folderController = TextEditingController();
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text("Create Folder"),
  //       content: TextField(
  //         controller: folderController,
  //         decoration: const InputDecoration(hintText: "Folder name"),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text("Cancel"),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             if (folderController.text.isNotEmpty) {
  //               Provider.of<PlayListProvider>(
  //                 context,
  //                 listen: false,
  //               ).createFolder(folderController.text.trim());
  //             }
  //             Navigator.pop(context);
  //           },
  //           child: const Text("Create"),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  void _showCreateFolderDialog(BuildContext context) {
    final TextEditingController folderController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create Folder"),
        content: TextField(
          controller: folderController,
          decoration: const InputDecoration(hintText: "Folder name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (folderController.text.isNotEmpty) {
                final folderName = folderController.text.trim();

                Provider.of<PlayListProvider>(
                  context,
                  listen: false,
                ).createFolder(folderName);

                Navigator.pop(context);

                // ✅ Show snackbar confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Folder '$folderName' created successfully 🎉"),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        child: _tabController.index == 0
            ? FloatingActionButton(
          key: const ValueKey("songFAB"),
          onPressed: () => playlistProvider.addSong(context),
          child: const Icon(Icons.add),
        )
            : _tabController.index == 2
            ? FloatingActionButton(
          key: const ValueKey("folderFAB"),
          onPressed: () => _showCreateFolderDialog(context),
          child: const Icon(Icons.create_new_folder),
        )
            : const SizedBox.shrink(key: ValueKey("emptyFAB")),
      ),
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,

        // ✅ Animated Title
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(0, -0.3), // slide down from top
              end: Offset.zero,
            ).animate(animation);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
          child: Text(
            _tabController.index == 0
                ? "🎵 Music App"
                : _tabController.index == 1
                ? "❤️ Favourites"
                : "📂 Folders",
            key: ValueKey(_tabController.index), // important for animation
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // ✅ Animated TabBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: TabBar(
              key: ValueKey(_tabController.index), // triggers rebuild
              controller: _tabController,
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              tabs: const [
                Tab(icon: Icon(Icons.music_note), text: "Playlist"),
                Tab(icon: Icon(Icons.favorite), text: "Favourites"),
                Tab(icon: Icon(Icons.folder), text: "Folders"),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: AnimatedSwitcher(
      //   duration: const Duration(milliseconds: 300),
      //   transitionBuilder: (child, animation) {
      //     final offsetAnimation = Tween<Offset>(
      //       begin: const Offset(0, 1), // starts from bottom
      //       end: Offset.zero,          // ends at normal position
      //     ).animate(animation);
      //
      //     return SlideTransition(
      //       position: offsetAnimation,
      //       child: child,
      //     );
      //   },
      //   child: _tabController.index == 2
      //       ? FloatingActionButton(
      //     key: const ValueKey("folderFAB"),
      //     onPressed: () => _showCreateFolderDialog(context),
      //     child: const Icon(Icons.create_new_folder),
      //   )
      //       : const SizedBox.shrink(key: ValueKey("emptyFAB")),
      // ),

      body: Consumer<PlayListProvider>(
        builder: (context, value, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildSongList(value.playList, value),
              _buildSongList(value.favourites, value),
              _buildFolders(value),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSongList(List<Song> songs, PlayListProvider provider) {
    if (songs.isEmpty) {
      return const Center(
          child: Text("No songs here yet", style: TextStyle(fontSize: 16)));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: songs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final song = songs[index];
        return Card(
          elevation: 3,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            contentPadding:
            const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            // leading: Hero(
            //   tag: song.songName,
            //   child: CircleAvatar(
            //     radius: 28,
            //     backgroundImage: AssetImage(song.albumArtImagePath),
            //   ),
            // ),
            leading: Hero(
              tag: song.songName,
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey[300],
                child: song.albumArtImagePath.isNotEmpty
                    ? ClipOval(
                  child: Image(
                    image: song.albumArtImagePath.startsWith('assets/')
                        ? AssetImage(song.albumArtImagePath)
                        : FileImage(File(song.albumArtImagePath)) as ImageProvider,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.music_note, size: 28),
                  ),
                )
                    : const Icon(Icons.music_note, size: 28),
              ),
            ),
            title: Text(
              song.songName,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: Text(
              song.artistName,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
            trailing: PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onSelected: (valueSelected) {
                if (valueSelected == "favourite") {
                  provider.toggleFavourite(song);
                } else if (valueSelected == "folder") {
                  _showAddToFolderDialog(context, song);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "favourite",
                  child: Text(
                    provider.isFavourite(song)
                        ? "Remove from Favourites"
                        : "Add to Favourites",
                  ),
                ),
                const PopupMenuItem(
                  value: "folder",
                  child: Text("Move to Folder"),
                ),
              ],
            ),
            onTap: () => getToSong(index, songs),
          ),
        );
      },
    );
  }
  Widget _buildFolders(PlayListProvider provider) {
    if (provider.folders.isEmpty) {
      return const Center(
        child: Text("No folders created yet"),
      );
    }

    return ListView(
      children: provider.folders.entries.map((entry) {
        final folderName = entry.key;
        final songs = entry.value;

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
          child: ExpansionTile(
            leading: const Icon(Icons.folder, color: Colors.amber),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  folderName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // 👇 Popup menu for folder actions
                PopupMenuButton<String>(
                  onSelected: (choice) {
                    if (choice == "rename") {
                      _showRenameFolderDialog(context, folderName);
                    } else if (choice == "delete") {
                      _confirmDeleteFolder(context, folderName);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: "rename",
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blue),
                          SizedBox(width: 8),
                          Text("Rename Folder"),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: "delete",
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Delete Folder"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            children: songs.isEmpty
                ? const [
              ListTile(
                title: Text("No songs in this folder"),
              )
            ]
                : songs.map((song) {
              return ListTile(
                title: Text(song.songName),
                subtitle: Text(song.artistName),
                leading: CircleAvatar(
                  backgroundImage: AssetImage(song.albumArtImagePath),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

void _showAddToFolderDialog(BuildContext context, Song song) {
  final folders = Provider.of<PlayListProvider>(context, listen: false)
      .folders
      .keys
      .toList();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Move to Folder"),
      content: folders.isEmpty
          ? const Text("No folders available. Create one first.")
          : Column(
        mainAxisSize: MainAxisSize.min,
        children: folders
            .map(
              (folderName) => ListTile(
            leading: const Icon(Icons.folder),
            title: Text(folderName),
            onTap: () {
              Provider.of<PlayListProvider>(context, listen: false)
                  .addSongToFolder(folderName, song);
              Navigator.pop(context);
            },
          ),
        )
            .toList(),
      ),
    ),
  );
}
void _showRenameFolderDialog(BuildContext context, String oldName) {
  final controller = TextEditingController(text: oldName);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Rename Folder"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: "Enter new folder name"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final newName = controller.text.trim();
            if (newName.isNotEmpty) {
              Provider.of<PlayListProvider>(context, listen: false)
                  .renameFolder(oldName, newName);
            }
            Navigator.pop(context);
          },
          child: const Text("Rename"),
        ),
      ],
    ),
  );
}
void _confirmDeleteFolder(BuildContext context, String folderName) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete Folder"),
      content: Text("Are you sure you want to delete '$folderName'?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<PlayListProvider>(context, listen: false)
                .deleteFolder(folderName);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Delete"),
        ),
      ],
    ),
  );
}