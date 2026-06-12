import 'package:personalized_learning_system_mobile/core/network/api_client.dart';

class AuthService {
  AuthService(this._client);

  final ApiClient _client;

  Future<Object?> login(String email, String password) {
    return _client.post(
      '/auth/login',
      body: <String, Object?>{'email': email, 'password': password},
    );
  }

  Future<Object?> currentUser() {
    return _client.get('/auth/user');
  }

  Future<void> logout() async {
    await _client.post('/auth/logout');
  }
}
