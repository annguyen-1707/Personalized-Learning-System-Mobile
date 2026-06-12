import 'package:personalized_learning_system_mobile/core/network/api_client.dart';

class ExerciseService {
  ExerciseService(this._client);

  final ApiClient _client;

  Future<Object?> getExercises(int lessonId) {
    return _client.get(
      '/exercise-questions',
      query: <String, Object?>{'lessonId': lessonId, 'page': 0, 'size': 20},
    );
  }

  Future<Object?> submitAnswers({
    required int userId,
    required int exerciseId,
    required int totalTime,
    required Map<int, int> answers,
  }) {
    return _client.post(
      '/do-exercises-course/submit-result-details',
      body: <String, Object?>{
        'userId': userId,
        'exerciseId': exerciseId,
        'totalTime': totalTime,
        'userQuestionResponseRequests': answers.entries
            .map(
              (entry) => <String, Object?>{
                'questionId': entry.key,
                'selectedAnswerId': entry.value,
              },
            )
            .toList(),
      },
    );
  }
}
