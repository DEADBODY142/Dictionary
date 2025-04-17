import 'package:dictonary/Drawer/drawer.dart';
import 'package:dictonary/commonpage/bookmark.dart';
import 'package:dictonary/homeapi.dart';
import 'package:flutter/material.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  List<String> bookmarkedWords = [];
  @override
  void initState() {
    super.initState();
    loadBookmark();
  }

  void loadBookmark() async {
    final bookmark = await getData();
    setState(() {
      bookmarkedWords = bookmark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('Saved Words'))),
      drawer: SideDrawer(),
      body:
          bookmarkedWords.isEmpty
              ? const Center(child: Text('No Saved Words'))
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: bookmarkedWords.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(top: 15.0),
                          child: ListTile(
                            title: Text(bookmarkedWords[index]),
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => HomePage(
                                          initialword: bookmarkedWords[index],
                                        ),
                                  ),
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
