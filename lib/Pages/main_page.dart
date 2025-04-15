import 'package:dictonary/main.dart';
import 'package:dictonary/model/dictionary_data.dart';
import 'package:dictonary/service/dictionary_call.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final player = AudioPlayer();
  List<DictionaryData> dictionaryData = [];
  bool isLoading = false;
  String _error = '';
  String phoneticData = '';
  bool isBookmarked = false;
  List<String> bookmarkedWords = [];

  final TextEditingController search = TextEditingController();

  Future<void> getDictionaryData(String word) async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedData = await DictionaryCall().getDictionaryData(word);

      setState(() {
        isLoading = false;
        dictionaryData = fetchedData;

        phoneticData =
            dictionaryData.isNotEmpty ? dictionaryData[0].phonetic ?? '' : '';
        if (phoneticData.isEmpty && dictionaryData.isNotEmpty) {
          for (var phonetic in dictionaryData[0].phonetics) {
            if (phonetic.text != null) {
              phoneticData = phonetic.text!;
              break;
            }
          }
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> adjectiveSynonyms = [];
    List<String> adjectiveAntonyms = [];

    for (var entry in dictionaryData) {
      for (var meaning in entry.meanings) {
        if (meaning.partOfSpeech == 'adjective') {
          // Add from meaning level
          adjectiveSynonyms.addAll(meaning.synonyms);
          adjectiveAntonyms.addAll(meaning.antonyms);
        }
      }
    }

    // Remove duplicates
    adjectiveSynonyms = adjectiveSynonyms.toSet().toList();
    adjectiveAntonyms = adjectiveAntonyms.toSet().toList();

    // Debug print
    print('Adjective Synonyms: $adjectiveSynonyms');
    print('Adjective Antonyms: $adjectiveAntonyms');
    print("Saved words: $bookmarkedWords");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: search,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () => search.clear(),
                icon: const Icon(Icons.clear),
              ),

              hintText: 'Enter a word',
            ),
            onSubmitted: (value) {
              getDictionaryData(search.text);
            },
          ),
          const SizedBox(height: 20),
          if (isLoading) const CircularProgressIndicator(),
          if (_error.isNotEmpty)
            AlertDialog(
              title: Text('Error'),
              content: Text(_error),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            )
          else if (!isLoading && dictionaryData.isNotEmpty && _error.isEmpty)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Center(
                      child: Text(
                        dictionaryData[0].word,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(phoneticData, style: TextStyle(fontSize: 20)),

                          IconButton(
                            onPressed: () {
                              final audioUrl =
                                  dictionaryData[0].phonetics[0].audio;
                              if (audioUrl != null) {
                                player.setUrl(audioUrl);
                                player.play();
                              }
                            },
                            icon: Icon(Icons.volume_up_rounded),
                          ),
                          //* Bookmark Button
                          IconButton(
                            onPressed: () {
                              setState(() {
                                // isBookmarked = !isBookmarked;
                                if (bookmarkedWords.contains(
                                  dictionaryData[0].word,
                                )) {
                                  bookmarkedWords.remove(
                                    dictionaryData[0].word,
                                  );
                                } else {
                                  bookmarkedWords.add(dictionaryData[0].word);
                                }
                              });
                            },
                            icon: Icon(
                              bookmarkedWords.contains(dictionaryData[0].word)
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...dictionaryData[0].meanings.map(
                      (meaning) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meaning.partOfSpeech,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...meaning.definitions.map(
                            (definition) => Padding(
                              padding: EdgeInsets.only(left: 1),
                              child: Text(
                                '${definition.definition}\n',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (adjectiveSynonyms.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Synonyms:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            spacing: 5.0,
                            children:
                                adjectiveSynonyms
                                    .map(
                                      (s) => ActionChip(
                                        label: Text(s),
                                        onPressed: () {
                                          search.text = s;
                                          getDictionaryData(s);
                                        },
                                      ),
                                    )
                                    .toList(),
                          ),
                        ],
                      ),

                    SizedBox(height: 16),
                    if (adjectiveAntonyms.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Antonyms:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 5.0,
                            children:
                                adjectiveAntonyms
                                    .map(
                                      (a) => ActionChip(
                                        label: Text(a),
                                        onPressed: () {
                                          search.text = a;
                                          getDictionaryData(a);
                                        },
                                      ),
                                    )
                                    .toList(),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
