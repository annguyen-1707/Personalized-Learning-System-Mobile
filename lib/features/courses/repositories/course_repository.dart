import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';
import 'package:personalized_learning_system_mobile/features/courses/models/course.dart';
import 'package:personalized_learning_system_mobile/features/courses/models/lesson.dart';
import 'package:personalized_learning_system_mobile/features/courses/services/course_service.dart';

class CourseRepository {
  CourseRepository(this._service);

  final CourseService _service;

  Future<List<Course>> getCourses() async {
    try {
      final response = await _service.getCourses();
      final courses = extractList(response).map(Course.fromJson).toList();
      return courses.isEmpty ? Course.samples : courses;
    } catch (error) {
      print(error);
      return Course.samples;
    }
  }

  Future<List<Lesson>> getLessons(int courseId) async {
    try {
      final response = await _service.getLessons(courseId);
      final lessons = extractList(response).map(Lesson.fromJson).toList();
      return lessons.isEmpty ? Lesson.samples : lessons;
    } catch (error) {
      print(error);
      return Lesson.samples;
    }
  }
}
