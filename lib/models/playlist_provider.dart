// //
// // import 'package:audioplayers/audioplayers.dart';
// // import 'package:file_picker/file_picker.dart';
// // import 'package:flutter/material.dart';
// // import 'package:hive/hive.dart';
// // import 'song.dart';
// //
// // class PlayListProvider extends ChangeNotifier {
// //   // Hive boxes
// //   late Box<Song> _songsBox;
// //   late Box<Song> _favouritesBox;
// //   late Box<List> _foldersBox;
// //
// //   // Playlist (dynamic, loaded from Hive)
// //   List<Song> _playList = [];
// //   List<Song> get playList => _playList;
// //
// //   int? _currentSongIndex;
// //
// //   int? get currentSongIndex => _currentSongIndex;
// //
// //   set currentSongIndex(int? newIndex) {
// //     _currentSongIndex = newIndex;
// //     if (newIndex != null) {
// //       play();
// //     }
// //     notifyListeners();
// //   }
// //
// //   // Favourites
// //   List<Song> _favourites = [];
// //   List<Song> get favourites => _favourites;
// //
// //   // Folders
// //   Map<String, List<Song>> _folders = {};
// //   Map<String, List<Song>> get folders => _folders;
// //
// //   // Audio Player
// //   final AudioPlayer _audioPlayer = AudioPlayer();
// //
// //   // Durations
// //   Duration _currentDuration = Duration.zero;
// //   Duration _totalDuration = Duration.zero;
// //
// //   bool _isPlaying = false;
// //
// //   bool get isPlaying => _isPlaying;
// //   Duration get currentDuration => _currentDuration;
// //   Duration get totalDuration => _totalDuration;
// //
// //   // Constructor
// //   PlayListProvider() {
// //     _initHive();
// //     listenToDuration();
// //   }
// //
// //   Future<void> _initHive() async {
// //     _songsBox = await Hive.openBox<Song>('songsBox');
// //     _favouritesBox = await Hive.openBox<Song>('favouritesBox');
// //     _foldersBox = await Hive.openBox<List>('foldersBox');
// //
// //     // Load songs from Hive
// //     _playList = _songsBox.values.toList();
// //
// //     // Load favourites
// //     _favourites = _favouritesBox.values.toList();
// //
// //     // Load folders
// //     final storedFolders = _foldersBox.toMap();
// //     _folders = storedFolders.map((key, value) {
// //       return MapEntry(key.toString(), value.cast<Song>());
// //     });
// //
// //     notifyListeners();
// //   }
// //
// //   /*
// //    * 🎵 SONG MANAGEMENT
// //    */
// //   Future<void> addSong(BuildContext context) async {
// //     final result = await FilePicker.platform.pickFiles(
// //       type: FileType.custom,
// //       allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'flac'],
// //     );
// //
// //     if (result != null && result.files.isNotEmpty) {
// //       final file = result.files.first;
// //
// //       // extra validation (just in case)
// //       final ext = file.extension?.toLowerCase();
// //       if (ext == null || !['mp3', 'wav', 'm4a', 'aac', 'flac'].contains(ext)) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("⚠️ Unsupported file type. Please select an audio file.")),
// //         );
// //         return;
// //       }
// //
// //       final newSong = Song(
// //         songName: file.name,
// //         artistName: "Unknown",
// //         albumArtImagePath: 'assets/images/default.jpg',
// //         audioPath: file.path!, // full path on device
// //       );
// //
// //       _playList.add(newSong);
// //       await _songsBox.put(newSong.songName, newSong);
// //
// //       notifyListeners();
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("🎵 Added: ${file.name}")),
// //       );
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("❌ No file selected")),
// //       );
// //     }
// //   }
// //
// //
// //   // Future<void> addSong() async {
// //   //   final result = await FilePicker.platform.pickFiles(type: FileType.audio);
// //   //
// //   //   if (result != null && result.files.isNotEmpty) {
// //   //     final file = result.files.first;
// //   //
// //   //     final newSong = Song(
// //   //       songName: file.name,
// //   //       artistName: "Unknown",
// //   //       albumArtImagePath: 'assets/images/default.jpg',
// //   //       audioPath: file.path!, // full path on device
// //   //     );
// //   //
// //   //     _playList.add(newSong);
// //   //     await _songsBox.put(newSong.songName, newSong);
// //   //
// //   //     notifyListeners();
// //   //   }
// //   // }
// //
// //   Future<void> deleteSong(Song song) async {
// //     _playList.remove(song);
// //
// //     // remove from favourites & hive
// //     _favourites.remove(song);
// //     if (_favouritesBox.isOpen) await _favouritesBox.delete(song.songName);
// //
// //     // remove from playlist hive
// //     if (_songsBox.isOpen) await _songsBox.delete(song.songName);
// //
// //     // remove from folders
// //     for (final folderName in _folders.keys.toList()) {
// //       final list = _folders[folderName]!;
// //       if (list.remove(song)) {
// //         if (_foldersBox.isOpen) await _foldersBox.put(folderName, list);
// //       }
// //     }
// //
// //     notifyListeners();
// //   }
// //
// //   // Toggle favourite
// //   void toggleFavourite(Song song) {
// //     if (_favourites.contains(song)) {
// //       _favourites.remove(song);
// //       _favouritesBox.delete(song.songName);
// //     } else {
// //       _favourites.add(song);
// //       _favouritesBox.put(song.songName, song);
// //     }
// //     notifyListeners();
// //   }
// //
// //   bool isFavourite(Song song) => _favourites.contains(song);
// //
// //   // Create folder
// //   Future<void> createFolder(String folderName) async {
// //     if (!_folders.containsKey(folderName)) {
// //       _folders[folderName] = [];
// //       if (_foldersBox.isOpen) await _foldersBox.put(folderName, <Song>[]);
// //       notifyListeners();
// //     }
// //   }
// //
// //   // Add song to folder
// //   Future<void> addSongToFolder(String folderName, Song song) async {
// //     if (_folders.containsKey(folderName)) {
// //       _folders[folderName]!.add(song);
// //       if (_foldersBox.isOpen) await _foldersBox.put(folderName, _folders[folderName]!);
// //       notifyListeners();
// //     }
// //   }
// //
// //   // Rename folder
// //   Future<void> renameFolder(String oldName, String newName) async {
// //     if (_folders.containsKey(oldName) && !_folders.containsKey(newName)) {
// //       final songs = _folders.remove(oldName)!;
// //       _folders[newName] = songs;
// //       if (_foldersBox.isOpen) {
// //         await _foldersBox.delete(oldName);
// //         await _foldersBox.put(newName, songs);
// //       }
// //       notifyListeners();
// //     }
// //   }
// //
// //   // Delete folder
// //   Future<void> deleteFolder(String folderName) async {
// //     if (_folders.containsKey(folderName)) {
// //       _folders.remove(folderName);
// //       if (_foldersBox.isOpen) await _foldersBox.delete(folderName);
// //       notifyListeners();
// //     }
// //   }
// //
// //   // Move song between folders
// //   Future<void> moveSongToFolder(String fromFolder, String toFolder, Song song) async {
// //     if (_folders.containsKey(fromFolder) && _folders.containsKey(toFolder)) {
// //       _folders[fromFolder]!.remove(song);
// //       _folders[toFolder]!.add(song);
// //       if (_foldersBox.isOpen) {
// //         await _foldersBox.put(fromFolder, _folders[fromFolder]!);
// //         await _foldersBox.put(toFolder, _folders[toFolder]!);
// //       }
// //       notifyListeners();
// //     }
// //   }
// //
// //   /*
// //    * 🎧 AUDIO PLAYER
// //    */
// //   void play() async {
// //     if (_currentSongIndex == null) return;
// //     final Song song = _playList[_currentSongIndex!];
// //
// //     await _audioPlayer.stop();
// //
// //     if (song.audioPath.contains('/')) {
// //       // Local file
// //       await _audioPlayer.play(DeviceFileSource(song.audioPath));
// //     } else {
// //       // Asset file
// //       await _audioPlayer.play(AssetSource("audio/${song.audioPath}"));
// //     }
// //
// //     _isPlaying = true;
// //     notifyListeners();
// //   }
// //
// //   void pause() async {
// //     await _audioPlayer.pause();
// //     _isPlaying = false;
// //     notifyListeners();
// //   }
// //
// //   void resume() async {
// //     await _audioPlayer.resume();
// //     _isPlaying = true;
// //     notifyListeners();
// //   }
// //
// //   void pauseOrResume() async {
// //     if (_isPlaying) {
// //       pause();
// //     } else {
// //       resume();
// //     }
// //   }
// //
// //   void seek(Duration position) async {
// //     await _audioPlayer.seek(position);
// //   }
// //
// //   void playNextSong() {
// //     if (_currentSongIndex != null) {
// //       if (_currentSongIndex! < _playList.length - 1) {
// //         currentSongIndex = _currentSongIndex! + 1;
// //       } else {
// //         currentSongIndex = 0;
// //       }
// //     }
// //   }
// //
// //   void playPreviousSong() {
// //     if (_currentDuration.inSeconds > 2) {
// //       seek(Duration.zero);
// //     } else {
// //       if (_currentSongIndex! > 0) {
// //         currentSongIndex = _currentSongIndex! - 1;
// //       } else {
// //         currentSongIndex = _playList.length - 1;
// //       }
// //     }
// //   }
// //
// //   void listenToDuration() {
// //     _audioPlayer.onDurationChanged.listen((newDuration) {
// //       _totalDuration = newDuration;
// //       notifyListeners();
// //     });
// //
// //     _audioPlayer.onPositionChanged.listen((newPosition) {
// //       _currentDuration = newPosition;
// //       notifyListeners();
// //     });
// //
// //     _audioPlayer.onPlayerComplete.listen((event) {
// //       playNextSong();
// //     });
// //   }
// // }
// import 'package:audioplayers/audioplayers.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'song.dart';
//
// class PlayListProvider extends ChangeNotifier {
//   // Hive boxes
//   late Box<Song> _songsBox;
//   late Box<Song> _favouritesBox;
//   late Box<List> _foldersBox;
//   late Box _settingsBox; // ✅ for current index persistence
//
//   // Playlist
//   List<Song> _playList = [];
//   List<Song> get playList => _playList;
//
//   int? _currentSongIndex;
//   int? get currentSongIndex => _currentSongIndex;
//
//   set currentSongIndex(int? newIndex) {
//     _currentSongIndex = newIndex;
//
//     if (newIndex != null) {
//       // Save to Hive for persistence
//       _settingsBox.put("currentIndex", newIndex);
//       play();
//     }
//
//     notifyListeners();
//   }
//
//   // Favourites
//   List<Song> _favourites = [];
//   List<Song> get favourites => _favourites;
//
//   // Folders
//   Map<String, List<Song>> _folders = {};
//   Map<String, List<Song>> get folders => _folders;
//
//   // Audio Player
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   // Durations
//   Duration _currentDuration = Duration.zero;
//   Duration _totalDuration = Duration.zero;
//
//   bool _isPlaying = false;
//
//   bool get isPlaying => _isPlaying;
//   Duration get currentDuration => _currentDuration;
//   Duration get totalDuration => _totalDuration;
//
//   // Constructor
//   PlayListProvider() {
//     _initHive();
//     listenToDuration();
//   }
//
//   Future<void> _initHive() async {
//     _songsBox = await Hive.openBox<Song>('songsBox');
//     _favouritesBox = await Hive.openBox<Song>('favouritesBox');
//     _foldersBox = await Hive.openBox<List>('foldersBox');
//     _settingsBox = await Hive.openBox('settingsBox');
//
//     // Load songs
//     _playList = _songsBox.values.toList();
//
//     // Load favourites
//     _favourites = _favouritesBox.values.toList();
//
//     // Load folders
//     final storedFolders = _foldersBox.toMap();
//     _folders = storedFolders.map((key, value) {
//       return MapEntry(key.toString(), value.cast<Song>());
//     });
//
//     // Restore last played index
//     _currentSongIndex = _settingsBox.get("currentIndex");
//
//     notifyListeners();
//   }
//
//   /*
//    * 🎵 SONG MANAGEMENT
//    */
//   Future<void> addSong(BuildContext context) async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'flac'],
//     );
//
//     if (result != null && result.files.isNotEmpty) {
//       final file = result.files.first;
//
//       final ext = file.extension?.toLowerCase();
//       if (ext == null || !['mp3', 'wav', 'm4a', 'aac', 'flac'].contains(ext)) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("⚠️ Unsupported file type")),
//         );
//         return;
//       }
//
//       final newSong = Song(
//         songName: file.name,
//         artistName: "Unknown",
//         albumArtImagePath: 'assets/images/default.jpg',
//         audioPath: file.path!, // full device path
//       );
//
//       _playList.add(newSong);
//       await _songsBox.put(newSong.songName, newSong);
//
//       notifyListeners();
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("🎵 Added: ${file.name}")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("❌ No file selected")),
//       );
//     }
//   }
//
//   Future<void> deleteSong(Song song) async {
//     _playList.remove(song);
//
//     // remove from favourites
//     _favourites.remove(song);
//     if (_favouritesBox.isOpen) await _favouritesBox.delete(song.songName);
//
//     // remove from Hive songs
//     if (_songsBox.isOpen) await _songsBox.delete(song.songName);
//
//     // remove from folders
//     for (final folderName in _folders.keys.toList()) {
//       final list = _folders[folderName]!;
//       if (list.remove(song)) {
//         if (_foldersBox.isOpen) await _foldersBox.put(folderName, list);
//       }
//     }
//
//     notifyListeners();
//   }
//
//   // Toggle favourite
//   void toggleFavourite(Song song) {
//     if (_favourites.contains(song)) {
//       _favourites.remove(song);
//       _favouritesBox.delete(song.songName);
//     } else {
//       _favourites.add(song);
//       _favouritesBox.put(song.songName, song);
//     }
//     notifyListeners();
//   }
//
//   bool isFavourite(Song song) => _favourites.contains(song);
//
//   // Folder management
//   Future<void> createFolder(String folderName) async {
//     if (!_folders.containsKey(folderName)) {
//       _folders[folderName] = [];
//       if (_foldersBox.isOpen) await _foldersBox.put(folderName, <Song>[]);
//       notifyListeners();
//     }
//   }
//
//   Future<void> addSongToFolder(String folderName, Song song) async {
//     if (_folders.containsKey(folderName)) {
//       _folders[folderName]!.add(song);
//       if (_foldersBox.isOpen) await _foldersBox.put(folderName, _folders[folderName]!);
//       notifyListeners();
//     }
//   }
//
//   Future<void> renameFolder(String oldName, String newName) async {
//     if (_folders.containsKey(oldName) && !_folders.containsKey(newName)) {
//       final songs = _folders.remove(oldName)!;
//       _folders[newName] = songs;
//       if (_foldersBox.isOpen) {
//         await _foldersBox.delete(oldName);
//         await _foldersBox.put(newName, songs);
//       }
//       notifyListeners();
//     }
//   }
//
//   Future<void> deleteFolder(String folderName) async {
//     if (_folders.containsKey(folderName)) {
//       _folders.remove(folderName);
//       if (_foldersBox.isOpen) await _foldersBox.delete(folderName);
//       notifyListeners();
//     }
//   }
//
//   Future<void> moveSongToFolder(String fromFolder, String toFolder, Song song) async {
//     if (_folders.containsKey(fromFolder) && _folders.containsKey(toFolder)) {
//       _folders[fromFolder]!.remove(song);
//       _folders[toFolder]!.add(song);
//       if (_foldersBox.isOpen) {
//         await _foldersBox.put(fromFolder, _folders[fromFolder]!);
//         await _foldersBox.put(toFolder, _folders[toFolder]!);
//       }
//       notifyListeners();
//     }
//   }
//
//   /*
//    * 🎧 AUDIO PLAYER
//    */
//   void play() async {
//     if (_currentSongIndex == null) return;
//     final Song song = _playList[_currentSongIndex!];
//
//     await _audioPlayer.stop();
//
//     if (song.audioPath.contains('/')) {
//       // Local file
//       await _audioPlayer.play(DeviceFileSource(song.audioPath));
//     } else {
//       // Asset file
//       await _audioPlayer.play(AssetSource("audio/${song.audioPath}"));
//     }
//
//     _isPlaying = true;
//     notifyListeners();
//   }
//
//   void pause() async {
//     await _audioPlayer.pause();
//     _isPlaying = false;
//     notifyListeners();
//   }
//
//   void resume() async {
//     await _audioPlayer.resume();
//     _isPlaying = true;
//     notifyListeners();
//   }
//
//   void pauseOrResume() async {
//     if (_isPlaying) {
//       pause();
//     } else {
//       resume();
//     }
//   }
//
//   void seek(Duration position) async {
//     await _audioPlayer.seek(position);
//   }
//
//   void playNextSong() {
//     if (_currentSongIndex != null) {
//       if (_currentSongIndex! < _playList.length - 1) {
//         currentSongIndex = _currentSongIndex! + 1;
//       } else {
//         currentSongIndex = 0;
//       }
//     }
//   }
//
//   void playPreviousSong() {
//     if (_currentDuration.inSeconds > 2) {
//       seek(Duration.zero);
//     } else {
//       if (_currentSongIndex! > 0) {
//         currentSongIndex = _currentSongIndex! - 1;
//       } else {
//         currentSongIndex = _playList.length - 1;
//       }
//     }
//   }
//
//   void listenToDuration() {
//     _audioPlayer.onDurationChanged.listen((newDuration) {
//       _totalDuration = newDuration;
//       notifyListeners();
//     });
//
//     _audioPlayer.onPositionChanged.listen((newPosition) {
//       _currentDuration = newPosition;
//       notifyListeners();
//     });
//
//     _audioPlayer.onPlayerComplete.listen((event) {
//       playNextSong();
//     });
//   }
// }


//this code for that that i am going to song to store in hive
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'song.dart';

class PlayListProvider extends ChangeNotifier {
  // Hive boxes
  late Box<Song> _songsBox;
  late Box<Song> _favouritesBox;
  late Box<List> _foldersBox;
  late Box _settingsBox; // ✅ for current index persistence

  // Playlist
  List<Song> _playList = [];
  List<Song> get playList => _playList;

  int? _currentSongIndex;
  int? get currentSongIndex => _currentSongIndex;

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      // Save to Hive for persistence
      _settingsBox.put("currentIndex", newIndex);
      play();
    }

    notifyListeners();
  }

  // Favourites
  List<Song> _favourites = [];
  List<Song> get favourites => _favourites;

  // Folders
  Map<String, List<Song>> _folders = {};
  Map<String, List<Song>> get folders => _folders;

  // Audio Player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  // Constructor
  PlayListProvider() {
    _initHive();
    listenToDuration();
  }

  Future<void> _initHive() async {
    _songsBox = await Hive.openBox<Song>('songsBox');
    _favouritesBox = await Hive.openBox<Song>('favouritesBox');
    _foldersBox = await Hive.openBox<List>('foldersBox');
    _settingsBox = await Hive.openBox('settingsBox');

    // Load songs
    _playList = _songsBox.values.toList();

    // Load favourites
    _favourites = _favouritesBox.values.toList();

    // Load folders
    final storedFolders = _foldersBox.toMap();
    _folders = storedFolders.map((key, value) {
      return MapEntry(key.toString(), value.cast<Song>());
    });

    // Restore last played index
    _currentSongIndex = _settingsBox.get("currentIndex");

    notifyListeners();
  }

  /*
   * 🎵 SONG MANAGEMENT
   */
  Future<void> addSong(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'flac'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;

      final ext = file.extension?.toLowerCase();
      if (ext == null || !['mp3', 'wav', 'm4a', 'aac', 'flac'].contains(ext)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Unsupported file type")),
        );
        return;
      }

      // 🚫 Duplicate check (songName)
      if (_playList.any((s) => s.songName == file.name)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ '${file.name}' already exists!")),
        );
        return;
      }

      final newSong = Song(
        songName: file.name,
        artistName: "Unknown",
        albumArtImagePath: 'assets/images/default.jpg',
        audioPath: file.path!, // full device path
      );

      _playList.add(newSong);
      await _songsBox.put(newSong.songName, newSong);

      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🎵 Added: ${file.name}")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ No file selected")),
      );
    }
  }

  Future<void> deleteSong(Song song) async {
    _playList.remove(song);

    // remove from favourites
    _favourites.remove(song);
    if (_favouritesBox.isOpen) await _favouritesBox.delete(song.songName);

    // remove from Hive songs
    if (_songsBox.isOpen) await _songsBox.delete(song.songName);

    // remove from folders
    for (final folderName in _folders.keys.toList()) {
      final list = _folders[folderName]!;
      if (list.remove(song)) {
        if (_foldersBox.isOpen) await _foldersBox.put(folderName, list);
      }
    }

    notifyListeners();
  }

  // Toggle favourite
  void toggleFavourite(Song song) {
    if (_favourites.contains(song)) {
      _favourites.remove(song);
      _favouritesBox.delete(song.songName);
    } else {
      _favourites.add(song);
      _favouritesBox.put(song.songName, song);
    }
    notifyListeners();
  }

  bool isFavourite(Song song) => _favourites.contains(song);

  // Folder management
  Future<void> createFolder(String folderName) async {
    if (!_folders.containsKey(folderName)) {
      _folders[folderName] = [];
      if (_foldersBox.isOpen) await _foldersBox.put(folderName, <Song>[]);
      notifyListeners();
    }
  }

  Future<void> addSongToFolder(String folderName, Song song) async {
    if (_folders.containsKey(folderName)) {
      _folders[folderName]!.add(song);
      if (_foldersBox.isOpen) await _foldersBox.put(folderName, _folders[folderName]!);
      notifyListeners();
    }
  }

  Future<void> renameFolder(String oldName, String newName) async {
    if (_folders.containsKey(oldName) && !_folders.containsKey(newName)) {
      final songs = _folders.remove(oldName)!;
      _folders[newName] = songs;
      if (_foldersBox.isOpen) {
        await _foldersBox.delete(oldName);
        await _foldersBox.put(newName, songs);
      }
      notifyListeners();
    }
  }

  Future<void> deleteFolder(String folderName) async {
    if (_folders.containsKey(folderName)) {
      _folders.remove(folderName);
      if (_foldersBox.isOpen) await _foldersBox.delete(folderName);
      notifyListeners();
    }
  }

  Future<void> moveSongToFolder(String fromFolder, String toFolder, Song song) async {
    if (_folders.containsKey(fromFolder) && _folders.containsKey(toFolder)) {
      _folders[fromFolder]!.remove(song);
      _folders[toFolder]!.add(song);
      if (_foldersBox.isOpen) {
        await _foldersBox.put(fromFolder, _folders[fromFolder]!);
        await _foldersBox.put(toFolder, _folders[toFolder]!);
      }
      notifyListeners();
    }
  }

  /*
   * 🎧 AUDIO PLAYER
   */
  void play() async {
    if (_currentSongIndex == null) return;
    final Song song = _playList[_currentSongIndex!];

    await _audioPlayer.stop();

    if (song.audioPath.contains('/')) {
      // Local file
      await _audioPlayer.play(DeviceFileSource(song.audioPath));
    } else {
      // Asset file
      await _audioPlayer.play(AssetSource("audio/${song.audioPath}"));
    }

    _isPlaying = true;
    notifyListeners();
  }

  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playList.length - 1) {
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }

  void playPreviousSong() {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playList.length - 1;
      }
    }
  }

  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }
}
