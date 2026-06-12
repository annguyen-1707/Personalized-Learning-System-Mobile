import 'package:flutter/foundation.dart';
import 'package:personalized_learning_system_mobile/features/profile/models/learning_overview.dart';
import 'package:personalized_learning_system_mobile/features/profile/repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider(this._repository);

  final ProfileRepository _repository;

  LearningOverview overview = LearningOverview.demo;
  bool isLoading = false;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    overview = await _repository.getOverview();
    isLoading = false;
    notifyListeners();
  }
}
