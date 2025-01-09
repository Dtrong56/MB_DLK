import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../System/variable.dart';

class LoginController {
  Future<Map<String, dynamic>> login(String username, String password) async {
        
    final url = Uri.parse('$apiUrl/login');
    try {
      print('Sending request to $url with username: $username and password: $password');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',  // Thiết lập header Content-Type
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),  // Gửi dữ liệu dưới dạng JSON
      );

      print('Received response with status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Đăng nhập thành công
        final data = json.decode(response.body);
        final token = data['token'];

        print('Login successful, token: $token');

        // Giải mã JWT để lấy userID
        final payload = json.decode(
          utf8.decode(base64Url.decode(base64Url.normalize(token.split('.')[1]))),
        );
        final userID = payload['sub']['userID'];

        print('Decoded JWT payload: $payload');

        // Lưu trữ userID và token vào SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userID', userID);
        await prefs.setString('token', token);  // Lưu token vào SharedPreferences

        // Log quá trình lưu trữ userID và token
        print('UserID: $userID');
        print('UserID và token đã được lưu vào SharedPreferences');

        return {'success': true, 'msg': data['msg'], 'token': token};
      } else if (response.statusCode == 404) {
        // Thông tin đăng nhập không đúng
        final data = json.decode(response.body);
        print('Login failed, reason: ${data['msg']}');
        return {'success': false, 'msg': data['msg']};
      } else {
        // Xử lý lỗi khác
        print('Unexpected Error: ${response.statusCode} - ${response.reasonPhrase}');
        return {'success': false, 'msg': 'Đã xảy ra lỗi không xác định'};
      }
    } catch (e) {
      print('Error: $e');
      return {'success': false, 'msg': 'Đã xảy ra lỗi không xác định'};
    }
  }

  // Phương thức để lấy userID từ SharedPreferences
  Future<int?> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userID = prefs.getInt('userID');
    // Log quá trình lấy userID
    print('UserID lấy từ SharedPreferences: $userID');
    return userID;
  }

  // Phương thức để lấy token từ SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    // Log quá trình lấy token
    print('Token lấy từ SharedPreferences: $token');
    return token;
  }
}

