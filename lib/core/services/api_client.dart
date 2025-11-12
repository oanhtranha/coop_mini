import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  static final _baseUrl = dotenv.env['API_URL']!;

  // GET
  static Future<dynamic> get(String endpoint, {String? token}) async {
    final res = await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: _headers(token),
    );
    return _process(res);
  }

  // POST
  static Future<dynamic> post(String endpoint, Map<String, dynamic> body, {String? token}) async {
    final res = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: _headers(token),
      body: jsonEncode(body),
    );
    return _process(res);
  }

  //PUT
  static Future<dynamic> put(String endpoint, {Map<String, dynamic>? body, String? token}) async {
    final res = await http.put(
      Uri.parse('$_baseUrl$endpoint'),
      headers: _headers(token),
      body: body != null ? jsonEncode(body) : null,
    );
    return _process(res);
  }

  // DELETE
  static Future<dynamic> delete(String endpoint, {String? token}) async {
    final res = await http.delete(
      Uri.parse('$_baseUrl$endpoint'),
      headers: _headers(token),
    );
    return _process(res);
  }

  // Headers
  static Map<String, String> _headers(String? token) {
    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Xử lý response
  static dynamic _process(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body);
    } else {
      final body = res.body.isNotEmpty ? jsonDecode(res.body) : {};
      final errorMessage = body['message'] ?? 'Error: ${res.statusCode}';
      throw Exception(errorMessage);
    }
  }
}
