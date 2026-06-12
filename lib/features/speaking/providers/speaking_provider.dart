import 'package:flutter/foundation.dart';
import 'package:personalized_learning_system_mobile/features/speaking/models/speaking_content.dart';
import 'package:personalized_learning_system_mobile/features/speaking/repositories/speaking_repository.dart';

class SpeakingProvider extends ChangeNotifier {
  SpeakingProvider(this._repository);

  final SpeakingRepository _repository;

  List<SpeakingContent> contents = const <SpeakingContent>[];
  List<SpeakingDialogue> dialogues = const <SpeakingDialogue>[];
  PronunciationResult? result;
  bool isLoading = false;
  bool isLoadingDetail = false;
  bool isAssessing = false;
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
      errorMessage = 'Không thể tải danh sách bài luyện nói.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDialogues(int contentId) async {
    isLoadingDetail = true;
    errorMessage = null;
    dialogues = const <SpeakingDialogue>[];
    result = null;
    notifyListeners();
    try {
      dialogues = await _repository.getDialogues(contentId);
      if (dialogues.isNotEmpty) {
        result = await _repository.getProgress(dialogues.first.id);
      }
    } catch (_) {
      errorMessage = 'Không thể tải nội dung bài luyện nói.';
    } finally {
      isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<void> loadProgress(int dialogueId) async {
    result = null;
    notifyListeners();
    result = await _repository.getProgress(dialogueId);
    notifyListeners();
  }

  Future<bool> assess({
    required int dialogueId,
    required String audioPath,
  }) async {
    isAssessing = true;
    errorMessage = null;
    notifyListeners();
    try {
      result = await _repository.assessPronunciation(
        dialogueId: dialogueId,
        audioPath: audioPath,
      );
      return true;
    } catch (_) {
      errorMessage = 'Không thể chấm phát âm. Vui lòng ghi âm và thử lại.';
      return false;
    } finally {
      isAssessing = false;
      notifyListeners();
    }
  }
}
