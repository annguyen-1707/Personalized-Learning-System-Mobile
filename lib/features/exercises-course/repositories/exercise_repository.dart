import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';
import 'package:personalized_learning_system_mobile/features/exercises-course/models/exercise.dart';
import 'package:personalized_learning_system_mobile/features/exercises-course/services/exercise_service.dart';

class ExerciseRepository {
  ExerciseRepository(this._service);

  final ExerciseService _service;

  Future<List<Exercise>> getExercises(int lessonId) async {
    try {
      final response = await _service.getExercises(lessonId);
      final exercises = extractList(response).map(Exercise.fromJson).toList();
      return exercises.isEmpty ? Exercise.samples : exercises;
    } catch (_) {
      return Exercise.samples;
    }
  }

  Future<void> submitAnswers({
    required int userId,
    required int exerciseId,
    required int totalTime,
    required Map<int, int> answers,
  }) async {
    await _service.submitAnswers(
      userId: userId,
      exerciseId: exerciseId,
      totalTime: totalTime,
      answers: answers,
    );
  }
}
