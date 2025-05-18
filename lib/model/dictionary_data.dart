class DictionaryData {
  final String word;
  final String? phonetic;
  final List<Phonetic> phonetics;
  final String? origin;
  final List<Meaning> meanings;

  DictionaryData({
    required this.word,
    this.phonetic,
    required this.phonetics,
    this.origin,
    required this.meanings,
  });

  factory DictionaryData.fromJson(Map<String, dynamic> json) {
    return DictionaryData(
      word: json['word'] ?? '',
      phonetic: json['phonetic'],
      phonetics: (json['phonetics'] as List<dynamic>?)
              ?.map((e) => Phonetic.fromJson(e))
              .toList() ??
          [],
      origin: json['origin'],
      meanings: (json['meanings'] as List<dynamic>)
          .map((e) => Meaning.fromJson(e))
          .toList(),
    );
  }

  static List<DictionaryData> fromList(List<dynamic> data) {
    return data.map((e) => DictionaryData.fromJson(e)).toList();
  }
}

class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;
  
  List<String> synonyms = <String>[];
  List<String> antonyms = <String>[];

  Meaning({
    required this.partOfSpeech,
    required this.definitions,
    required this.synonyms,
    required this.antonyms,
  });

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      partOfSpeech: json['partOfSpeech'] ?? '',
      definitions: (json['definitions'] as List<dynamic>)
          .map((e) => Definition.fromJson(e))
          .toList(),
          synonyms: (json['synonyms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
          antonyms: (json['antonyms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class Definition {
  final String definition;
  final String? example;
  final List<String> synonyms;
  final List<String> antonyms;

  Definition({
    required this.definition,
    this.example,
    required this.synonyms,
    required this.antonyms,
  });

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      definition: json['definition'] ?? '',
      example: json['example'],
      synonyms:
          (json['synonyms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      antonyms:
          (json['antonyms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class Phonetic {
  final String? text;
  final String? audio;

  Phonetic({
    this.text,
    this.audio,
  });

  factory Phonetic.fromJson(Map<String, dynamic> json) {
    return Phonetic(
      text: json['text'],
      audio: json['audio'],
    );
  }
}
