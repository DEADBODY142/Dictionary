import 'package:shared_preferences/shared_preferences.dart';

Future<void> addData(String word) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> bookmarks = await getData();
  if (!bookmarks.contains(word)) {
    bookmarks.add(word);
    await prefs.setStringList("bookmarkedWords", bookmarks);
  }
}

Future<void> removeData(String word) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> bookmarks = await getData();
  if (bookmarks.contains(word)) {
    bookmarks.remove(word);
    await prefs.setStringList("bookmarkedWords", bookmarks);
  }
}

Future<List<String>> getData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> bookmarkedWords = prefs.getStringList("bookmarkedWords") ?? [];
  return bookmarkedWords;
}
