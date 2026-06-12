import 'package:flutter/foundation.dart';
import 'package:personalized_learning_system_mobile/features/courses/models/course.dart';
import 'package:personalized_learning_system_mobile/features/courses/models/lesson.dart';
import 'package:personalized_learning_system_mobile/features/courses/repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  CourseProvider(this._repository);

  final CourseRepository _repository;

  List<Course> courses = const <Course>[];
  List<Lesson> lessons = const <Lesson>[];
  bool isLoading = false;

  Future<void> loadCourses() async {
    isLoading = true;
    notifyListeners();
    courses = await _repository.getCourses();
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadLessons(Course course) async {
    print("load lessons for ${course.toString()}");
    lessons = const <Lesson>[];
    isLoading = true;
    notifyListeners();
    lessons = await _repository.getLessons(course.id);
    isLoading = false;
    notifyListeners();
  }
}
