import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';
import 'package:personalized_learning_system_mobile/features/auth/models/app_user.dart';
import 'package:personalized_learning_system_mobile/features/profile/models/learning_overview.dart';
import 'package:personalized_learning_system_mobile/features/profile/services/profile_service.dart';

class ProfileRepository {
  ProfileRepository(this._service);

  final ProfileService _service;

  Future<LearningOverview> getOverview() async {
    try {
      final response = await _service.overview();
      return LearningOverview.fromJson(asJsonMap(extractData(response)));
    } catch (_) {
      return LearningOverview.demo;
    }
  }

  Future<AppUser> getInformation() async {
    try {
      final response = await _service.information();
      return AppUser.fromJson(asJsonMap(extractData(response)));
    } catch (_) {
      return AppUser.demo;
    }
  }
}
