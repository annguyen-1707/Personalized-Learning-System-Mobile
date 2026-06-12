import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';

class Exercise {
  const Exercise({
    required this.id,
    required this.title,
    required this.duration,
    required this.questions,
  });

  final int id;
  final String title;
  final int duration;
  final List<ExerciseQuestion> questions;

  factory Exercise.fromJson(JsonMap json) {
    final content = json['content'];
    return Exercise(
      id: intValue(json, const ['id', 'exerciseId']),
      title: stringValue(json, const [
        'title',
        'name',
      ], fallback: 'Bài tập củng cố'),
      duration: intValue(json, const ['duration']),
      questions: content is List
          ? content
                .map((item) => ExerciseQuestion.fromJson(asJsonMap(item)))
                .toList()
          : const <ExerciseQuestion>[],
    );
  }

  static const samples = <Exercise>[
    Exercise(
      id: 1,
      title: 'Kiểm tra nhanh',
      duration: 300,
      questions: [
        ExerciseQuestion(
          id: 1,
          text: '「Câu hỏi Demo',
          answers: [
            ExerciseAnswer(id: 1, text: 'Chào hỏi', isCorrect: true),
            ExerciseAnswer(id: 2, text: 'Cảm ơn'),
            ExerciseAnswer(id: 3, text: 'Xin lỗi'),
          ],
        ),
        ExerciseQuestion(
          id: 2,
          text: 'Mẫu câu nào dùng để giới thiệu tên?',
          answers: [
            ExerciseAnswer(id: 4, text: 'わたしは ... です', isCorrect: true),
            ExerciseAnswer(id: 5, text: 'いただきます'),
            ExerciseAnswer(id: 6, text: 'おやすみなさい'),
          ],
        ),
      ],
    ),
  ];
}

class ExerciseQuestion {
  const ExerciseQuestion({
    required this.id,
    required this.text,
    required this.answers,
  });

  final int id;
  final String text;
  final List<ExerciseAnswer> answers;

  factory ExerciseQuestion.fromJson(JsonMap json) {
    final answers = json['answerQuestions'];
    return ExerciseQuestion(
      id: intValue(json, const ['exerciseQuestionId', 'questionId', 'id']),
      text: stringValue(json, const ['questionText', 'text']),
      answers: answers is List
          ? answers
                .map((item) => ExerciseAnswer.fromJson(asJsonMap(item)))
                .toList()
          : const <ExerciseAnswer>[],
    );
  }
}

class ExerciseAnswer {
  const ExerciseAnswer({
    required this.id,
    required this.text,
    this.isCorrect = false,
  });

  final int id;
  final String text;
  final bool isCorrect;

  factory ExerciseAnswer.fromJson(JsonMap json) {
    return ExerciseAnswer(
      id: intValue(json, const ['answerId', 'id']),
      text: stringValue(json, const ['answerText', 'text']),
      isCorrect: json['correct'] == true || json['isCorrect'] == true,
    );
  }
}
