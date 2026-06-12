import 'package:flutter/widgets.dart';
import 'package:personalized_learning_system_mobile/core/network/api_client.dart';
import 'package:personalized_learning_system_mobile/features/auth/providers/auth_provider.dart';
import 'package:personalized_learning_system_mobile/features/auth/repositories/auth_repository.dart';
import 'package:personalized_learning_system_mobile/features/auth/services/auth_service.dart';
import 'package:personalized_learning_system_mobile/features/courses/providers/course_provider.dart';
import 'package:personalized_learning_system_mobile/features/courses/repositories/course_repository.dart';
import 'package:personalized_learning_system_mobile/features/courses/services/course_service.dart';
import 'package:personalized_learning_system_mobile/features/exercises-course/providers/exercise_provider.dart';
import 'package:personalized_learning_system_mobile/features/exercises-course/repositories/exercise_repository.dart';
import 'package:personalized_learning_system_mobile/features/exercises-course/services/exercise_service.dart';
import 'package:personalized_learning_system_mobile/features/listening/providers/listening_provider.dart';
import 'package:personalized_learning_system_mobile/features/listening/repositories/listening_repository.dart';
import 'package:personalized_learning_system_mobile/features/listening/services/listening_service.dart';
import 'package:personalized_learning_system_mobile/features/profile/providers/profile_provider.dart';
import 'package:personalized_learning_system_mobile/features/profile/repositories/profile_repository.dart';
import 'package:personalized_learning_system_mobile/features/profile/services/profile_service.dart';
import 'package:personalized_learning_system_mobile/features/reading/providers/reading_provider.dart';
import 'package:personalized_learning_system_mobile/features/reading/repositories/reading_repository.dart';
import 'package:personalized_learning_system_mobile/features/reading/services/reading_service.dart';
import 'package:personalized_learning_system_mobile/features/speaking/providers/speaking_provider.dart';
import 'package:personalized_learning_system_mobile/features/speaking/repositories/speaking_repository.dart';
import 'package:personalized_learning_system_mobile/features/speaking/services/speaking_service.dart';

class AppState extends ChangeNotifier {
  AppState() {
    final apiClient = ApiClient();
    auth = AuthProvider(AuthRepository(AuthService(apiClient), apiClient));
    courses = CourseProvider(CourseRepository(CourseService(apiClient)));
    exercises = ExerciseProvider(
      ExerciseRepository(ExerciseService(apiClient)),
    );
    listening = ListeningProvider(
      ListeningRepository(ListeningService(apiClient)),
    );
    speaking = SpeakingProvider(SpeakingRepository(SpeakingService(apiClient)));
    _reading = ReadingProvider(ReadingRepository(ReadingService(apiClient)));
    profile = ProfileProvider(ProfileRepository(ProfileService(apiClient)));

    auth.addListener(notifyListeners);
    courses.addListener(notifyListeners);
    exercises.addListener(notifyListeners);
    listening.addListener(notifyListeners);
    speaking.addListener(notifyListeners);
    _reading!.addListener(notifyListeners);
    profile.addListener(notifyListeners);
  }

  late final AuthProvider auth;
  late final CourseProvider courses;
  late final ExerciseProvider exercises;
  late final ListeningProvider listening;
  late final SpeakingProvider speaking;
  ReadingProvider? _reading;

  ReadingProvider get reading {
    final current = _reading;
    if (current != null) {
      return current;
    }

    // Hot reload does not rerun AppState's constructor for an existing object.
    final provider = ReadingProvider(
      ReadingRepository(ReadingService(ApiClient())),
    );
    provider.addListener(notifyListeners);
    _reading = provider;
    return provider;
  }

  late final ProfileProvider profile;

  int tabIndex = 0;
  bool _loadedInitialData = false;

  void changeTab(int index) {
    tabIndex = index;
    notifyListeners();
  }

  Future<void> loadInitialData() async {
    if (_loadedInitialData) {
      return;
    }
    _loadedInitialData = true;
    await Future.wait([courses.loadCourses(), profile.load()]);
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    required AppState state,
    required super.child,
    super.key,
  }) : super(notifier: state);

  static AppState watch(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope is missing from the widget tree.');
    return scope!.notifier!;
  }

  static AppState read(BuildContext context) {
    final element = context
        .getElementForInheritedWidgetOfExactType<AppStateScope>();
    final scope = element?.widget as AppStateScope?;
    assert(scope != null, 'AppStateScope is missing from the widget tree.');
    return scope!.notifier!;
  }
}
