import 'package:flutter/foundation.dart';
import 'package:personalized_learning_system_mobile/features/exercises-course/models/exercise.dart';
import 'package:personalized_learning_system_mobile/features/exercises-course/repositories/exercise_repository.dart';

class ExerciseProvider extends ChangeNotifier {
  ExerciseProvider(this._repository);

  final ExerciseRepository _repository;

  List<Exercise> exercises = const <Exercise>[];
  bool isLoading = false;
  bool isSubmitting = false;
  String? errorMessage;

  Future<void> loadForLesson(int lessonId) async {
    exercises = const <Exercise>[];
    errorMessage = null;
    isLoading = true;
    notifyListeners();

    try {
      exercises = await _repository.getExercises(lessonId);
    } catch (_) {
      errorMessage = 'Không thể tải bài tập. Vui lòng thử lại.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submit({
    required int userId,
    required Exercise exercise,
    required int totalTime,
    required Map<int, int> answers,
  }) async {
    errorMessage = null;
    isSubmitting = true;
    notifyListeners();

    try {
      await _repository.submitAnswers(
        userId: userId,
        exerciseId: exercise.id,
        totalTime: totalTime,
        answers: answers,
      );
      return true;
    } catch (_) {
      errorMessage = 'Chưa thể lưu kết quả lên máy chủ.';
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
