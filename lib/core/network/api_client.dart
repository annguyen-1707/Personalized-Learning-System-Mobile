import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:personalized_learning_system_mobile/core/config/app_config.dart';
import 'package:personalized_learning_system_mobile/core/network/api_exception.dart';

class ApiClient {
  ApiClient({String baseUrl = AppConfig.defaultBaseUrl})
    : _baseUri = Uri.parse(baseUrl);

  final Uri _baseUri;
  String? _accessToken;

  void setAccessToken(String? token) {
    _accessToken = token;
  }

  Future<Object?> get(
    String path, {
    Map<String, Object?> query = const <String, Object?>{},
  }) {
    return _send('GET', path, query: query);
  }

  Future<Object?> post(
    String path, {
    Object? body,
    Map<String, Object?> query = const <String, Object?>{},
  }) {
    return _send('POST', path, body: body, query: query);
  }

  Future<Object?> put(
    String path, {
    Object? body,
    Map<String, Object?> query = const <String, Object?>{},
  }) {
    return _send('PUT', path, body: body, query: query);
  }

  Future<Object?> postMultipart(
    String path, {
    required String filePath,
    String fileField = 'file',
    String contentType = 'application/octet-stream',
    Map<String, String> fields = const <String, String>{},
    Map<String, Object?> query = const <String, Object?>{},
  }) async {
    final uri = _baseUri.replace(
      path: _joinPath(_baseUri.path, path),
      queryParameters: _queryParameters(query),
    );
    final request = http.MultipartRequest('POST', uri)
      ..headers['Accept'] = 'application/json'
      ..fields.addAll(fields);

    if (_accessToken != null && _accessToken!.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $_accessToken';
    }

    final mediaType = MediaType.parse(contentType);
    request.files.add(
      await http.MultipartFile.fromPath(
        fileField,
        filePath,
        contentType: mediaType,
      ),
    );

    try {
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 45),
      );
      final response = await http.Response.fromStream(streamedResponse);
      final decoded = _decodeResponseBody(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          _messageFrom(decoded) ?? response.reasonPhrase ?? 'Request failed',
          statusCode: response.statusCode,
        );
      }
      return decoded;
    } on TimeoutException {
      throw ApiException('Chấm phát âm quá thời gian chờ.');
    } on http.ClientException catch (error) {
      throw ApiException('Không kết nối được máy chủ: ${error.message}');
    } on FormatException {
      throw ApiException('Máy chủ trả về dữ liệu không hợp lệ.');
    }
  }

  Future<Object?> _send(
    String method,
    String path, {
    Object? body,
    Map<String, Object?> query = const <String, Object?>{},
  }) async {
    final uri = _baseUri.replace(
      path: _joinPath(_baseUri.path, path),
      queryParameters: _queryParameters(query),
    );

    try {
      final headers = <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      if (_accessToken != null && _accessToken!.isNotEmpty) {
        headers['Authorization'] = 'Bearer $_accessToken';
      }

      final request = http.Request(method, uri)..headers.addAll(headers);

      if (body != null) {
        request.body = jsonEncode(body);
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 6),
      );

      final response = await http.Response.fromStream(streamedResponse);
      final decoded = _decodeResponseBody(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          _messageFrom(decoded) ?? response.reasonPhrase ?? 'Request failed',
          statusCode: response.statusCode,
        );
      }

      return decoded;
    } on TimeoutException {
      throw ApiException('Kết nối máy chủ quá thời gian chờ.');
    } on http.ClientException catch (error) {
      throw ApiException('Không kết nối được máy chủ: ${error.message}');
    } on FormatException {
      throw ApiException('Máy chủ trả về dữ liệu không hợp lệ.');
    }
  }

  static Object? _decodeResponseBody(String responseText) {
    if (responseText.trim().isEmpty) {
      return null;
    }

    try {
      return jsonDecode(responseText);
    } on FormatException {
      return responseText;
    }
  }

  static Map<String, String>? _queryParameters(Map<String, Object?> query) {
    final cleaned = <String, String>{};

    for (final entry in query.entries) {
      final value = entry.value;

      if (value != null) {
        cleaned[entry.key] = value.toString();
      }
    }

    return cleaned.isEmpty ? null : cleaned;
  }

  static String _joinPath(String basePath, String path) {
    final normalizedBase = basePath.endsWith('/')
        ? basePath.substring(0, basePath.length - 1)
        : basePath;

    final normalizedPath = path.startsWith('/') ? path : '/$path';

    return '$normalizedBase$normalizedPath';
  }

  static String? _messageFrom(Object? decoded) {
    if (decoded is Map) {
      return decoded['message']?.toString() ?? decoded['error']?.toString();
    }

    if (decoded is String && decoded.trim().isNotEmpty) {
      return decoded;
    }

    return null;
  }
}

//MacBook
// │
// ├─ Spring Boot
// │  localhost:8080
// │
// └─ Android Emulator
//      │
//      ├─ localhost
//      │  = emulator
//      │
//      └─ 10.0.2.2: IP đặc biệt của googlr để giúp Android Emulator truy cập
//         = localhost của Mac
// joinPath để
