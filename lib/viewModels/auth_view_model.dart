import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../data/models/request_model.dart';

class AuthViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? error;

// SIGN IN
  Future<bool> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final user = await AuthService.signIn(
        SignInRequest(email: email, password: password),
      );
      return user != null;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

// SIGN UP
  Future<bool> signup(String email, String username, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await AuthService.signUp(
        SignUpRequest(email: email, username: username, password: password),
      );
      return response != null;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
