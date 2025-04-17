import 'package:dictonary/Drawer/drawer.dart';
import 'package:dictonary/Pages/main_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String? initialword;
  const HomePage({ super.key,this.initialword});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('VERBIFY')),

        //* Added sidebar
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        actions: [
          // Switch(
          //   value: Theme.of(context).brightness == Brightness.dark,
          //   onChanged: (bool value) {
          //     widget.onToggleTheme(); // Trigger theme toggle
          //   },
          // ),
        ],
      ),
      drawer: SideDrawer(),

      body: MainPage(initialWord: widget.initialword),
    );
  }
}
