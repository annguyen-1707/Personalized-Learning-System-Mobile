import 'package:personalized_learning_system_mobile/core/network/api_client.dart';
import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';
import 'package:personalized_learning_system_mobile/features/auth/models/app_user.dart';
import 'package:personalized_learning_system_mobile/features/auth/models/auth_token.dart';
import 'package:personalized_learning_system_mobile/features/auth/services/auth_service.dart';

class AuthRepository {
  AuthRepository(this._service, this._client);

  final AuthService _service;
  final ApiClient _client;

  Future<AppUser> signIn(String email, String password) async {
    final response = await _service.login(email, password);
    final data = asJsonMap(extractData(response));
    final token = AuthToken.fromJson(data);
    if (token.accessToken.isNotEmpty) {
      _client.setAccessToken(token.accessToken);
    }
    return getCurrentUser();
  }

  Future<AppUser> getCurrentUser() async {
    final response = await _service.currentUser();
    return AppUser.fromJson(asJsonMap(extractData(response)));
  }

  Future<void> signOut() async {
    try {
      await _service.logout();
    } finally {
      _client.setAccessToken(null);
    }
  }
}
