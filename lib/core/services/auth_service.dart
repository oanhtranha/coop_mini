import '/data/models/user_model.dart';
import '/data/models/request_model.dart';
import '/data/models/response_model.dart';
import 'session_manager.dart';
import 'api_client.dart';

class AuthService {

  // Sign up
  static Future<SignUpResponse?> signUp(SignUpRequest request) async {
  final json = await ApiClient.post('/user/signup', request.toJson());
  final message = json['message'] ?? 'Sign up successful!';
  final user = User(
    id: json['userId'],
    email: request.email,
    username: request.username,
    createdAt: DateTime.now());
    return SignUpResponse(message: message, user: user);
}

  // Sign in
 static Future<User?> signIn(SignInRequest request) async {
  final json = await ApiClient.post('/user/login', request.toJson());

  // Lấy token từ response
  final token = json['token'] as String?;

  if (token == null) {
    throw Exception('Token not found');
  }
  // Lưu token vào session
  await SessionManager.saveToken(token);
  // Tạo User từ response
  final userJson = json['user'] as Map<String, dynamic>;
  final user = User.fromJson(userJson);
  // Lưu email
  await SessionManager.saveUser(user);
  return user;
}


  // Logout
  static Future<void> logout() async {
    final token = await SessionManager.getToken();
    await ApiClient.post('/user/logout', {} , token: token);
    await SessionManager.clearUser();
  }
}
