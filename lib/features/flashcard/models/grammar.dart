import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';

class Grammar {
  const Grammar({
    required this.id,
    required this.title,
    required this.structure,
    required this.meaning,
    required this.level,
    this.example = '',
    this.usage = '',
  });

  final int id;
  final String title;
  final String structure;
  final String meaning;
  final String level;
  final String example;
  final String usage;

  factory Grammar.fromJson(JsonMap json) {
    return Grammar(
      id: intValue(json, const ['grammarId', 'id']),
      title: stringValue(json, const ['titleJp', 'title']),
      structure: stringValue(json, const ['structure']),
      meaning: stringValue(json, const ['meaning']),
      level: stringValue(json, const ['jlptLevel', 'level'], fallback: 'N5'),
      example: stringValue(json, const ['example']),
      usage: stringValue(json, const ['usage']),
    );
  }

  static const samples = <Grammar>[
    Grammar(
      id: 1,
      title: 'Demo',
      structure: 'N + です',
      meaning: 'là, thì, ở dạng lịch sự',
      level: 'N5',
      example: '私は学生です。',
    ),
    Grammar(
      id: 2,
      title: 'ます',
      structure: 'Vます',
      meaning: 'động từ dạng lịch sự',
      level: 'N5',
      example: '毎朝六時に起きます。',
    ),
  ];
}
