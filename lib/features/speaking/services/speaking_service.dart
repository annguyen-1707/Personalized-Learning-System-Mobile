import 'package:personalized_learning_system_mobile/core/network/api_client.dart';

class SpeakingService {
  SpeakingService(this._client);

  final ApiClient _client;

  Future<Object?> getContents() {
    return _client.get(
      '/content-speaking-client',
      query: const <String, Object?>{'page': 1, 'size': 100},
    );
  }

  Future<Object?> getDialogues(int contentId) {
    return _client.get('/content-speaking-client/$contentId/dialogues');
  }

  Future<Object?> getProgress(int dialogueId) {
    return _client.get(
      '/content-speaking-client/dialogue/$dialogueId/progress',
    );
  }

  Future<Object?> assessPronunciation({
    required int dialogueId,
    required String audioPath,
  }) {
    return _client.postMultipart(
      '/content-speaking-client/upload',
      filePath: audioPath,
      contentType: 'audio/wav',
      query: <String, Object?>{'dialogueId': dialogueId},
    );
  }
}
