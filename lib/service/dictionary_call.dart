import 'dart:convert';

import 'package:dictonary/model/dictionary_data.dart';
import 'package:http/http.dart' as http;

class DictionaryCall {
  final base='https://api.dictionaryapi.dev/api/v2/entries/en/';

  Future<List<DictionaryData>> getDictionaryData(String word) async {
    final url = '$base$word';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic>jsonData = jsonDecode(response.body);
      return jsonData.map((data) => DictionaryData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}