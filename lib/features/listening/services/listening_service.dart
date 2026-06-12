import 'package:personalized_learning_system_mobile/core/network/api_client.dart';

class ListeningService {
  ListeningService(this._client);

  final ApiClient _client;

  Future<Object?> getContents() {
    return _client.get(
      '/content_listening/public',
      query: <String, Object?>{'page': 1, 'size': 30},
    );
  }

  Future<Object?> getContent(int contentId) {
    return _client.get('/content_listening/details/$contentId');
  }

  Future<Object?> getQuestions(int contentId) {
    return _client.get('/question/content_listening/$contentId');
  }

  Future<Object?> submitAnswers({
    required int contentId,
    required List<Map<String, Object?>> answers,
  }) {
    return _client.post(
      '/content-listening/submit-answers',
      query: <String, Object?>{'contentListeningId': contentId},
      body: answers,
    );
  }
}
