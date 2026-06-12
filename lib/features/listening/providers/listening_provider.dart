import 'package:flutter/foundation.dart';
import 'package:personalized_learning_system_mobile/features/listening/models/listening_content.dart';
import 'package:personalized_learning_system_mobile/features/listening/repositories/listening_repository.dart';

class ListeningProvider extends ChangeNotifier {
  ListeningProvider(this._repository);

  final ListeningRepository _repository;

  List<ListeningContent> contents = const <ListeningContent>[];
  List<ListeningQuestion> questions = const <ListeningQuestion>[];
  bool isLoading = false;
  bool isLoadingDetail = false;
  bool isSubmitting = false;
  String? errorMessage;

  Future<void> loadContents() async {
    if (isLoading) {
      return;
    }
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      contents = await _repository.getContents();
    } catch (_) {
      errorMessage = 'Không thể tải danh sách bài nghe.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<ListeningContent> loadLesson(ListeningContent content) async {
    isLoadingDetail = true;
    errorMessage = null;
    questions = const <ListeningQuestion>[];
    notifyListeners();
    try {
      final results = await Future.wait<Object>([
        _repository.getContent(content),
        _repository.getQuestions(content.id),
      ]);
      questions = results[1] as List<ListeningQuestion>;
      return results[0] as ListeningContent;
    } catch (_) {
      errorMessage = 'Không thể tải nội dung bài nghe.';
      return content;
    } finally {
      isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<List<ListeningResult>> submit({
    required ListeningContent content,
    required Map<int, int> answers,
  }) async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();
    try {
      return await _repository.submitAnswers(
        contentId: content.id,
        questions: questions,
        selectedAnswers: answers,
      );
    } catch (_) {
      errorMessage = 'Không thể chấm bài nghe. Vui lòng thử lại.';
      return const <ListeningResult>[];
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
