import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';
import 'package:personalized_learning_system_mobile/features/speaking/models/speaking_content.dart';
import 'package:personalized_learning_system_mobile/features/speaking/services/speaking_service.dart';

class SpeakingRepository {
  SpeakingRepository(this._service);

  final SpeakingService _service;

  Future<List<SpeakingContent>> getContents() async {
    final response = await _service.getContents();
    return extractList(
      response,
    ).map(SpeakingContent.fromJson).where((content) => content.id > 0).toList();
  }

  Future<List<SpeakingDialogue>> getDialogues(int contentId) async {
    final response = await _service.getDialogues(contentId);
    return extractList(response)
        .map(SpeakingDialogue.fromJson)
        .where((dialogue) => dialogue.id > 0)
        .toList();
  }

  Future<PronunciationResult?> getProgress(int dialogueId) async {
    try {
      final response = await _service.getProgress(dialogueId);
      final data = asJsonMap(extractData(response));
      return data.isEmpty ? null : PronunciationResult.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<PronunciationResult> assessPronunciation({
    required int dialogueId,
    required String audioPath,
  }) async {
    final response = await _service.assessPronunciation(
      dialogueId: dialogueId,
      audioPath: audioPath,
    );
    final data = asJsonMap(extractData(response));
    if (data.isEmpty) {
      throw const FormatException('Kết quả chấm phát âm bị trống.');
    }
    return PronunciationResult.fromJson(data);
  }
}
