import 'package:flutter/foundation.dart';
import 'package:personalized_learning_system_mobile/features/auth/models/app_user.dart';
import 'package:personalized_learning_system_mobile/features/auth/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository);

  final AuthRepository _repository;

  AppUser? user;
  bool isLoading = false;
  String? errorMessage;

  bool get isAuthenticated => user != null;

  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      user = await _repository.signIn(email, password);
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // void continueAsDemo() {
  //   user = AppUser.demo;
  //   errorMessage = null;
  //   notifyListeners();
  // }

  Future<void> logout() async {
    try {
      await _repository.signOut();
    } catch (e) {
      debugPrint("Logout API error: $e");
    }
    user = null;
    notifyListeners();
  }
}
