import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';
import 'package:personalized_learning_system_mobile/features/flashcard/models/grammar.dart';
import 'package:personalized_learning_system_mobile/features/flashcard/models/vocabulary.dart';

class ReadingContent {
  const ReadingContent({
    required this.id,
    required this.title,
    required this.category,
    required this.level,
    required this.scriptJapanese,
    required this.scriptVietnamese,
    this.audioUrl = '',
    this.imageUrl = '',
    this.publishedAt = '',
    this.vocabularies = const <Vocabulary>[],
    this.grammars = const <Grammar>[],
  });

  final int id;
  final String title;
  final String category;
  final String level;
  final String scriptJapanese;
  final String scriptVietnamese;
  final String audioUrl;
  final String imageUrl;
  final String publishedAt;
  final List<Vocabulary> vocabularies;
  final List<Grammar> grammars;

  factory ReadingContent.fromJson(JsonMap json) {
    final vocabularyData = json['vocabularies'];
    final grammarData = json['grammars'];
    return ReadingContent(
      id: intValue(json, const ['contentReadingId', 'id']),
      title: stringValue(json, const ['title']),
      category: stringValue(json, const ['category']),
      level: stringValue(json, const ['jlptLevel', 'level']),
      scriptJapanese: stringValue(json, const ['scriptJp']),
      scriptVietnamese: stringValue(json, const ['scriptVn']),
      audioUrl: stringValue(json, const ['audioFile', 'audioUrl']),
      imageUrl: stringValue(json, const ['image', 'imageUrl']),
      publishedAt: stringValue(json, const ['timeNew', 'createdAt']),
      vocabularies: vocabularyData is List
          ? vocabularyData
                .map((item) => Vocabulary.fromJson(asJsonMap(item)))
                .toList()
          : const <Vocabulary>[],
      grammars: grammarData is List
          ? grammarData
                .map((item) => Grammar.fromJson(asJsonMap(item)))
                .toList()
          : const <Grammar>[],
    );
  }

  ReadingContent copyWith({
    List<Vocabulary>? vocabularies,
    List<Grammar>? grammars,
  }) {
    return ReadingContent(
      id: id,
      title: title,
      category: category,
      level: level,
      scriptJapanese: scriptJapanese,
      scriptVietnamese: scriptVietnamese,
      audioUrl: audioUrl,
      imageUrl: imageUrl,
      publishedAt: publishedAt,
      vocabularies: vocabularies ?? this.vocabularies,
      grammars: grammars ?? this.grammars,
    );
  }
}
