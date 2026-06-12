import 'package:flutter_test/flutter_test.dart';
import 'package:personalized_learning_system_mobile/features/exercises-course/models/exercise.dart';

void main() {
  test('parses lesson exercise and answer correctness', () {
    final exercise = Exercise.fromJson(<String, dynamic>{
      'id': 12,
      'title': 'Ôn tập bài 1',
      'duration': 180,
      'content': <Map<String, dynamic>>[
        <String, dynamic>{
          'exerciseQuestionId': 21,
          'questionText': 'こんにちは nghĩa là gì?',
          'answerQuestions': <Map<String, dynamic>>[
            <String, dynamic>{
              'answerId': 31,
              'answerText': 'Xin chào',
              'correct': true,
            },
            <String, dynamic>{
              'answerId': 32,
              'answerText': 'Tạm biệt',
              'correct': false,
            },
          ],
        },
      ],
    });

    expect(exercise.id, 12);
    expect(exercise.questions, hasLength(1));
    expect(exercise.questions.first.answers, hasLength(2));
    expect(exercise.questions.first.answers.first.isCorrect, isTrue);
  });
}
