import 'package:flutter/foundation.dart';
import 'package:personalized_learning_system_mobile/features/reading/models/reading_content.dart';
import 'package:personalized_learning_system_mobile/features/reading/repositories/reading_repository.dart';

class ReadingProvider extends ChangeNotifier {
  ReadingProvider(this._repository);

  final ReadingRepository _repository;

  List<ReadingContent> contents = const <ReadingContent>[];
  bool isLoading = false;
  bool isLoadingDetail = false;
  bool isCompleting = false;
  bool isCompleted = false;
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
    } catch (error) {
      contents = const <ReadingContent>[];
      errorMessage = 'Không thể tải danh sách bài đọc: $error';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<ReadingContent> loadArticle({
    required ReadingContent content,
    required int userId,
  }) async {
    isLoadingDetail = true;
    isCompleted = false;
    errorMessage = null;
    notifyListeners();
    try {
      final results = await Future.wait<Object>([
        _repository.getContent(content),
        _repository.checkCompleted(userId: userId, contentId: content.id),
      ]);
      isCompleted = results[1] as bool;
      return results[0] as ReadingContent;
    } catch (error) {
      errorMessage = 'Không thể tải nội dung bài đọc: $error';
      return content;
    } finally {
      isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> markCompleted({
    required int userId,
    required int contentId,
  }) async {
    isCompleting = true;
    errorMessage = null;
    notifyListeners();
    try {
      final saved = await _repository.markCompleted(
        userId: userId,
        contentId: contentId,
      );
      if (saved) {
        isCompleted = true;
      }
      return saved;
    } catch (_) {
      errorMessage = 'Chưa thể lưu tiến độ bài đọc.';
      return false;
    } finally {
      isCompleting = false;
      notifyListeners();
    }
  }
}
