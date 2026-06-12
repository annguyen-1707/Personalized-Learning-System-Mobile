import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';

class AuthToken {
  const AuthToken({required this.accessToken, this.refreshToken = ''});

  final String accessToken;
  final String refreshToken;

  factory AuthToken.fromJson(JsonMap json) {
    return AuthToken(
      accessToken: stringValue(json, const ['accessToken', 'token']),
      refreshToken: stringValue(json, const ['refreshToken']),
    );
  }
}
