import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  final String apiUrl = "http://192.168.1.45:7777";

  Future<Map<String, dynamic>> getUser(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token: $token');

    if (token == null) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/getUser/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<Map<String, dynamic>> editUser(int userId, Map<String, String> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token: $token');

    if (token == null) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }

    final response = await http.put(
      Uri.parse('$apiUrl/editUser/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(userData),
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update user');
    }
  }
}
