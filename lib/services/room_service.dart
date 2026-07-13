import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/room.dart';
import 'token_storage.dart';

class RoomService {
  static const String baseUrl = 'http://localhost:3000';

  // GET /rooms — works for both admin and customer (just needs to be logged in)
  static Future<List<Room>> getRooms() async {
    final token = await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/rooms'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Room.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load rooms');
    }
  }

  // POST /rooms — admin only
  static Future<Map<String, dynamic>> addRoom(String name, double price, String status) async {
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/rooms'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name, 'price': price, 'status': status}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {'success': true, 'message': data['message']};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Failed to add room.'};
    }
  }

  // PUT /rooms/:id — admin only
  static Future<Map<String, dynamic>> updateRoom(int id, String name, double price, String status) async {
    final token = await TokenStorage.getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/rooms/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name, 'price': price, 'status': status}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'message': data['message']};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Failed to update room.'};
    }
  }
}