import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  final VoidCallback onToggleTheme;
  const SideDrawer({required this.onToggleTheme, super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      width: 200,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(leading: Icon(Icons.bookmark), title: Text("Saved Words")),
          ListTile(
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) => onToggleTheme(),
              activeColor: Colors.white,
              activeTrackColor: Colors.blue,
              // inactiveTrackColor: Colors.red,
            ),
            title: Text('Theme'),
          ),
          ListTile(leading: Icon(Icons.logout), title: Text("Logout")),
        ],
      ),
    );
  }
}
