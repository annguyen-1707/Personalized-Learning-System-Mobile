import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';

class ListeningContent {
  const ListeningContent({
    required this.id,
    required this.title,
    required this.category,
    required this.level,
    required this.audioUrl,
    this.imageUrl = '',
    this.scriptJapanese = '',
    this.scriptVietnamese = '',
  });

  final int id;
  final String title;
  final String category;
  final String level;
  final String audioUrl;
  final String imageUrl;
  final String scriptJapanese;
  final String scriptVietnamese;

  factory ListeningContent.fromJson(JsonMap json) {
    return ListeningContent(
      id: intValue(json, const ['contentListeningId', 'id']),
      title: stringValue(json, const ['title'], fallback: 'Bài luyện nghe'),
      category: stringValue(json, const ['category'], fallback: 'CONVERSATION'),
      level: stringValue(json, const ['jlptLevel', 'level'], fallback: 'N5'),
      audioUrl: stringValue(json, const ['audioFile', 'audioUrl']),
      imageUrl: stringValue(json, const ['image', 'imageUrl']),
      scriptJapanese: stringValue(json, const ['scriptJp']),
      scriptVietnamese: stringValue(json, const ['scriptVn']),
    );
  }

  static const samples = <ListeningContent>[
    ListeningContent(
      id: 1,
      title: 'Chào hỏi tại trường học',
      category: 'CONVERSATION',
      level: 'N5',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      scriptJapanese: '田中：おはようございます。\n山田：おはようございます。',
      scriptVietnamese: 'Tanaka: Chào buổi sáng.\nYamada: Chào buổi sáng.',
    ),
  ];
}

class ListeningQuestion {
  const ListeningQuestion({
    required this.id,
    required this.text,
    required this.answers,
  });

  final int id;
  final String text;
  final List<ListeningAnswer> answers;

  factory ListeningQuestion.fromJson(JsonMap json) {
    final answers = json['answerQuestions'];
    return ListeningQuestion(
      id: intValue(json, const ['exerciseQuestionId', 'questionId', 'id']),
      text: stringValue(json, const ['questionText', 'text']),
      answers: answers is List
          ? answers
                .map((item) => ListeningAnswer.fromJson(asJsonMap(item)))
                .toList()
          : const <ListeningAnswer>[],
    );
  }

  static const samples = <ListeningQuestion>[
    ListeningQuestion(
      id: 1,
      text: 'Hai người đang nói lời gì?',
      answers: [
        ListeningAnswer(id: 1, text: 'Chào buổi sáng', isCorrect: true),
        ListeningAnswer(id: 2, text: 'Chúc ngủ ngon'),
        ListeningAnswer(id: 3, text: 'Cảm ơn'),
      ],
    ),
  ];
}

class ListeningAnswer {
  const ListeningAnswer({
    required this.id,
    required this.text,
    this.isCorrect = false,
  });

  final int id;
  final String text;
  final bool isCorrect;

  factory ListeningAnswer.fromJson(JsonMap json) {
    return ListeningAnswer(
      id: intValue(json, const ['answerId', 'id']),
      text: stringValue(json, const ['answerText', 'text']),
      isCorrect: json['correct'] == true || json['isCorrect'] == true,
    );
  }
}

class ListeningResult {
  const ListeningResult({
    required this.questionId,
    required this.answerText,
    required this.isCorrect,
  });

  final int questionId;
  final String answerText;
  final bool isCorrect;

  factory ListeningResult.fromJson(JsonMap json) {
    return ListeningResult(
      questionId: intValue(json, const ['questionId']),
      answerText: stringValue(json, const ['answerText']),
      isCorrect: json['correct'] == true,
    );
  }
}
