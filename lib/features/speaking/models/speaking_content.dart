import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';

class SpeakingContent {
  const SpeakingContent({
    required this.id,
    required this.title,
    required this.category,
    required this.level,
    this.imageUrl = '',
    this.createdAt,
  });

  final int id;
  final String title;
  final String category;
  final String level;
  final String imageUrl;
  final DateTime? createdAt;

  factory SpeakingContent.fromJson(JsonMap json) {
    return SpeakingContent(
      id: intValue(json, const ['contentSpeakingId', 'id']),
      title: stringValue(json, const ['title'], fallback: 'Bài luyện nói'),
      category: stringValue(json, const ['category'], fallback: 'GREETINGS'),
      level: stringValue(json, const ['jlptLevel', 'level'], fallback: 'N5'),
      imageUrl: stringValue(json, const ['image', 'imageUrl']),
      createdAt: DateTime.tryParse(stringValue(json, const ['createdAt'])),
    );
  }
}

class SpeakingDialogue {
  const SpeakingDialogue({
    required this.id,
    required this.questionJapanese,
    required this.questionVietnamese,
    required this.answerJapanese,
    required this.answerVietnamese,
  });

  final int id;
  final String questionJapanese;
  final String questionVietnamese;
  final String answerJapanese;
  final String answerVietnamese;

  factory SpeakingDialogue.fromJson(JsonMap json) {
    return SpeakingDialogue(
      id: intValue(json, const ['dialogueId', 'id']),
      questionJapanese: stringValue(json, const ['questionJp']),
      questionVietnamese: stringValue(json, const ['questionVn']),
      answerJapanese: stringValue(json, const ['answerJp']),
      answerVietnamese: stringValue(json, const ['answerVn']),
    );
  }
}

class PronunciationResult {
  const PronunciationResult({
    required this.recognizedText,
    required this.accuracyScore,
    required this.fluencyScore,
    required this.completenessScore,
    required this.pronunciationScore,
    required this.prosodyScore,
    required this.advices,
  });

  final String recognizedText;
  final double accuracyScore;
  final double fluencyScore;
  final double completenessScore;
  final double pronunciationScore;
  final double prosodyScore;
  final List<String> advices;

  factory PronunciationResult.fromJson(JsonMap json) {
    double score(String key) {
      final value = json[key];
      return value is num
          ? value.toDouble()
          : double.tryParse(value?.toString() ?? '') ?? 0;
    }

    final adviceData = json['advices'];
    return PronunciationResult(
      recognizedText: stringValue(json, const ['recognizedText']),
      accuracyScore: score('accuracyScore'),
      fluencyScore: score('fluencyScore'),
      completenessScore: score('completenessScore'),
      pronunciationScore: score('pronunciationScore'),
      prosodyScore: score('prosodyScore'),
      advices: adviceData is List
          ? adviceData.map((item) => item.toString()).toList()
          : const <String>[],
    );
  }
}
