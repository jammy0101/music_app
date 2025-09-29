// import 'package:flutter/material.dart';
// import 'package:music/pages/setting.dart';
//
// class MyDrawer extends StatelessWidget {
//   const MyDrawer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       child: Column(
//         children: [
//           //logo
//           DrawerHeader(
//             child: Center(
//               child: Text('MUSIC',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
//             ),
//           ),
//           //home title
//           Padding(
//             padding: const EdgeInsets.only(left: 20),
//             child: ListTile(
//               title: Text('H O M E'),
//               leading: Icon(Icons.home),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//           SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.only(left: 20),
//             child: ListTile(
//               title: Text('S E T T I N G '),
//               leading: Icon(Icons.settings),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => Setting()),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:music/pages/setting.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // App Logo / Header
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.music_note, size: 40, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    'MUSIC APP',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Home
          _buildDrawerItem(
            context,
            icon: Icons.home,
            title: "Home",
            onTap: () => Navigator.pop(context),
          ),

          // Playlists
          _buildDrawerItem(
            context,
            icon: Icons.folder,
            title: "Playlists",
            onTap: () {
              Navigator.pop(context);
              // Navigate to playlists screen
            },
          ),

          // Favourites
          _buildDrawerItem(
            context,
            icon: Icons.favorite,
            title: "Favourites",
            onTap: () {
              Navigator.pop(context);
              // Navigate to favourites screen
            },
          ),

          // Recently Played
          _buildDrawerItem(
            context,
            icon: Icons.history,
            title: "Recently Played",
            onTap: () {
              Navigator.pop(context);
              // Navigate to recent screen
            },
          ),

          const Divider(thickness: 1, indent: 15, endIndent: 15),

          // Settings
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: "Settings",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Setting()),
              );
            },
          ),

          // About
          _buildDrawerItem(
            context,
            icon: Icons.info,
            title: "About",
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Music App",
                applicationVersion: "1.0.0",
                applicationLegalese: "© 2025 Your Name",
              );
            },
          ),

          const Spacer(),

          // Footer
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "🎵 Enjoy the rhythm!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper Widget for Drawer Items
  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
        required String title,
        required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).iconTheme.color),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        onTap: onTap,
      ),
    );
  }
}
