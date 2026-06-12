import 'package:personalized_learning_system_mobile/core/network/api_client.dart';

class ReadingService {
  ReadingService(this._client);

  final ApiClient _client;

  Future<Object?> getContents() {
    return _client.get(
      '/content_reading/public',
      query: <String, Object?>{'page': 1, 'size': 30},
    );
  }

  Future<Object?> getVocabularies(int contentId) {
    return _client.get('/content_reading/$contentId/vocabularies');
  }

  Future<Object?> getGrammars(int contentId) {
    return _client.get('/content_reading/$contentId/grammars');
  }

  Future<Object?> checkCompleted({
    required int userId,
    required int contentId,
  }) {
    return _client.get(
      '/progressReading/checkStatus',
      query: <String, Object?>{'userId': userId, 'contentReadingId': contentId},
    );
  }

  Future<Object?> markCompleted({required int userId, required int contentId}) {
    return _client.post(
      '/progressReading/markAsDone',
      query: <String, Object?>{'userId': userId, 'contentReadingId': contentId},
    );
  }
}
