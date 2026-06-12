import 'package:personalized_learning_system_mobile/core/network/api_client.dart';

class CourseService {
  CourseService(this._client);

  final ApiClient _client;

  Future<Object?> getCourses() {
    return _client.get(
      '/subjects/client-all-courses',
      query: <String, Object?>{'page': 0, 'size': 20},
    );
  }

  Future<Object?> getLessons(int courseId) {
    return _client.get(
      '/lessons',
      query: <String, Object?>{'subjectId': courseId, 'page': 0, 'size': 30},
    );
  }
}
