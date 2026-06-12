import 'package:personalized_learning_system_mobile/core/network/api_client.dart';

class FlashcardService {
  FlashcardService(this._client);

  final ApiClient _client;

  Future<Object?> getVocabularies() {
    return _client.get(
      '/vocabularies/all',
      query: <String, Object?>{'page': 0, 'size': 50},
    );
  }

  Future<Object?> getGrammars() {
    return _client.get(
      '/grammars/all',
      query: <String, Object?>{'page': 0, 'size': 30},
    );
  }
}
