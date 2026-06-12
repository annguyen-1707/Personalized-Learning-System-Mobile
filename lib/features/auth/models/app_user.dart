import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.membershipLevel,
    this.avatar = '',
    this.roleName = 'USER',
  });

  final int id;
  final String email;
  final String fullName;
  final String membershipLevel;
  final String avatar;
  final String roleName;

  bool get isVip => membershipLevel != 'NORMAL';

  factory AppUser.fromJson(JsonMap json) {
    return AppUser(
      id: intValue(json, const ['userId', 'id']),
      email: stringValue(json, const ['email'], fallback: 'learner@fuohayo.vn'),
      fullName: stringValue(json, const [
        'fullName',
        'name',
        'username',
      ], fallback: 'FU OHAYO Learner'),
      membershipLevel: stringValue(json, const [
        'membershipLevel',
      ], fallback: 'NORMAL'),
      avatar: stringValue(json, const ['avatar', 'avatarUrl']),
      roleName: stringValue(json, const ['roleName'], fallback: 'USER'),
    );
  }

  static const demo = AppUser(
    id: 1,
    email: 'student@fuohayo.vn',
    fullName: 'Nguyen An',
    membershipLevel: 'ONE_MONTH',
  );
}
