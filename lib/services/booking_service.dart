import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';

class BookingService {
  static const String baseUrl = 'http://localhost:3000';

  // POST /bookings
  static Future<Map<String, dynamic>> bookRoom(int roomId) async {
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'room_id': roomId}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {'success': true, 'message': data['message'] ?? 'Room booked successfully!'};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Booking failed.'};
    }
  }
}