import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // NOTE: 10.0.2.2 is used instead of localhost when running on an Android emulator.
  static const String baseUrl = 'http://localhost:3000';

  // Calls POST /auth/login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'token': data['token'], 'role': data['role']};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Login failed.'};
    }
  }

  // Calls POST /auth/register
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {'success': true, 'message': data['message']};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Registration failed.'};
    }
  }
}