import 'package:personalized_learning_system_mobile/core/network/api_client.dart';

class ProfileService {
  ProfileService(this._client);

  final ApiClient _client;

  Future<Object?> overview() {
    return _client.get('/profile/overview/learning_progress');
  }

  Future<Object?> information() {
    return _client.get('/profile/information');
  }
}
