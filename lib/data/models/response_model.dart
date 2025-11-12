import '/data/models/user_model.dart';

class SignUpResponse {
  final String message;
  final User user;

  SignUpResponse({required this.message, required this.user});
}