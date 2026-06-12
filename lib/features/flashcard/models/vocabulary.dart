import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';

class Vocabulary {
  const Vocabulary({
    required this.id,
    required this.kanji,
    required this.kana,
    required this.meaning,
    required this.level,
    this.romaji = '',
    this.example = '',
    this.partOfSpeech = '',
  });

  final String id;
  final String kanji;
  final String kana;
  final String romaji;
  final String meaning;
  final String level;
  final String example;
  final String partOfSpeech;

  factory Vocabulary.fromJson(JsonMap json) {
    return Vocabulary(
      id: stringValue(json, const ['vocabularyId', 'id']),
      kanji: stringValue(json, const ['kanji']),
      kana: stringValue(json, const ['kana']),
      romaji: stringValue(json, const ['romaji']),
      meaning: stringValue(json, const ['meaning']),
      level: stringValue(json, const ['jlptLevel', 'level'], fallback: 'N5'),
      example: stringValue(json, const ['example']),
      partOfSpeech: stringValue(json, const ['partOfSpeech']),
    );
  }

  static const samples = <Vocabulary>[
    Vocabulary(
      id: '1',
      kanji: 'Demo',
      kana: 'べんきょう',
      romaji: 'benkyou',
      meaning: 'học tập',
      level: 'N5',
      example: '毎日日本語を勉強します。',
      partOfSpeech: 'NOUN',
    ),
    Vocabulary(
      id: '2',
      kanji: '先生',
      kana: 'せんせい',
      romaji: 'sensei',
      meaning: 'giáo viên',
      level: 'N5',
      example: '田中先生は親切です。',
      partOfSpeech: 'NOUN',
    ),
    Vocabulary(
      id: '3',
      kanji: '静か',
      kana: 'しずか',
      romaji: 'shizuka',
      meaning: 'yên tĩnh',
      level: 'N5',
      example: '図書館は静かです。',
      partOfSpeech: 'NA_ADJECTIVE',
    ),
  ];
}
